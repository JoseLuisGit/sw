import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'models/Materias.dart';
import 'package:latlong/latlong.dart';
import 'ListEstudents.dart';
import 'utils/Urls.dart';
import 'Biometric.dart';
import 'FormEvento.dart';
import 'package:http/http.dart' as http;

class HomeDoc extends StatefulWidget {
  final int id;
  final String tipo;
  final int idSemestre;
  HomeDoc({Key key, this.id, this.tipo, this.idSemestre}) : super(key: key);
  @override
  _HomeDocState createState() => _HomeDocState();
}

class _HomeDocState extends State<HomeDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Opacity(
        child: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => new AgregarCaso(
            //               id: widget.id,
            //             )));
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
        opacity: 1,
      ),
      body: FutureBuilder(
          future: fetchMateriass(http.Client(), widget.id, widget.idSemestre),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? MateriasLista(
                    materias: snapshot.data,
                    idsemestre: widget.idSemestre,
                    iddocente: widget.id,
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class MateriasLista extends StatefulWidget {
  final List<Materias> materias;
  final int idsemestre;
  final int iddocente;
  MateriasLista({Key key, this.materias, this.idsemestre, this.iddocente})
      : super(key: key);

  @override
  _MateriasListaState createState() => _MateriasListaState();
}

class _MateriasListaState extends State<MateriasLista> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: new Slidable(
            delegate: new SlidableDrawerDelegate(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.white,
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: Icon(Icons.layers),
                  foregroundColor: Colors.white,
                ),
                title: new Text(
                    '${widget.materias[index].nombre} - ${widget.materias[index].sigla}'),
                subtitle: new Text(widget.materias[index].gsigla == null
                    ? "No hay descripcion"
                    : widget.materias[index].gsigla),
              ),
            ),
            actions: <Widget>[
              new IconSlideAction(
                  caption: 'Agregar Evento',
                  color: Colors.blueAccent,
                  icon: Icons.event,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new FormEvent(
                                  iddocente: widget.iddocente,
                                  idsemestre: widget.idsemestre,
                                  idgrupo: widget.materias[index].idgrupo,
                                  nombre: widget.materias[index].nombre,
                                )));
                  }),
            ],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Asistencia',
                color: Colors.green,
                icon: Icons.fingerprint,
                onTap: () async {
                  _verificar(widget.idsemestre, widget.materias[index].idgrupo);
                },
              ),
            ],
          ),
          onTap: () {
            //   int selectedId = widget.materias[index].id;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ListStudent(
                          idgrupo: widget.materias[index].idgrupo,
                          idSemestre: widget.idsemestre,
                          materia: widget.materias[index].nombre,
                          nombregrupo: widget.materias[index].gsigla,
                          iddocente: widget.iddocente,
                        )));
          },
        );
      },
      itemCount: widget.materias.length,
    );
  }

  _verificar(int idsemestre, int idgrupo) async {
    Position localizacionActual;
    try {
      localizacionActual = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          print(localizacionActual);
    } catch (e) {
      localizacionActual = null;
    }
    final response = await http
        .get("$URL_Horario/verificar?idsemestre=$idsemestre&idgrupo=$idgrupo");
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('No hay Internet');
    }

    var datauser = json.decode(response.body);
    print(response.body);
    if (datauser.length == 0) {
      _showDialog('No esta en el dia correcto!!!');
    } else {
      String horas = datauser[0]['hora_inicio'];
      var horainicial = DateTime.parse('1998-04-21 $horas');

      String horaActual = datauser[0]['descripcion'];

      var horaActualD = DateTime.parse('1998-04-21 $horaActual');
      print(horainicial);
      print(horaActualD);
      Duration diferencia = horaActualD.difference(horainicial);

      int minutos = diferencia.inMinutes;
      print(minutos);
      if (minutos >= 0 && minutos <= 45) {
        Distance distance = new Distance();

        if (localizacionActual != null) {
          double distancia = distance(
              LatLng(localizacionActual.latitude, localizacionActual.longitude),
              LatLng(double.parse(datauser[0]['latitud']), double.parse(datauser[0]['longitud'])));
          print('distancia $distancia');
          if (distancia <= 50) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new Biometric(
                      idsemestre: idsemestre,  
                      tipo: 'doc',
                      idgrupo: idgrupo,
                      latitud: localizacionActual.latitude,
                      longitud: localizacionActual.longitude,
                    )));
          } else {
            _showDialog('No esta en la ubicacion establecida!!!');
          }
        }
      } else {
        _showDialog('No cumple con la hora establecida!!!');
      }
    }
  }

  void _showDialog(String motivo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //  title: new Text("Adventencia"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.error,
                  size: 150,
                  color: Colors.red,
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Error',
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Container(
                    height: 200,
                    child: Text(
                      'Por los siguientes motivos: \n * $motivo ',
                      style: TextStyle(fontSize: 20.0),
                    )),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

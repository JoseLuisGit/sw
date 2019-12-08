import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'Biometric.dart';
import 'utils/Urls.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'models/Evento.dart';
import 'EstudiantesListaEventos.dart';

class ListEventos extends StatefulWidget {
  final int iddt;
  final String nombre;
  final int idgrupo;
  final int idsemestre;
  final int iddocente;
  final String tipo;
  ListEventos(
      {Key key,
      this.iddt,
      this.nombre,
      this.idgrupo,
      this.iddocente,
      this.idsemestre,
      this.tipo})
      : super(key: key);

  @override
  _ListEventosState createState() => _ListEventosState();
}

class _ListEventosState extends State<ListEventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Eventos de ${widget.nombre}'),
        ),
        body: FutureBuilder(
            future: widget.tipo == 'doc'
                ? fetchEventos(http.Client(), widget.idgrupo, widget.idsemestre,
                    widget.iddocente)
                : fetchEventosEstudiante(
                    http.Client(),
                    widget.iddt,
                    widget.idgrupo,
                  ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? EventoLista(
                      evento: snapshot.data,
                      tipo: widget.tipo,
                    )
                  : Center(child: CircularProgressIndicator());
            }));
  }
}

class EventoLista extends StatefulWidget {
  final String tipo;
  final List<Evento> evento;
  EventoLista({Key key, this.evento, this.tipo}) : super(key: key);

  @override
  _EventoListaState createState() => _EventoListaState();
}

class _EventoListaState extends State<EventoLista> {
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
                  child: Icon(Icons.event),
                  foregroundColor: Colors.white,
                ),
                trailing: widget.evento[index].condicion
                    ? Text(
                        'Asistido',
                        style: TextStyle(
                            backgroundColor: Colors.green, color: Colors.white),
                      )
                    : Text('Inasistido',
                        style: TextStyle(
                            backgroundColor: Colors.red, color: Colors.white)),
                title: new Text('${widget.evento[index].nombre}'),
                subtitle: new Text(
                    'Descripcion: ${widget.evento[index].descripcion}'),
              ),
            ),
            // actions: <Widget>[
            //   new IconSlideAction(
            //       caption: 'Camara',
            //       color: Colors.blueAccent,
            //       icon: Icons.camera,
            //       onTap: () {

            //       }),
            // ],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Ver',
                color: Colors.green,
                icon: Icons.remove_red_eye,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventoDetalle(
                                evento: widget.evento[index],
                                tipo: widget.tipo,
                              )));
                },
              ),
            ],
          ),
          onTap: () {},
        );
      },
      itemCount: widget.evento.length,
    );
  }
}

class EventoDetalle extends StatefulWidget {
  final String tipo;
  final Evento evento;
  EventoDetalle({Key key, this.evento, this.tipo}) : super(key: key);

  @override
  _EventoDetalleState createState() => _EventoDetalleState();
}

class _EventoDetalleState extends State<EventoDetalle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          child: Icon(Icons.fingerprint),
          onPressed: () {
            
            _verificar(
                widget.evento.fecha,
                widget.evento.horainicio,
                widget.evento.latitud,
                widget.evento.longitud,
                widget.evento.id);
          },
        ),
        visible: widget.tipo != 'doc'&&!widget.evento.condicion,
      ),
      appBar: AppBar(
        title: Text('${widget.evento.nombre}'),
        actions: <Widget>[
          Visibility(
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new EstudianteListaEventos(
                              idevento: widget.evento.id,
                              nombre: widget.evento.nombre,
                            )));
              },
            ),
            visible: widget.tipo == 'doc',
          )
        ],
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Icon(Icons.event),
            title: Text('Evento ',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.nombre}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.description),
            title: Text('Descripcion ',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.descripcion}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          Text('Ubicacion del evento',
              style: TextStyle(fontSize: 17.0, color: Colors.blue)),
          Container(
            height: 200.0,
            child: Card(
              borderOnForeground: true,
              color: Colors.black,
              child: FlutterMap(
                options: new MapOptions(
                  center:
                      new LatLng(widget.evento.latitud, widget.evento.longitud),
                  zoom: 20.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/studentcat/cjxtdziti89121cmp4juodris/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3R1ZGVudGNhdCIsImEiOiJjanh0Yjd2azAwYmE0M2NxbHlvdWxyMWhzIn0.3LH2RusySekdeGEfRWoCTw',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1Ijoic3R1ZGVudGNhdCIsImEiOiJjanh0Yjd2azAwYmE0M2NxbHlvdWxyMWhzIn0.3LH2RusySekdeGEfRWoCTw',
                      'id': 'mapbox.mapbox-streets-v7'
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(
                            widget.evento.latitud, widget.evento.longitud),
                        builder: (ctx) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () {
                              print('Marker tapped');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.date_range),
            title: Text('Fecha de inicio del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.fecha}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.timer),
            title: Text('hora de inicio del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.horainicio}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.timer),
            title: Text('hora final del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.horafin}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.tonality),
            title: Text('Tolerancia del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.tolerancia}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
        ],
      )),
    );
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
                      style: TextStyle(fontSize: 20.0, color: Colors.blue),
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

  _verificar(String fecha, String hora, double latitud, double longitud,
      int idevento) async {
    Position localizacionActual;
    try {
      localizacionActual = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print(localizacionActual);
    } catch (e) {
      localizacionActual = null;
    }
    final response = await http.get("$URL_Horario/fechahora");
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('No hay Internet');
    }

    var datatime = json.decode(response.body);
    print(response.body);
    if (datatime[0]['fecha'] != fecha) {
      _showDialog('No esta en el dia correcto!!!');
    } else {
      String horas = datatime[0]['hora'];
      var horaactual = DateTime.parse('1998-04-21 $horas');

      var horainicial = DateTime.parse('1998-04-21 $hora');

      Duration diferencia = horaactual.difference(horainicial);

      var tolerancia = DateTime.parse('1998-04-21 ${widget.evento.tolerancia}');
      Duration tole = tolerancia.difference(horainicial);
      int mintol = tole.inMinutes;
      print(mintol);

      int minutos = diferencia.inMinutes;
      print(minutos);
      if (minutos >= 0 && minutos <= mintol) {
        Distance distance = new Distance();

        if (localizacionActual != null) {
          double distancia = distance(
              LatLng(localizacionActual.latitude, localizacionActual.longitude),
              LatLng(latitud, longitud));
          print('distancia $distancia');
          if (distancia <= widget.evento.radio) {
            print('idevento');
            print(idevento);
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new Biometric(
                      tipo: 'estevento',
                      idevento: idevento,
                    )));
          } else {
            _showDialog(
                'No esta en la ubicacion establecida!!! esta a $distancia mts de la ubicacion del evento');
          }
        }
      } else {
        _showDialog('No cumple con la hora establecida!!!');
      }
    }
  }
}

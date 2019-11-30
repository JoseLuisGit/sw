import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'models/Materias.dart';
import 'models/Estudiante.dart';
import 'ListEventos.dart';

class FormEvent extends StatefulWidget {
  final String nombre;
  final int idgrupo;
  final int iddocente;
  final int idsemestre;
  FormEvent({Key key, this.idgrupo, this.idsemestre, this.iddocente, this.nombre})
      : super(key: key);

  @override
  _FormEventState createState() => _FormEventState();
}

class _FormEventState extends State<FormEvent> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController nombreControler = new TextEditingController();
  TextEditingController descripcionControler = new TextEditingController();
  TextEditingController numeroControler = new TextEditingController();
  TextEditingController nombreJuezControler = new TextEditingController();
  TextEditingController tipoControler = new TextEditingController();
  String _date = "No hay Fecha Seleccionada";
  String _horainicio = "No hay hora Seleccionada";
  String _horafinal = "No hay hora Seleccionada";
  double longitud = 0;
  double latitud = 0;
  String _tolerancia = 'No hay tolencia seleccionada';

  List<int> dataId = new List<int>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Agregar Evento"),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    controller: nombreControler,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.party_mode),
                      hintText: 'Ingrese Nombre',
                      labelText: 'Nombre',
                    ),
                  ),
                  new TextFormField(
                    controller: descripcionControler,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Ingrese Descripcion',
                      labelText: 'Descripcion',
                    ),
                  ),
                  Divider(),
                  Text('Fecha del evento'),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        _date = '${date.year}-${date.month}-${date.day}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.es);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.blue,
                                    ),
                                    Center(
                                      child: Text(
                                        " $_date",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  Divider(),
                  Text('Hora de inicio del evento'),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        setState(() {
                          _horainicio = '${date.hour}:${date.minute}:00';
                        });
                        print('confirm $date');
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 18.0,
                                      color: Colors.blue,
                                    ),
                                    Center(
                                      child: Text(
                                        " $_horainicio",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  Divider(),
                  Text('Hora final del evento'),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          locale: LocaleType.es,
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          _horafinal = '${date.hour}:${date.minute}:00';
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 18.0,
                                      color: Colors.blue,
                                    ),
                                    Center(
                                      child: Text(
                                        " $_horafinal",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  Divider(),
                  Text('Ubicacion del evento'),
                  Container(
                    height: 200.0,
                    child: Card(
                      borderOnForeground: true,
                      color: Colors.black,
                      child: FlutterMap(
                        options: new MapOptions(
                          onTap: (LatLng location) {
                            setState(() {
                              latitud = location.latitude;
                              longitud = location.longitude;
                            });
                            print(location.latitude);
                            print(location.longitude);
                          },
                          center: latitud != 0
                              ? new LatLng(latitud, longitud)
                              : new LatLng(-17.7861099, -63.1763947),
                          zoom: 13.0,
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
                                point: latitud != 0
                                    ? new LatLng(latitud, longitud)
                                    : new LatLng(-17.7861099, -63.1763947),
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
                  Divider(),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    controller: numeroControler,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.radio),
                      hintText: 'Ingrese Radio de la ubicacion',
                      labelText: 'Radio Ubicacion',
                    ),
                  ),
                  Text('Tolerancia del evento'),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          locale: LocaleType.es,
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          _tolerancia = '${date.hour}:${date.minute}:00';
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      size: 18.0,
                                      color: Colors.greenAccent,
                                    ),
                                    Center(
                                      child: Text(
                                        " $_tolerancia",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  Divider(),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 10,
                                height: MediaQuery.of(context).size.height - 80,
                                padding: EdgeInsets.all(20),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    FutureBuilder(
                                        future: fetchEstudiantes(
                                          http.Client(),
                                          widget.idgrupo,
                                          widget.idsemestre,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {}

                                          return snapshot.hasData
                                              ? DialogContent(
                                                  dataId: dataId,
                                                  estudiantes: snapshot.data,
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        }),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Guardar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: const Color(0xFF1BC0C5),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.book,
                                      size: 18.0,
                                      color: Colors.blue,
                                    ),
                                    Center(
                                      child: Text(
                                        "Seleccionar Estudiantes",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  new RaisedButton(
                    onPressed: () async {
                      Map<String, dynamic> params = Map<String, dynamic>();
                      params["nombre"] = nombreControler.text;
                      params["descripcion"] = descripcionControler.text;
                      params['radio'] = numeroControler.text;
                      params['longitud'] = longitud.toString();
                      params['latitud'] = latitud.toString();
                      params['fecha'] = _date;
                      params['hora_inicio'] = _horainicio;
                      params['hora_fin'] = _horafinal;
                      params['data'] = "$dataId";
                      params['tolerancia'] = _tolerancia;
                      params['idpersona'] = widget.iddocente.toString();
                      params['idgrupo'] = widget.idgrupo.toString();

                      await crearEvento(http.Client(), params);
                      Navigator.of(context)
                          .pushReplacement(new MaterialPageRoute(
                              builder: (context) => new ListEventos(
                                    nombre: widget.nombre,
                                    iddocente: widget.iddocente,
                                    idgrupo: widget.idgrupo,
                                    idsemestre: widget.idsemestre,
                                  )));
                    },
                    child: const Text("Crear Evento"),
                  ),
                ],
              ))),
    );
  }

  Widget listaEstudiantes(List<Estudiante> data, BuildContext context) {
    return new ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Container(
              padding: new EdgeInsets.all(5.0),
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    leading: (existeId(data[index].iddg))
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                //Para actualizar los iconButtons
                                this.dataId.remove(data[index].iddg);
                              });
                              print(this.dataId);
                            },
                            color: Colors.red,
                          )
                        : //False
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                //Para actualizar los iconButtons
                                this.dataId.add(data[index].iddg);
                              });
                              print(this.dataId);
                            },
                            color: Colors.green,
                          ),
                    title: new Text(
                        '${data[index].nombre} ${data[index].apellidos}'),
                    subtitle: Text(
                        'Registro' + ': ' + data[index].registro.toString()),
                  )
                ],
              ),
            ),
          );
        });
  }

  bool existeId(int id) {
    return this.dataId.contains(id);
  }
}

class DialogContent extends StatefulWidget {
  final List<Estudiante> estudiantes;
  final List<int> dataId;
  DialogContent({Key key, this.dataId, this.estudiantes}) : super(key: key);

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: new ListView.builder(
          itemCount: widget.estudiantes.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      trailing: (existeId(widget.estudiantes[index].id))
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  //Para actualizar los iconButtons
                                  widget.dataId
                                      .remove(widget.estudiantes[index].id);
                                });
                                print(widget.dataId);
                              },
                              color: Colors.red,
                            )
                          : //False
                          IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                setState(() {
                                  //Para actualizar los iconButtons
                                  widget.dataId
                                      .add(widget.estudiantes[index].id);
                                });
                                print(widget.dataId);
                              },
                              color: Colors.green,
                            ),
                      title: new Text(
                          '${widget.estudiantes[index].nombre} ${widget.estudiantes[index].apellidos}'),
                      subtitle: Text('Registro' +
                          ': ' +
                          widget.estudiantes[index].registro.toString()),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  bool existeId(
    int id,
  ) {
    return widget.dataId.contains(id);
  }
}

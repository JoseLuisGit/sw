import 'dart:async';

import '../models/horario.dart';
import '../utils/chartStudent.dart';
import '../models/Estudiante.dart';
import 'package:flutter/material.dart';
import '../models/asistencia.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MarcarAsistencia extends StatefulWidget {
  static final String path = "registrar";
  final String materia;
  final String grupo;
  final String sigla;
  final int iddetgrupo;
  final int idgrupo;
  final int idsemestre;
  final int idestudiante;
  final List<Asistencia> asistencias;

  MarcarAsistencia(
      {Key key,
      this.idgrupo,
      this.iddetgrupo,
      this.grupo,
      this.materia,
      this.sigla,
      this.idsemestre,
      this.idestudiante,
      this.asistencias})
      : super(key: key);

  @override
  _MarcarAsistenciaState createState() => _MarcarAsistenciaState();
}

class _MarcarAsistenciaState extends State<MarcarAsistencia> {
  final Color primary = Colors.lightBlue;

  final Color border = Color(0xffE1DDDE);

  final Color bg = Color(0xfffefefe);

  final List<bool> toggleIsSelected = [true, false, false];

  double miLongitud;
  double miLatitud;
  @override
  void initState() {
    super.initState();
    // print(GeolocationPermission.values.toString());
    this.miLongitud = -1;
    this.miLatitud = -1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.book),
                // (
                //   backgroundImage: NetworkImage(avatars[0]),
                // ),
                title: Text(
                  "${this.widget.materia} - ${this.widget.grupo}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  "${this.widget.sigla}",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: 400.0,
                        color: primary.withOpacity(0.1),
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        child: FutureBuilder<String>(
                            future: datosasistenciaestudiante(http.Client(),
                                widget.idestudiante, widget.idsemestre, widget.idgrupo),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                print(snapshot.data);
                              }
                              return snapshot.hasData
                                  ? ChartStudent(
                                      datos: snapshot.data,
                                    )
                                  : Center(child: CircularProgressIndicator());
                            })
                        // Image.network(
                        //   cake,
                        //   fit: BoxFit.contain,
                        // )--------------------------------------------------------------Aqui va el chart
                        ),
                  ],
                ),
                const SizedBox(height: 10.0),
                _controlAsistencia(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _controlAsistencia() {
    if (widget.asistencias.length == 0) {
      return Card(
          elevation: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("No hay clases proximas!")));
    } else {
      return FutureBuilder(
          future:
              fetchHorario(http.Client(), this.widget.idgrupo), //, widget.id

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? _tarjetaAsistencia(snapshot.data)
                : Center(child: CircularProgressIndicator());
          });
    }
  }

  Widget _tarjetaAsistencia(List<Horario> horario) {
    if (horario.length == 0) {
      return Card(
          elevation: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Verifique los horarios")));
    }

    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
              ),
              Spacer(),
              _comprobarFecha(),
              // const SizedBox(width: 5.0),
              // Text("213"),
              Spacer(),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
              ),
              Spacer(),
              _comprobarHora(horario),
              Spacer(),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey,
              ),
              Spacer(),
              FutureBuilder(
                future: _comprobarUbicacion().then((marcador) => marcador),
                initialData: Icon(Icons.location_off),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData ? snapshot.data : Icon(Icons.stop);
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text("Registre su asistencia")
        ]),
        // ),
      ),
    );
  }

  String _getFecha() {
    return "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}";
  }

  Widget _comprobarHora(List<Horario> hora) {
    return (hora[0].horaInicio.hour <= DateTime.now().hour &&
            hora[0].horaFin.hour >= DateTime.now().hour)
        ? Icon(Icons.timer, color: this.primary)
        : Icon(Icons.timer);
  }

  // String _getHora(){
  //   return "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
  // }

  Widget _comprobarFecha() {
    String fechaAsistencia = this.widget.asistencias[0].fecha.day.toString() +
        "-" +
        this.widget.asistencias[0].fecha.month.toString() +
        "-" +
        this.widget.asistencias[0].fecha.year.toString();
    return (fechaAsistencia == this._getFecha())
        ? Icon(Icons.today, color: this.primary)
        : Icon(Icons.today);
  }

  Future<Widget> _comprobarUbicacion() async {
    Widget marcador = Icon(Icons.location_off);
    var currentLocation;
    try {
      currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((onValue) {
        marcador = Icon(Icons.location_on, color: this.primary);
        return onValue;
      });
    } catch (e) {
      currentLocation = null;
    }
    return marcador;
  }
}

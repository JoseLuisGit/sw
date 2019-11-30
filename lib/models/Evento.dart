import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';

class Evento {
  int id;
  double latitud;
  String nombre;
  String descripcion;
  double longitud;
  int radio;
  String fecha;
  String horainicio;
  String horafin;
  String tolerancia;
  bool condicion;

  
  Evento(
      {this.id,
      this.nombre,
      this.descripcion,
      this.latitud,
      this.longitud,
      this.radio,
      this.fecha,
      this.horainicio,
      this.horafin,
      this.tolerancia,
      this.condicion});

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        latitud:  double.parse(json['latitud']),
        longitud: double.parse(json['longitud'])
        ,radio: json['radio']
        ,fecha: json['fecha']
        ,horainicio: json['hora_inicio'],
        horafin: json['hora_fin'],
        condicion: json['condicion'],
        tolerancia: json['tolerancia']);
  }

  factory Evento.fromJsonpost(Map<String, dynamic> json) {
     return Evento(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
      latitud:  double.parse(json['latitud']),
        longitud: double.parse(json['longitud'])
        ,radio: json['radio']
        ,fecha: json['fecha'],
         condicion: json['condicion'],
        horainicio: json['hora_inicio'],
        horafin: json['hora_fin'],
        tolerancia: json['tolerancia']);
  }
}

List<Evento> parseEventos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Evento>((json) => Evento.fromJson(json)).toList();
}

Future<List<Evento>> fetchEventos(http.Client client, int idgrupo, int idsemestre, int iddocente) async {
  final response = await client.get('$URL_Evento?idgrupo=$idgrupo&&idsemestre=$idsemestre&&iddocente=$iddocente');
  if (response.statusCode == 200) {
    return parseEventos(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}




// Future<Evento> createEvento(http.Client client, Map<String, dynamic> body) async {
//   final response = await client.post('$URL_EventoCliente/registrarm', body: body);

//   final int statusCode = response.statusCode;

//   if (statusCode < 200 || statusCode > 400 || json == null) {
//     throw new Exception("Error while fetching data");
//   }
//   return Evento.fromJsonpost(json.decode(response.body));
// }

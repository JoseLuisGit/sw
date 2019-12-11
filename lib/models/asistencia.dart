import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';


Asistencia asistenciaFromJson(String str) => Asistencia.fromJson(json.decode(str));

String asistenciaToJson(Asistencia data) => json.encode(data.toJson());

class Asistencia {
    int idasistencia;
    DateTime fecha;
    String horacreacion;
    double latitud;
    double longitud;

    Asistencia({
      this.horacreacion,
        this.idasistencia,
        this.fecha,
        this.latitud,
        this.longitud,
    });

    factory Asistencia.fromJson(Map<String, dynamic> json) => Asistencia(
        horacreacion: json['hora_creacion'],
        idasistencia: json["idasistencia"],
        fecha: DateTime.parse(json["fecha"]),
        latitud :  json['latitud']==null?0:double.parse(json['latitud']),
        longitud : json['longitud']==null?0:double.parse(json['longitud']),
    );

    Map<String, dynamic> toJson() => {
        "idasistencia": idasistencia,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
    };



}

List<Asistencia> parseAsistencia(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Asistencia>((json) => Asistencia.fromJson(json)).toList();
}

Future<List<Asistencia>> fetchAsistencia(http.Client client, int id ) async { //int id
  final response = await client.get('$URL_Asistencia?id=$id'); //?id=$id'
  if (response.statusCode == 200) {
    print(response.body);    
    return parseAsistencia(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}



Future<int> registrarAsistencia(http.Client client, int idAsistencia,int idgrupo, double longitud, double latitud ) async { //int id
  final response = await client.post('$URL_marcarAsistencia?idasistencia=$idAsistencia&idgrupo=$idgrupo&longitud=$longitud&latitud=$latitud'); //?id=$id'
  if (response.statusCode == 200) {    
    return 0; //retornar la distancia?
  } else {
    if(response.statusCode == 400){
      return int.parse(response.body);
    }else{
      throw Exception('No hay Internet');
    }
  }}




 Future<void> crearAsistenciaEstudiante(http.Client client, Map<String, dynamic> body) async {
   final response = await client.post('$URL_Asistencia/agregarEstudiante', body: body);

   final int statusCode = response.statusCode;

   if (statusCode < 200 || statusCode > 400 || json == null) {
     throw new Exception("Error while fetching data");
   }



 
 }

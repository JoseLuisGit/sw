import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';

class Materias {
  int id;
  int idgrupo;
  String nombre;
  String sigla;
  String gsigla;

  Materias(
      {this.id,
      this.idgrupo,
      this.nombre,
      this.sigla,
      this.gsigla});

  factory Materias.fromJson(Map<String, dynamic> json) {
    return Materias(
        id: json['id'],
        idgrupo: json['idgrupo'],
        nombre: json['nombre'],
        sigla: json['sigla'],
        gsigla: json['gsigla']);
  }

  factory Materias.fromJsonpost(Map<String, dynamic> json) {
    return Materias(
        id: json['id'],
        idgrupo: json['idgrupo'],
        nombre: json['nombre'],
        sigla: json['sigla'],
        gsigla: json['gsigla']);
  }
}

List<Materias> parseMateriass(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Materias>((json) => Materias.fromJson(json)).toList();
}

Future<List<Materias>> fetchMateriass(http.Client client, int iddocente, int idsemestre) async {
  final response = await client.get('$URL_Materias?iddocente=$iddocente&&idsemestre=$idsemestre');
  if (response.statusCode == 200) {
    return parseMateriass(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}

 Future<void> crearEvento(http.Client client, Map<String, dynamic> body) async {
   final response = await client.post('$URL_Evento/agregar', body: body);

   final int statusCode = response.statusCode;

   if (statusCode < 200 || statusCode > 400 || json == null) {
     throw new Exception("Error while fetching data");
   }



 
 }


 Future<void> crearAsistencia(http.Client client, Map<String, dynamic> body) async {
   final response = await client.post('$URL_Materias/asistencia', body: body);

   final int statusCode = response.statusCode;

   if (statusCode < 200 || statusCode > 400 || json == null) {
     throw new Exception("Error while fetching data");
   }}

 
   
   Future<void> marcarAsistenciaevento(http.Client client, Map<String, dynamic> body) async {
   final response = await client.put('$URL_Evento/marcar', body: body);

   final int statusCode = response.statusCode;

   if (statusCode < 200 || statusCode > 400 || json == null) {
     throw new Exception("Error while fetching data");
   }

   
   } 





      Future<void> crearAsistenciaEstudiante(http.Client client, Map<String, dynamic> body) async {
   final response = await client.post('$URL_Materias/asistencia/estudiante', body: body);

   final int statusCode = response.statusCode;

   if (statusCode < 200 || statusCode > 400 || json == null) {
     throw new Exception("Error while fetching data");
   }}
   
 

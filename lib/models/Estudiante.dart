import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';

class Estudiante {
  int id;
  int iddg;
  String nombre;
  String apellidos;
  int registro;

  Estudiante(
      {this.id,
      this.nombre,
      this.apellidos,
      this.iddg,
      this.registro});

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
        id: json['id'],
        nombre: json['nombre'],
        apellidos: json['apellidos'],
        iddg: json['iddg'],
        registro: json['registro']);
  }

  factory Estudiante.fromJsonpost(Map<String, dynamic> json) {
    return Estudiante(
        id: json['id'],
        nombre: json['nombre'],
        apellidos: json['apellidos'],
        iddg: json['iddg'],
        registro: json['registro']);
  }
}

List<Estudiante> parseEstudiantes(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Estudiante>((json) => Estudiante.fromJson(json)).toList();
}

Future<List<Estudiante>> fetchEstudiantes(http.Client client, int idgrupo, int idsemestre) async {
  final response = await client.get('$URL_Estudiante?idgrupo=$idgrupo&&idsemestre=$idsemestre');
  if (response.statusCode == 200) {
    return parseEstudiantes(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}

Future<List<Estudiante>> estudiantesEventos(http.Client client, int idevento, bool asistencia) async {
  final response = await client.get('$URL_Evento/estudiante?idevento=$idevento&&asistencia=$asistencia');
  if (response.statusCode == 200) {
    return parseEstudiantes(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}


Future<String> datosasistenciaestudiante(http.Client client, int idestudiante,int idsemestre,int idgrupo) async{
   final response = await client.get('$URL_datos?idestudiante=$idestudiante&&idsemestre=$idsemestre&&idgrupo=$idgrupo');
 if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('No hay Internet');
  }


}

// Future<Estudiante> createEstudiante(http.Client client, Map<String, dynamic> body) async {
//   final response = await client.post('$URL_EstudianteCliente/registrarm', body: body);

//   final int statusCode = response.statusCode;

//   if (statusCode < 200 || statusCode > 400 || json == null) {
//     throw new Exception("Error while fetching data");
//   }
//   return Estudiante.fromJsonpost(json.decode(response.body));
// }

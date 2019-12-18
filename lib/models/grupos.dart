import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';

class Grupos {
  int id;
  String sigla;  //sigla de la materia
  String grupo;
  int iddetgrupo;
  String descripcion;
  String materia;
  String carrera;

  Grupos(
      { this.id,        
        this.sigla,
        this.grupo,
        this.iddetgrupo,
        this.descripcion,
        this.materia,
        this.carrera,
      });

  factory Grupos.fromJson(Map<String, dynamic> json) {
    return Grupos(
        id: json['id'],
        sigla: json['sigla'],
        grupo: json['grupo'],
        iddetgrupo : json['iddetgrupo'],
        descripcion: json['descripcion'],
        materia: json['materia'],
        carrera: json['carrera'],
        );
  }

  factory Grupos.fromJsonpost(Map<String, dynamic> json) {
    return Grupos(
        id: json['id'],
        sigla: json['sigla'],
        grupo: json['grupo'],
        iddetgrupo : json['iddetgrupo'],
        descripcion: json['descripcion'],
        materia: json['materia'],
        carrera: json['carrera'],);
  }
}

List<Grupos> parseGrupos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Grupos>((json) => Grupos.fromJson(json)).toList();
}

Future<List<Grupos>> fetchGrupos(http.Client client, int id , int idsemestre) async { //int id
  final response = await client.get('$URL_Grupo?id=$id&&idsemestre=$idsemestre'); //?id=$id'
  if (response.statusCode == 200) {
    print(response.body);
    return parseGrupos(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}

// Future<Facultad> createFacultad(http.Client client, Map<String, dynamic> body) async {
//   final response = await client.post('$URL_FacultadCliente/registrarm', body: body);

//   final int statusCode = response.statusCode;

//   if (statusCode < 200 || statusCode > 400 || json == null) {
//     throw new Exception("Error while fetching data");
//   }
//   return Facultad.fromJsonpost(json.decode(response.body));
// }

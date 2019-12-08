import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/Urls.dart';

Horario HorarioFromJson(String str) => Horario.fromJson(json.decode(str));

// String HorarioToJson(Horario data) => json.encode(data.toJson());

class Horario {
    int idHorario;
    String dia;
    TimeOfDay horaInicio;
    TimeOfDay horaFin;    

    Horario({
        this.idHorario,
        this.dia,
        this.horaInicio,
        this.horaFin,
    });

    factory Horario.fromJson(Map<String, dynamic> json) => 
      Horario(
        idHorario: json["idHorario"],
        dia: json["dia"],        
        horaInicio: TimeOfDay( hour: int.parse(json["hora_inicio"].toString().substring(0,2) ),
                               minute:int.parse( json["hora_inicio"].toString().substring(3,5))),
        horaFin: TimeOfDay( hour: int.parse(json["hora_fin"].toString().substring(0,2) ),
                               minute:int.parse( json["hora_fin"].toString().substring(3,5)))
      
    );

    // Map<String, dynamic> toJson() => {
    //     "idHorario": idHorario,
    //     "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
    // };



}

List<Horario> parseHorario(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Horario>((json) => Horario.fromJson(json)).toList();
}

Future<List<Horario>> fetchHorario(http.Client client, int id ) async { //int id
  final response = await client.get('$URL_HorarioEst?id=$id'); //?id=$id'
  if (response.statusCode == 200) {
    print(response.body);    
    return parseHorario(response.body);
  } else {
    throw Exception('No hay Internet');
  }
}

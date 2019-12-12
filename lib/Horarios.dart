import 'package:flutter/material.dart';
import 'models/horario.dart';
import 'package:http/http.dart' as http;

class HorarioGrupo extends StatefulWidget {
  final int idgrupo;
  final int idsemestre;
  HorarioGrupo({Key key, this.idgrupo, this.idsemestre}) : super(key: key);

  @override
  _HorarioGrupoState createState() => _HorarioGrupoState();
}

class _HorarioGrupoState extends State<HorarioGrupo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios'),
      ),
      body: FutureBuilder(
          future:
              horarioGrupo(http.Client(), widget.idsemestre, widget.idgrupo),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? HorarioList(horario: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class HorarioList extends StatelessWidget {
  final List<Horario> horario;
  HorarioList({Key key, this.horario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: index % 2 == 0 ? Colors.lightGreen : Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(horario[index].dia,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                Row(
                  children: <Widget>[
                    Card(
                      child: new Text(
                        'Hora Inicial: ${horario[index].horaInicio.format(context)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Card(
                      child: new Text(
                        'Hora Final: ${horario[index].horaFin.format(context)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      itemCount: horario.length,
    );
  }
}

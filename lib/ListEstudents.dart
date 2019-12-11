import 'package:asist_control/models/Estudiante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'models/Estudiante.dart';
import 'ListEventos.dart';
import 'utils/chartStudent.dart';
import 'package:http/http.dart' as http;
class ListStudent extends StatefulWidget {
  final String nombregrupo;
  final String materia;
  final int iddocente;
  final int idgrupo;
  final int idSemestre;
  ListStudent({Key key, this.idgrupo,this.idSemestre,this.materia, this.nombregrupo, this.iddocente}) : super(key: key);
  @override
  _ListStudentState createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold( 
      appBar: AppBar(
        title: Text('${widget.materia} - ${widget.nombregrupo}'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.event_available, color: Colors.white,),
            onPressed: (){

               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ListEventos(
                          nombre: widget.materia,
                          idgrupo: widget.idgrupo,
                          idsemestre: widget.idSemestre,
                          iddocente: widget.iddocente,
                          tipo: 'doc',

                        )));


            },
          )
        ],
      ),
      
      body: FutureBuilder(
          future:  fetchEstudiantes(http.Client(), widget.idgrupo,widget.idSemestre),
          
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? EstudianteLista(estudiante: snapshot.data,idgrupo: widget.idgrupo,idsemestre: widget.idSemestre,)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}





class EstudianteLista extends StatefulWidget {
  final int idgrupo;
  final int idsemestre;
  final List<Estudiante> estudiante;
  EstudianteLista({Key key, this.estudiante,this.idgrupo, this.idsemestre}) : super(key: key);

  @override
  _EstudianteListaState createState() => _EstudianteListaState();
}

class _EstudianteListaState extends State<EstudianteLista> {

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
                  child: Icon(Icons.person),
                  foregroundColor: Colors.white,
                ),
                title: new Text('${widget.estudiante[index].nombre} ${widget.estudiante[index].apellidos}',style: TextStyle(color: Colors.black),),
                subtitle: new Text( 'Registro: ${widget.estudiante[index].registro.toString()}',style: TextStyle(color: Colors.black54),),
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
                caption: 'asistencia',
                color: Colors.blue,
                icon: Icons.insert_chart,
                onTap: () {
                 _showDialog(widget.estudiante[index].nombre,widget.estudiante[index].id,widget.idsemestre, widget.idgrupo);
                },
              ),
            ],
          ),
          onTap: () {
         
       },
        );
      },
      itemCount: widget.estudiante.length,
    );
  }
 
  void _showDialog(String nombre,int idestudiante, int idsemestre, int idgrupo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Asistencia de $nombre"),
          content:FutureBuilder<String>(
          future: datosasistenciaestudiante(http.Client(), idestudiante,idsemestre,idgrupo),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
            }
            return snapshot.hasData
                ? ChartStudent(datos: snapshot.data,)
                : Center(child: CircularProgressIndicator());
          }),
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

 


 
}
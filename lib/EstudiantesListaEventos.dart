import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'models/Estudiante.dart';
class EstudianteListaEventos extends StatefulWidget {
  final String nombre;
  final int idevento;
  EstudianteListaEventos({Key key, this.nombre, this.idevento}) : super(key: key);

  @override
  _EstudianteListaEventosState createState() => _EstudianteListaEventosState();
}

class _EstudianteListaEventosState extends State<EstudianteListaEventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Lista Asistentes del evento ${widget.nombre}'),

       ),
       body: ListView(
         children: <Widget>[
            ListTile(
           dense: true,
            leading: Icon(Icons.assistant_photo),
            title: Text('Asistentes',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            
          ),


          Container(
            height: 200.0,
            child: FutureBuilder(
            
            future: estudiantesEventos(http.Client(), widget.idevento,
                true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? EstudianteFetch(estudiante: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }
           ),
          ) ,
            ListTile(
           dense: true,
            leading: Icon(Icons.format_strikethrough),
            title: Text('Inasistentes',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            
          ),


           Container(
             height: 200.0,
             child: FutureBuilder(
            
            future: estudiantesEventos(http.Client(), widget.idevento,
                false),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? EstudianteFetch(estudiante: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }
           ),
           ) 
         ],
       )
    );
  }
}


class EstudianteFetch extends StatefulWidget {
  final List<Estudiante> estudiante;
  EstudianteFetch({Key key, this.estudiante}) : super(key: key);

  @override
  _EstudianteFetchState createState() => _EstudianteFetchState();
}

class _EstudianteFetchState extends State<EstudianteFetch> {
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
                  child: Icon(Icons.event),
                  foregroundColor: Colors.white,
                ),
                title: new Text('${widget.estudiante[index].nombre} ${widget.estudiante[index].apellidos}'),
                subtitle: new Text(
                    'Registro: ${widget.estudiante[index].registro}'),
              ),
            ),
        
          ),
          onTap: () {},
        );
      },
      itemCount: widget.estudiante.length,
    );
  }
}
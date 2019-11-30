import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'models/Materias.dart';
import 'ListEstudents.dart';
import 'FormEvento.dart';
import 'package:http/http.dart' as http;

class HomeDoc extends StatefulWidget {
  final int id;
  final String tipo;
  final int idSemestre;
  HomeDoc({Key key, this.id, this.tipo, this.idSemestre}) : super(key: key);
  @override
  _HomeDocState createState() => _HomeDocState();
}

class _HomeDocState extends State<HomeDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Opacity(
        child: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => new AgregarCaso(
            //               id: widget.id,
            //             )));
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
        opacity: 1,
      ),
      body: FutureBuilder(
          future: fetchMateriass(http.Client(), widget.id, widget.idSemestre),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? MateriasLista(
                    materias: snapshot.data, idsemestre: widget.idSemestre, iddocente: widget.id,)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class MateriasLista extends StatefulWidget {
  final List<Materias> materias;
  final int idsemestre;
  final int iddocente;
  MateriasLista({Key key, this.materias, this.idsemestre,this.iddocente}) : super(key: key);

  @override
  _MateriasListaState createState() => _MateriasListaState();
}

class _MateriasListaState extends State<MateriasLista> {
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
                  child: Icon(Icons.layers),
                  foregroundColor: Colors.white,
                ),
                title: new Text(
                    '${widget.materias[index].nombre} - ${widget.materias[index].sigla}'),
                subtitle: new Text(widget.materias[index].gsigla == null
                    ? "No hay descripcion"
                    : widget.materias[index].gsigla),
              ),
            ),
            actions: <Widget>[
              new IconSlideAction(
                  caption: 'Agregar Evento',
                  color: Colors.blueAccent,
                  icon: Icons.event,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new FormEvent(iddocente: widget.iddocente,idsemestre: widget.idsemestre, idgrupo: widget.materias[index].idgrupo,nombre: widget.materias[index].nombre,)));
                  }),
            ],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Asistencia',
                color: Colors.green,
                icon: Icons.fingerprint,
                onTap: () => {},
              ),
            ],
          ),
          onTap: () {
            //   int selectedId = widget.materias[index].id;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ListStudent(
                          idgrupo: widget.materias[index].idgrupo,
                          idSemestre: widget.idsemestre,
                          materia: widget.materias[index].nombre,
                          nombregrupo: widget.materias[index].gsigla,
                          iddocente: widget.iddocente,
                        )));
          },
        );
      },
      itemCount: widget.materias.length,
    );
  }
}

import 'package:flutter/material.dart';
import 'asistencia_page.dart';
import 'models/grupos.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'ListEventos.dart';
import 'Horarios.dart';

class HomePage extends StatefulWidget {

  static final String routeName = 'home';
  final int idSemestre;
  final int id;


  HomePage({Key key, this.id , this.idSemestre}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
     floatingActionButton: Opacity(
        child: FloatingActionButton(
          onPressed: () {
            // // prefs.idUser = 2;
            // print(prefs.idUser);
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
        opacity: 1,
      ),
      body: FutureBuilder(
          future:  fetchGrupos(http.Client(), widget.id,widget.idSemestre), //, widget.id
          
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? GruposLista(misGrupos: snapshot.data, idsemestre: widget.idSemestre,id: widget.id,)
                : Center(child: CircularProgressIndicator());
          }),

    );
  }

}

class GruposLista extends StatefulWidget {
  final int idsemestre;
  final int id;
  final List<Grupos> misGrupos;
  GruposLista({Key key, this.misGrupos, this.idsemestre, this.id}) : super(key: key);

  @override
  _GruposListaState createState() => _GruposListaState();
}

class _GruposListaState extends State<GruposLista> {

 

  TextEditingController nombreControler = new TextEditingController();
  TextEditingController descripcionControler = new TextEditingController();
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
                title: new Text(widget.misGrupos[index].grupo== null
                    ? "No hay sigla de grupo"
                    : '${widget.misGrupos[index].grupo} - ${widget.misGrupos[index].materia}',style: TextStyle(color: Colors.black),),
                subtitle: new Text(widget.misGrupos[index].sigla == null
                    ? "No hay descripcion"
                    : widget.misGrupos[index].sigla ,style: TextStyle(color: Colors.black54),),
              ),
            ),
            actions: <Widget>[
              new IconSlideAction(
                  caption: 'Eventos',
                  color: Colors.blueAccent,
                  icon: Icons.event,
                  onTap: () {
               Navigator.push(context, MaterialPageRoute(
                  builder:(context)=>ListEventos(
                    tipo: 'est',
                    idgrupo: widget.misGrupos[index].id,
                    iddt: widget.misGrupos[index].iddetgrupo,
                    idsemestre: widget.idsemestre ,
                    nombre: widget.misGrupos[index].materia,
                  ) 
                ));
                   
                  }),

                  new IconSlideAction(
                  caption: 'Horario',
                  color: Colors.yellow,
                  icon: Icons.hourglass_empty,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new HorarioGrupo( idsemestre: widget.idsemestre,
                                  idgrupo: widget.misGrupos[index].id,)));
                  })
            ],
            // secondaryActions: <Widget>[
            //   new IconSlideAction(
            //     caption: 'opcion',
            //     color: Colors.green,
            //     icon: Icons.keyboard_arrow_down,
            //     onTap: () => {},
            //   ),
            // ],
          ),
          onTap: () {
            int selectedId = widget.misGrupos[index].id;
            String materia = widget.misGrupos[index].materia;
            String grupo = widget.misGrupos[index].grupo;
            int iddetgrupo = widget.misGrupos[index].iddetgrupo;
            String sigla = widget.misGrupos[index].sigla;
            Navigator.push(
                context,
                MaterialPageRoute(
                  //le paso el id del grupo
                    builder: (context) => new AsistenciaPage(idgrupo: selectedId,
                                              id: widget.id,
                                              materia: materia,
                                              grupo: grupo,
                                              iddetgrupo: iddetgrupo,
                                              sigla: sigla,
                                              idsemestre: widget.idsemestre,
                                              )
                )
            );
          },
        );
      },
      itemCount: widget.misGrupos.length,
    );
  }

 
}


import 'package:flutter/material.dart';
import 'models/Estudiante.dart';
import 'package:http/http.dart' as http;
import 'models/asistencia.dart';

class AsistenciaEstudianteMarcar extends StatefulWidget {
  final int idgrupo;
  final int idsemestre;
  final int idasistencia;
  AsistenciaEstudianteMarcar(
      {Key key, this.idasistencia, this.idgrupo, this.idsemestre})
      : super(key: key);

  @override
  _AsistenciaEstudianteMarcarState createState() =>
      _AsistenciaEstudianteMarcarState();
}

class _AsistenciaEstudianteMarcarState
    extends State<AsistenciaEstudianteMarcar> {
  List<int> dataId = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.check_box),
        onPressed: ()async{
           Map<String, dynamic> params = Map<String, dynamic>();
                      
                      params['data'] = "$dataId";
                      params['idasistencia'] = widget.idasistencia.toString();

                      await crearAsistenciaEstudiante(http.Client(), params);
                      Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text('Estudiantes'),
      ),
      body: Center(
        child: ListView(
          children: [
            FutureBuilder(
                future: fetchEstudiantes(
                  http.Client(),
                  widget.idgrupo,
                  widget.idsemestre,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                  }

                  return snapshot.hasData
                      ? DialogContentEstudiante(
                          dataId: dataId,
                          estudiantes: snapshot.data,
                        )
                      : Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}

class DialogContentEstudiante extends StatefulWidget {
  final List<Estudiante> estudiantes;
  final List<int> dataId;
  DialogContentEstudiante({Key key, this.estudiantes, this.dataId})
      : super(key: key);

  @override
  _DialogContentStateEs createState() => _DialogContentStateEs();
}

class _DialogContentStateEs extends State<DialogContentEstudiante> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new ListView.builder(
          itemCount: widget.estudiantes.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: (existeId(widget.estudiantes[index].iddg))
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  //Para actualizar los iconButtons
                                  widget.dataId
                                      .remove(widget.estudiantes[index].iddg);
                                });
                                print(widget.dataId);
                              },
                              color: Colors.red,
                            )
                          : //False
                          IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                setState(() {
                                  //Para actualizar los iconButtons
                                  widget.dataId
                                      .add(widget.estudiantes[index].iddg);
                                });
                                print(widget.dataId);
                              },
                              color: Colors.green,
                            ),
                      title: new Text(
                          '${widget.estudiantes[index].nombre} ${widget.estudiantes[index].apellidos}'),
                      subtitle: Text('Registro' +
                          ': ' +
                          widget.estudiantes[index].registro.toString()),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  bool existeId(
    int id,
  ) {
    return widget.dataId.contains(id);
  }
}

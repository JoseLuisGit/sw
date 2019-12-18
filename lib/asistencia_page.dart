import 'package:asist_control/Biometric.dart';

import 'utils/marcar_asistencia_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'models/asistencia.dart';
import 'ListEventos.dart';

class AsistenciaPage extends StatefulWidget {
  final int idgrupo;  //recibo el id del grupo
  final String materia;
  final String grupo;
  final int iddetgrupo;
  final String sigla;
  final int id;
  final int idsemestre;
  AsistenciaPage({Key key, this.id,this.idgrupo, this.grupo, this.iddetgrupo, this.materia, this.sigla,this.idsemestre}) : super(key: key);

  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  Asistencia miAsistencia;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Registrar asistencia"),
         elevation: 20.0,
         actions: <Widget>[
           IconButton(
             icon: Icon(Icons.event),
             onPressed: (){

                Navigator.push(context, MaterialPageRoute(
                  builder:(context)=>ListEventos(
                    tipo: 'est',
                    idgrupo: widget.idgrupo,
                    iddt: widget.iddetgrupo,
                    idsemestre: widget.idsemestre ,
                    nombre: widget.materia,
                  ) 
                ));
             },
           )
         ],
       ),
       
       body: //Text(widget.idgrupo.toString()),
        FutureBuilder(
          future:  fetchAsistencia( http.Client(), widget.idgrupo), //, widget.id
          
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            if(snapshot.hasData){   
         
                 snapshot.data.length != 0 ? miAsistencia=snapshot.data[0] : miAsistencia=null;
           
              return MarcarAsistencia(
                idestudiante: widget.id,idsemestre: widget.idsemestre,
                idgrupo: widget.idgrupo, grupo: widget.grupo, iddetgrupo: widget.iddetgrupo, 
                  materia: widget.materia, sigla: widget.sigla, asistencias: snapshot.data);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      floatingActionButton: 
      Visibility(
        child: FloatingActionButton(                
        child: Icon(Icons.check_box),
        onPressed: () {
          _comprobarUbicacion().then((marcador) async{
            if(miAsistencia != null){
              await registrarAsistencia(http.Client(),
                                        miAsistencia.idasistencia, 
                                        widget.idgrupo, 
                                        marcador.longitude, 
                                        marcador.latitude)
                                        .then((onValue){

                                          if(onValue>=0){

                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context)=>Biometric(iddet: widget.iddetgrupo,tipo: 'asist',idAsistencia: miAsistencia.idasistencia,
                                                  idgrupo: widget.idgrupo,idsemestre: widget.idsemestre,)
                                            ));

                                          }else{
                                          
                                          _showAlertDialog(onValue);
                                          }
                                        });
            }
          }            
          );
        },
      ),
      visible: miAsistencia==null,
        
      )
    );
  }



  Future<Position> _comprobarUbicacion() async{
    
    Position currentLocation;
    try{
      currentLocation  = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                                .then((onValue){                                                                                                                                                       
                                      // marcador = Icon(Icons.location_on, color: this.primary);
                                      return onValue;
                                });

    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void _showAlertDialog(int tipo) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(        
          content:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.error,
                  size: 150,
                  color: Colors.red,
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'No se puede completar por: ',
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Container(
                    height: 200,
                    child: _mensaje(tipo),
              ),)
            ],
          ),
          actions: <Widget>[
           
            RaisedButton(
              child: Text("aceptar", style: TextStyle(color: Colors.white),),
              onPressed: (){ Navigator.of(context).pop(); },
            ),                                     
          ],
        );
      }
    );
  }

  Text _mensaje(int tipo){
    switch (tipo) {
      case 0: 
        return Text("Podrias registrar tu horario si tuvieras lector de huellas", style: TextStyle(fontSize: 20.0));
        break;
      case -1:
        return Text("Verifica la fecha de la clase", style: TextStyle(fontSize: 20.0)); 
        break;       
      case -2:
        return Text("Verifica tu horario",style: TextStyle(fontSize: 20.0));  
        break;    
      default:
          return Text("Estas a: " + tipo.toString() + "metros de tu aula",style: TextStyle(fontSize: 20.0));
    }
  }}
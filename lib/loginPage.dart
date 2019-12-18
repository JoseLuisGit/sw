import 'package:asist_control/ListEventos.dart';
import 'package:asist_control/asistencia_page.dart';
import 'package:asist_control/utils/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'DrawerMenuAP.dart';
import 'DrawerMenuEst.dart';
import 'utils/Logo.dart';
import 'utils/Urls.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool validateEmail = false;
  bool validatePassword = false;
  final pushProvider=new PushNotification();//NUEVO

  Future<List> _login() async {
    String users = emailController.text;
    String passw = passwordController.text;

    final response = await http.get("$URL_login?registro=$users&password=$passw");
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('No hay Internet');
    }

    var datauser = json.decode(response.body);
    print(response.body);
    if (datauser.length == 0) {
      _showToast(context);
    } else {
      
      if (datauser[0]['rol'] == 'Docente') {
            Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
              builder: (context) => new DrawerMenuAP(
                    id: datauser[0]['id'],
                    tipo: datauser[0]['rol'],
                    idSemestre: datauser[0]['telefono'],
                    semestre: datauser[0]['fecha_nac'],

                  ) 
              ) 
          );
      } else {//alumno
           initNotificacion();//Configuracion Inicial de la notificacion
           //actualizacion del token
           Map<String,dynamic>body=new Map<String,dynamic>();
           body['id']=datauser[0]['id'].toString();
           body['token']=await this.pushProvider.getToken();
           final responsePUT = await http.put("$URL_actualizarToken",body: body);
           print(responsePUT.body);
           Navigator.of(context).pushReplacement(
           new MaterialPageRoute(
              builder: (context) => new DrawerMenuEst(
                    id: datauser[0]['id'],
                    idSemestre: datauser[0]['telefono'],
                    
              ) 
             ) 
          );
      }


    }
    return datauser;
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Contraseña Incorrecta o email invalido!!'),
        action: SnackBarAction(
            label: 'Cerrar', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/imagen.jpg'), fit: BoxFit.cover),
        )),
        Positioned(
          top: 150.0,
          left: 40.0,
          right: 40.0,
          child: Container(
            child: Column(
              children: <Widget>[
                Emphance(),
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                        errorText:
                            validateEmail ? "Email can't be empty" : null,
                        errorStyle:
                            TextStyle(color: Colors.white54, fontSize: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: Icon(
                          Icons.recent_actors,
                          color: Colors.white,
                          size: 30,
                        ),
                        labelText: "Registro",
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorText:
                            validatePassword ? "Password can't be empty" : null,
                        errorStyle:
                            TextStyle(color: Colors.white54, fontSize: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 30,
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Contraseña"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                ButtonTheme(
                    minWidth: 300,
                    height: 50,
                    child: RaisedButton( 
                      color: Colors.white,
                      onPressed: () async {
                        _login();
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void initNotificacion(){
    pushProvider.initNotifications();
    pushProvider.mensajes.listen((data){//el data es un map asi se definio en la clase
      print('Argumento del push');
      print(data);//Pendiente navegacion
      if(data['data']['tipoNotificacion']=='evento'){
        Navigator.push(context, 
          MaterialPageRoute(
                        builder:(context)=>ListEventos(
                          tipo: data['data']['tipo'],
                          idgrupo: int.parse(data['data']['idgrupo']),
                          iddt: int.parse(data['data']['iddt']),
                          idsemestre: int.parse(data['data']['idsemestre']) ,
                          nombre: data['data']['nombre'],
                        )
          )
        );
      }else{
          Navigator.push(context, 
          MaterialPageRoute(
                        builder:(context)=>AsistenciaPage(
                          idgrupo: int.parse(data['data']['idgrupo']),
                          idsemestre: int.parse(data['data']['idsemestre']),
                          iddetgrupo: int.parse(data['data']['iddt']),
                          id: int.parse(data['data']['idestudiante']),
                          grupo: data['data']['grupo'],
                          materia: data['data']['nombre'],//de la materia
                          sigla: data['data']['sigla'],
                        )
          )
        );
      }
    });
  }
}

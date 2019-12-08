import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'models/materias.dart';

class Biometric extends StatefulWidget {
  final int idAsistencia;
  final String tipo;
  final double latitud;
  final double longitud;
  final int iddet;
  final int idevento;
  final int idgrupo;
  final int idsemestre;
  Biometric(
      {Key key,
      this.idAsistencia,
      this.latitud,
      this.longitud,
      this.idsemestre,
      this.idgrupo,
      this.tipo,
      this.iddet,
      this.idevento})
      : super(key: key);

  @override
  _BiometricState createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      appBar: AppBar(
        elevation: 0,
        title: Text('Marcar Asistencia por huella'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(40, 100),
                topRight: Radius.elliptical(40, 100))),
        child: Container(
          margin: MediaQuery.of(context).orientation == Orientation.portrait
              ? EdgeInsets.only(top: 100)
              : EdgeInsets.only(top: 0),
          child: BiometricAuth(
            idevento: widget.idevento,
            tipo: widget.tipo,
            idgrupo: widget.idgrupo,
            idsemestre: widget.idsemestre,
            latitud: widget.latitud,

            longitud: widget.longitud,
          ),
        ),
      ),
    );
  }
}

class BiometricAuth extends StatefulWidget {
  final String tipo;
  final double latitud;
  final double longitud;
  final int idgrupo;
  final int idsemestre;
  final int idevento;
  final int idAsistencia;

  BiometricAuth(
      {Key key,
      this.idAsistencia,
      this.idevento,
      this.idsemestre,
      this.tipo,
      this.latitud,
      this.longitud,
      this.idgrupo})
      : super(key: key);
  @override
  _BiometricAuth createState() => _BiometricAuth();
}

class _BiometricAuth extends State<BiometricAuth> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _isAuthorized = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (listofBiometrics.contains(BiometricType.face)) {
      print('faceId');
    } else if (listofBiometrics.contains(BiometricType.fingerprint)) {
      print('fingerprint');
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = listofBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to proceed!",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() async {
      if (isAuthorized) {
        _isAuthorized = "Authorized";
   Map<String, dynamic> params = Map<String, dynamic>();
        if (widget.tipo == 'doc') {
       
          params['latitud'] = widget.latitud.toString();
          params['longitud'] = widget.longitud.toString();
          params['idgrupo'] = widget.idgrupo.toString();
          params['idsemestre'] = widget.idsemestre.toString();
          await crearAsistencia(http.Client(), params);
        } else if (widget.tipo == 'estevento') {
         
          params['id'] = widget.idevento.toString();
          await marcarAsistenciaevento(http.Client(), params);
        }else if(widget.tipo=='asist'){ 
      
           params['latitud'] = widget.latitud.toString();
          params['longitud'] = widget.longitud.toString();
          params['idgrupo'] = widget.idgrupo.toString();
              params['idsemestre'] = widget.idsemestre.toString();

          await crearAsistencia(http.Client(), params);
          
        }

        Navigator.pop(context);
      } else {
        _isAuthorized = "Unauthorized";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_availableBiometricTypes.toString());
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ 
                IconButton(
                  icon: Icon(Icons.access_alarms),
                  onPressed: ()async{
                     Map<String, dynamic> params = Map<String, dynamic>();

                     params['id'] = widget.idevento.toString();
          await marcarAsistenciaevento(http.Client(), params); 
                  },
                ),
                RaisedButton(
                  onPressed: _checkBiometric,
                  child: Text("Check Biometric"),
                  color: Colors.lime,
                ),
                SizedBox(
                  width: 10,
                ),
                _canCheckBiometric == true
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 50,
                      )
                    : Icon(
                        Icons.cancel,
                        color: Colors.lime,
                        size: 50,
                      ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _getListOfBiometricTypes,
                  child: Text("Available Biometric Types"),
                  color: Colors.lime,
                ),
                SizedBox(
                  width: 10,
                ),
                _availableBiometricTypes.toString() ==
                        '[BiometricType.fingerprint]'
                    ? Text('fingerprint')
                    : Text('${_availableBiometricTypes.toString()}'),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Authorization : "),
                _isAuthorized == 'Authorized'
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 50,
                      )
                    : Text('Unauthorized'),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Icon(
                Icons.fingerprint,
                color: Colors.black,
                size: 100,
              ),
              color: Colors.white,
              elevation: 0,
            ),
          ],
        ),
      ],
    );
  }
}

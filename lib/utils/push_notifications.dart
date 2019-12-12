import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';

class PushNotification{
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


final _mensajesStreamController=StreamController<Map<String,dynamic>>.broadcast();
Stream<Map<String,dynamic>>get mensajes=>_mensajesStreamController.stream;

//Obtengo el token del celular
Future<String> getToken()async{
  return await _firebaseMessaging.getToken();
}

initNotifications(){
  _firebaseMessaging.requestNotificationPermissions();//pide permisos de notificacion

  //obtener token del disposiivo
  _firebaseMessaging.getToken().then((token){//esto se guardaria en la base como un arreglo porque puede tener mas de un token
    print('===FCM TOKEN===');
    print(token);
    //fordc9aMlOo:APA91bGjC9NMNAgjMF9-Kj2iHPCs3W6dpqovt5NdRrPqI8o0ZlpQ9wGy-pIv3jhkqaBOvFn2yfvm4-3eN6KnhyiRX_gQXdrx6FhAgUbKgZMUzGOk9Hy0To3NLE5MUOEvQ0xOekD32zyY
  });

  _firebaseMessaging.configure(

    onMessage: (info)async{//se dispara cuando nuestra aplicacion esta abierta
      print('===ON MESSAGE===');
      print(info);

      _mensajesStreamController.sink.add(info);
      //String argumento='no-data';

      //if(Platform.isAndroid){
        //argumento=info['data']['comida']??'no-data';//?? por si viene nulll vacio mostrara el no-data
      //}
      //_mensajesStreamController.sink.add(argumento);
    },

    onLaunch: (info)async{//Se envia notificacion cuando la aplicacion no estaba abierta por lo tanto la inicia desde 0
      print('===ON LAUNCH===');
      print(info);
      _mensajesStreamController.sink.add(info);
    },

    onResume: (info)async{//Se envia notificacion cuando la aplicacion esta en segundo plano
      print('===ON RESUME===');
      print(info);
      
      //String argumento='no-data';

      //if(Platform.isAndroid){
        //argumento=info['data']['comida']??'no-data';//?? por si viene nulll vacio mostrara el no-data
      //}

      _mensajesStreamController.sink.add(info);
      //final notificacion=info['data']['comida'];//info es el mapa que no da firebase al dar click en la notificacion
      //print(notificacion);
    }
  );
}

dispose(){//Es necesario apra que no aparesca un error en el StreamController
  _mensajesStreamController?.close();//el ? en caso de que no exista
}

}
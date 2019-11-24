import 'package:flutter/material.dart';


class HomeDoc extends StatefulWidget {
final int id;
  final String tipo;
  final int idSemestre;
  HomeDoc({Key key, this.id, this.tipo,this.idSemestre}) : super(key: key);
  @override
  _HomeDocState createState() => _HomeDocState();
}

class _HomeDocState extends State<HomeDoc> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: null,
    );
  }
}
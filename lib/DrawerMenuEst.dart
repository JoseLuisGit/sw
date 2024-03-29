
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';

import 'temas.dart';
import 'HomeEst.dart';

class DrawerMenuEst extends StatefulWidget {
  final int id;
  final int idSemestre;
  DrawerMenuEst({Key key,this.id, this.idSemestre}) : super(key: key);

  @override
  _DrawerMenuAPestState createState() => _DrawerMenuAPestState();
}

class _DrawerMenuAPestState extends State<DrawerMenuEst> {

  List<ScreenHiddenDrawer> itens; 

  @override
  void initState() {
    itens = [
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Materias",
          colorLineSelected: Colors.teal,
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 25.0 ),
          selectedStyle: TextStyle(color: Colors.teal),
        ),
        HomePage(id: widget.id, idSemestre: widget.idSemestre,)
    ),
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Temas",
          colorLineSelected: Colors.amberAccent,
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 25.0 ),
          selectedStyle: TextStyle(color: Colors.amberAccent),
          onTap: (){
            print("Click item");
          },
        ),
          TemasScreen()
        
        
    )
  ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return HiddenDrawerMenu(
      initPositionSelected: 0,
      screens: itens,
      backgroundColorMenu: Colors.black87,
      //    typeOpen: TypeOpen.FROM_RIGHT,
      //    enableScaleAnimin: true,
      //    enableCornerAnimin: true,
      //    slidePercent: 80.0,
      //    verticalScalePercent: 80.0,
      //    contentCornerRadius: 10.0,
      //    iconMenuAppBar: Icon(Icons.menu),
      //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
      //    whithAutoTittleName: true,
      //    styleAutoTittleName: TextStyle(color: Colors.red),
      //    actionsAppBar: <Widget>[],
      //    backgroundColorContent: Colors.blue,
      //    backgroundColorAppBar: Colors.blue,
      //    elevationAppBar: 4.0,
      //    tittleAppBar: Center(child: Icon(Icons.ac_unit),),
      //    enableShadowItensMenu: true,
      //    backgroundMenu: DecorationImage(image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
    );
  }
}



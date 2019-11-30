import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'models/Evento.dart';
import 'EstudiantesListaEventos.dart';

class ListEventos extends StatefulWidget {
  final String nombre;
  final int idgrupo;
  final int idsemestre;
  final int iddocente;
  ListEventos(
      {Key key, this.nombre, this.idgrupo, this.iddocente, this.idsemestre})
      : super(key: key);

  @override
  _ListEventosState createState() => _ListEventosState();
}

class _ListEventosState extends State<ListEventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Eventos de ${widget.nombre}'),
          actions: <Widget>[],
        ),
        body: FutureBuilder(
            future: fetchEventos(http.Client(), widget.idgrupo,
                widget.idsemestre, widget.iddocente),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? EventoLista(evento: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }));
  }
}

class EventoLista extends StatefulWidget {
  final List<Evento> evento;
  EventoLista({Key key, this.evento}) : super(key: key);

  @override
  _EventoListaState createState() => _EventoListaState();
}

class _EventoListaState extends State<EventoLista> {
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
                title: new Text('${widget.evento[index].nombre}'),
                subtitle: new Text(
                    'Descripcion: ${widget.evento[index].descripcion}'),
              ),
            ),
            // actions: <Widget>[
            //   new IconSlideAction(
            //       caption: 'Camara',
            //       color: Colors.blueAccent,
            //       icon: Icons.camera,
            //       onTap: () {

            //       }),
            // ],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Ver',
                color: Colors.green,
                icon: Icons.remove_red_eye,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventoDetalle(
                                evento: widget.evento[index],
                              )));
                },
              ),
            ],
          ),
          onTap: () {},
        );
      },
      itemCount: widget.evento.length,
    );
  }
}

class EventoDetalle extends StatefulWidget {
  final Evento evento;
  EventoDetalle({Key key, this.evento}) : super(key: key);

  @override
  _EventoDetalleState createState() => _EventoDetalleState();
}

class _EventoDetalleState extends State<EventoDetalle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.evento.nombre}'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.person),
            onPressed: (){

             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new EstudianteListaEventos(
                      idevento: widget.evento.id,
                      nombre: widget.evento.nombre,
                          

                        )));
            },
          )
        ],
      ),
      
      body: Container(
          child: ListView(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Icon(Icons.event),
            title: Text('Evento ',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.nombre}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
           dense: true,
            leading: Icon(Icons.description),
            title: Text('Descripcion ',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.descripcion}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          Text('Ubicacion del evento',
              style: TextStyle(fontSize: 17.0, color: Colors.blue)),
          Container(
            height: 200.0,
            child: Card(
              borderOnForeground: true,
              color: Colors.black,
              child: FlutterMap(
                options: new MapOptions(
                  center:
                      new LatLng(widget.evento.latitud, widget.evento.longitud),
                  zoom: 20.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/studentcat/cjxtdziti89121cmp4juodris/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3R1ZGVudGNhdCIsImEiOiJjanh0Yjd2azAwYmE0M2NxbHlvdWxyMWhzIn0.3LH2RusySekdeGEfRWoCTw',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1Ijoic3R1ZGVudGNhdCIsImEiOiJjanh0Yjd2azAwYmE0M2NxbHlvdWxyMWhzIn0.3LH2RusySekdeGEfRWoCTw',
                      'id': 'mapbox.mapbox-streets-v7'
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(
                            widget.evento.latitud, widget.evento.longitud),
                        builder: (ctx) => new Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () {
                              print('Marker tapped');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.date_range),
            title: Text('Fecha de inicio del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.fecha}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
           ListTile(
             dense: true,
            leading: Icon(Icons.timer),
            title: Text('hora de inicio del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.horainicio}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
           ListTile(
             dense: true,
            leading: Icon(Icons.timer),
            title: Text('hora final del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.horafin}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          ListTile(
             dense: true,
            leading: Icon(Icons.tonality),
            title: Text('Tolerancia del evento',
                style: TextStyle(fontSize: 17.0, color: Colors.blue)),
            subtitle: Text('${widget.evento.tolerancia}',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
        ],
      )),
    );
  }
}

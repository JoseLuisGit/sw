import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';


class ChartStudent extends StatefulWidget {

  final String datos;
  ChartStudent({Key key, this.datos}) : super(key: key);
  @override
   ChartStudentState createState() => ChartStudentState();
}

class ChartStudentState extends State<ChartStudent> {
int touchedIndex;
List<String> data;
 @override
void initState() {
    data = widget.datos.split(' ');
    super.initState();

  }
 
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: <Widget>[
             PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      sections: showingSections(data)),
                ),
              
            
            
                Indicator(
                  color: Colors.green,
                  text: 'Asistencia ${data[0]}',
                  isSquare: true,
                ),
               
                Indicator(
                  color: Colors.red,
                  text: 'Faltas ${int.parse(data[1])-int.parse(data[0])}',
                  isSquare: true,
                ),
            
                Indicator(
                  color: Colors.white,
                  text: 'Total % de clases: ${data[1]}',
                  isSquare: true,
                ),
               
             
              
            
          
          ],
        ),);
      
  }

  List<PieChartSectionData> showingSections(List<String> data) {

  
   double asistencia = (100 * double.parse(data[0]))/double.parse(data[1]);
   double faltasp = 100-asistencia;
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: asistencia,
            title: '${asistencia.toStringAsFixed(2)}% ',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: faltasp,
            title: '${faltasp.toStringAsFixed(2)}% ',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
          );
      
       
        default:
          return null;
      }
    });
  }
}

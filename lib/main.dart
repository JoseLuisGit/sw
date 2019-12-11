import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'themes/custom_theme.dart';
import 'themes/themes.dart';
void main(){
  runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ));
}

 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: CustomTheme.of(context),
       home: Scaffold(
         body: LoginPage(),

       ),

     );
   }
 }
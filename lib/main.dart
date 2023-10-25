import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy/screen/splash.dart';

main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash()
    );
  }
}






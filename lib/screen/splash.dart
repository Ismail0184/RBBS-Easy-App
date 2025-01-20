import 'package:flutter/material.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super (key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), (){});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(

            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Container(
                width: 370.0,
                child: Image.network("http://icpd.icpbd-erp.com/assets/images/icon/400001.png"))),
      ),
    );
  }
}

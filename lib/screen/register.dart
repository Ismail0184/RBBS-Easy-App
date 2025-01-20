import 'dart:convert';
import 'package:easy/screen/OTP.dart';
import 'package:easy/screen/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../methods/api.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController business_name = TextEditingController();
  TextEditingController trade_license = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController role_id = TextEditingController();
  TextEditingController password = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context){
          return Center(child: CircularProgressIndicator());
        }
    );
    final data = {
      'name': name.text.toString(),
      'email': email.text.toString(),
      'mobile': mobile.text.toString(),
      'address': address.text.toString(),
      'business_name': business_name.text.toString(),
      'trade_license': trade_license.text.toString(),
      'status': status.text.toString(),
      'role_id': "3",
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/register', data: data);
    final response = jsonDecode(result.body);
    Navigator.of(context).pop();
    if (response['status'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OTPPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
    }
  }


  List<bool> _checked = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Sign Up / Registration'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  TextFormField(
                    controller: business_name,
                    decoration: InputDecoration(labelText: 'Shop / Workshop Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(labelText: 'Proprietor / Mechanic Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  TextFormField(
                    controller: trade_license,
                    decoration: InputDecoration(labelText: 'Trade License (For Retailer)',
                      prefixIcon: Icon(Icons.book),
                    ),
                  ),
                  TextFormField(
                    controller: address,
                    decoration: InputDecoration(labelText: 'Address',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(labelText: 'Email ID',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFormField(
                    controller: mobile,
                    decoration: InputDecoration(labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.mobile_friendly),
                    ),
                  ),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(labelText: 'Password',
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: false,
                  ),



                  SizedBox(height: 40.0),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        registerUser();
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.0, 0.20),
                                  blurRadius: 15,
                                  color: Colors.black
                              ),

                            ],
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(95),
                                      bottomLeft: Radius.circular(95),
                                      bottomRight: Radius.circular(200)

                                  ),
                                  color: Colors.red
                              ),
                              child: Text("Sign Up", style: TextStyle(color: Colors.white),),
                              alignment: Alignment.center,
                            ),
                            Icon(Icons.app_registration)
                          ],
                        ),
                      ),
                    ),

                  ),


                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Do you have already an account?',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: ' Sign In',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decorationColor: Colors.blue, // Color of the underline
                              decorationThickness: 2, // Thickness of the underline
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



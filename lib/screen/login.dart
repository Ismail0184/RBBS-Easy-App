import 'dart:convert';
import 'package:easy/screen/dashboard.dart';
import 'package:easy/screen/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy/methods/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();

  void loginUser() async {
    final data = {
      'mobile': mobile.text.toString(),
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/login', data: data);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('id', response['user']['id']);
      await preferences.setString('name', response['user']['name']);
      await preferences.setString('email', response['user']['email']);
      await preferences.setString('mobile', response['user']['mobile']);
      await preferences.setString('token', response['token']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardActivity(),
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




  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: mobile,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.mobile_friendly),

                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: _obscureText,
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _toggleObscureText,
                    ),
                    prefixIcon: Icon(Icons.password),
                  ),
                ),
                SizedBox(height: 30.0),

                Center(
                  child: GestureDetector(
                    onTap: (){
                      loginUser();
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
                                    bottomRight: Radius.circular(200),
                                ),
                                color: Colors.red
                            ),
                            child: Text("Sign In", style: TextStyle(color: Colors.white),),
                            alignment: Alignment.center,
                          ),
                          Icon(Icons.login)
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
                      text: 'Do not have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: ' Sign Up',
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
                              MaterialPageRoute(builder: (context) => Register()),
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
    );
  }
}

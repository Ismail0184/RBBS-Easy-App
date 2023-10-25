import 'package:flutter/material.dart';
import 'package:easy/screen/dashboard.dart';
import 'package:easy/screen/register.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    // Handle login logic here
                    //String email = _emailController.text;
                    //String password = _passwordController.text;
                    // Add your authentication logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardActivity()),
                    );
                  },
                  child: Text('Login'),
                ),

                Container(
                  padding: EdgeInsets.all(16.0), // Add your desired padding here
                  child: Text(
                    'Do not have an account?',
                    style: TextStyle(),
                  ),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red, // Set the background color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text('Register Here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

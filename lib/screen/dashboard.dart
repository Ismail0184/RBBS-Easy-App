import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../scanner/coupon_scan.dart';
import '../slider/slider_sreen.dart';
import 'drawer.dart';
import 'appbar.dart';

main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: DashboardActivity()
    );
  }
}


class DashboardActivity extends StatefulWidget {
  @override
  _DashboardActivityState createState() => _DashboardActivityState();
}

class _DashboardActivityState extends State<DashboardActivity> {

  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardActivity(),
    DashboardActivity(),
    QRViewExample(),
  ];

  String searchText = "";
  final TextEditingController _textEditingController = TextEditingController();
  final Color customBackgroundColor = Color(0xFF00FF00); // Replace with your color code


  void _dismissKeyboard() {
    // Unfocus (dismiss) the keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'RBBS Easy'),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Order"),
            BottomNavigationBarItem(icon: Icon(Icons.scanner), label: "Coupon Scan",),
          ],
        ),
        drawer: CustomDrawer(),
        backgroundColor: Colors.grey[100],

        body: Column(
          children: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                TextField(
                  controller: _textEditingController,
                  onChanged: (text) {
                    setState(() {
                      searchText = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Find the BOSCH products here...",
                    hintText: "Search",
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Container(
              width: 360,
              height: 180,
              child: SliderScreen(),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              child: MyRowWidget()
            ),
          ],
        ),
      ),
    );
  }
}

class MyRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
      crossAxisAlignment: CrossAxisAlignment.center, // Adjust alignment as needed
      children: <Widget>[
        Container(
          width: 165,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), // You can adjust the radius as needed
            color: Colors.white, // The background color of the container
          ),
          child: Center(
            child: Text(
              'Rounded Container',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Container(
          width: 165,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), // You can adjust the radius as needed
            color: Colors.white, // The background color of the container
          ),
          child: Center(
            child: Text(
              'Rounded Container',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}





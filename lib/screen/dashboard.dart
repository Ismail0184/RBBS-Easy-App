import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String searchText = "";
  final TextEditingController _textEditingController = TextEditingController();

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
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Order"),
            BottomNavigationBarItem(icon: Icon(Icons.scanner), label: "Coupon Scan"),
          ],
        ),
        drawer: CustomDrawer(),

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
                    labelText: "Find the Best BOSCH Products...",
                    hintText: "Search",
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              width: 360,
              height: 200,
              child: SliderScreen(),
            ),
            Container(
              height: 100,
              width: 100,
              child: Image.network(""),
            ),
          ],
        ),

      ),
    );
  }
}





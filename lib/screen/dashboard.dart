import 'package:easy/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

        body: SingleChildScrollView(
          child: Column(
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
                child: MyRowWidget(),
              ),
              Container(
                child: BestSellerWidget(),
              ),
              Container(
                child: BestSellerProducts1(),
              ),
              Container(
                child: BestSellerProducts2(),
              ),
              Container(
                child: PromotionsWidget(),
              ),
              Container(
                child: PromosionContainer(),
              )
            ],
          ),
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
            borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            color: Colors.red
          ),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network("https://cdn-icons-png.flaticon.com/512/4647/4647569.png", width: 70,),
              Text("Power Tools", style: TextStyle(color: Colors.white))
            ],
          )
        ),
        Container(
            width: 165,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.red
            ),

            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network("https://icons.veryicon.com/png/o/construction-tools/industrial-category-icon/auto-parts-2.png", width: 70,),
                Text("Automotive Aftermarket", style: TextStyle(color: Colors.white))
              ],
            )
        ),
      ],
    );
  }
}

class BestSellerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 20),
          width: 165,
          height: 20,
          child: Text("Best Sellers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 20),
          width: 165,
          height: 20,
          alignment: Alignment.centerRight,
          child: Text("View All", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,decoration: TextDecoration.underline,decorationColor: Colors.red,),),
        ),
      ],
    );
  }
}

class BestSellerProducts1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
      crossAxisAlignment: CrossAxisAlignment.center, // Adjust alignment as needed
      children: [
        Container(
            margin: EdgeInsets.only(top: 15),
            width: 165,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network("https://carorbis.com/wp-content/uploads/2023/03/sazdxfcgvhbj-01-1.jpg", width: 120, height: 150,),
                Container(
                  alignment: AlignmentDirectional.center,
                  width: 165,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: Text("Motorcycle Engine Oil", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
        ),
        Container(
            margin: EdgeInsets.only(top: 15),
            width: 165,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network("https://helmetdon.in/wp-content/uploads/2022/02/bosch-fusion-api-sl-sae-5w-30-semi-synthetic-engine-oil-for-passenger-cars-1-l-automotive-parts-and-accessories-bosch.jpg", width: 120, height: 150,),
                Container(
                  alignment: AlignmentDirectional.center,
                  width: 165,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: Text("Car Engine Oil", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
        ),
      ],
    );
  }
}
class BestSellerProducts2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
      crossAxisAlignment: CrossAxisAlignment.center, // Adjust alignment as needed
      children: [
        Container(
            margin: EdgeInsets.only(top: 15),
            width: 165,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network("https://carorbis.com/wp-content/uploads/2023/03/sazdxfcgvhbj-01-1.jpg", width: 120, height: 150,),
                Container(
                  alignment: AlignmentDirectional.center,
                  width: 165,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: Text("Motorcycle Engine Oil", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
        ),
        Container(
            margin: EdgeInsets.only(top: 15),
            width: 165,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network("https://helmetdon.in/wp-content/uploads/2022/02/bosch-fusion-api-sl-sae-5w-30-semi-synthetic-engine-oil-for-passenger-cars-1-l-automotive-parts-and-accessories-bosch.jpg", width: 120, height: 150,),
                Container(
                  alignment: AlignmentDirectional.center,
                  width: 165,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: Text("Car Engine Oil", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
        ),
      ],
    );
  }
}

class PromotionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 20),
          width: 165,
          height: 20,
          child: Text("Promotions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 20),
          width: 165,
          height: 20,
          alignment: Alignment.centerRight,
          child: Text("View All", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,decoration: TextDecoration.underline,decorationColor: Colors.red,),),
        ),
      ],
    );
  }
}

class PromosionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        child: Image.network("https://www.boschtools.com/ca/media/country_pool/website_banner.jpg", width: double.infinity, height: 150,));
  }
}









import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home, size: 30,
            color: Colors.white,
            ),
            Icon(Icons.shopping_cart, size: 30, color: Colors.white,),
            Icon(Icons.scanner, size: 30, color: Colors.white,),
          ],
          color: Colors.red,
          buttonBackgroundColor: Colors.red,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
            });
          },
          letIndexChange: (index) => true,
        ),
        drawer: CustomDrawer(),
        backgroundColor: Colors.grey[100],

        body:
        SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(10),
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
                margin: EdgeInsets.all(10),
                width: 360,
                height: 180,
                child: SliderScreen(),
              ),
              Row(
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 10,bottom: 5),
                    child: Text(
                      'Categories',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
                  Expanded(child: Container(
                    alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 10, bottom: 5),
                      child: Icon(Icons.arrow_right_alt)
                  ))
                ],
              ),

              Container(
                margin: EdgeInsets.all(10),
                height: 150,
                child: CategoriesWedget(),
              ),

              Row(
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: 10,bottom: 5),
                    child: Text(
                      'Populer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
                  Expanded(child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 10, bottom: 5),
                      child: Icon(Icons.arrow_right_alt)
                  ))
                ],
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

class CategoriesWedget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 200,
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
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text('Category $index', style: TextStyle(fontSize: 20, color: Colors.white),),
          ),
        );
      },
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
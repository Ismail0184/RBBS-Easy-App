import 'package:easy/screen/dashboard.dart';
import 'package:easy/screen/login.dart';
import 'package:easy/screen/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../scanner/coupon_scan.dart';



class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _HomeState();
}


class _HomeState extends State<CustomDrawer> {

  late SharedPreferences preferences;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void logout() {
    preferences.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  padding: EdgeInsets.all(0),
                  child:
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.red),
                    accountName: Text("${preferences.getString('name').toString()}", style: TextStyle(color: Colors.white)),
                    accountEmail: Text("${preferences.getString('mobile').toString()}", style: TextStyle(color: Colors.white)),
                    currentAccountPicture: Image.network("https://cdn.freebiesupply.com/logos/large/2x/bosch-logo-black-and-white.png",),
                  )
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardActivity()));
                },
              ),
              ListTile(leading:Icon(Icons.list), title: Text("Products"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriActivity()));
                },
              ),
              ListTile(leading:Icon(Icons.settings),title: Text("Account Settings")),
              ListTile(leading:Icon(Icons.card_giftcard),title: Text("My Orders")),
              ListTile(leading:Icon(Icons.scanner),title: Text("Coupon Scan"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRViewExample()));
                },),
              ListTile(leading:Icon(Icons.local_offer),title: Text("Promotions")),
              ListTile(leading:Icon(Icons.home),title: Text("Reward Points")),
              ListTile(leading:Icon(Icons.help),title: Text("Help Center ")),
              ListTile(leading:Icon(Icons.logout),title: Text("Logout"),
                onTap: () {
                  logout();                },
              ),
            ],
          ),
        );
  }
}

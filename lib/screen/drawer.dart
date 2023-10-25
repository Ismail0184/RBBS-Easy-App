import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  padding: EdgeInsets.all(0),
                  child:
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    accountName: Text("Md Jasim Uddin", style: TextStyle(color: Colors.black)),
                    accountEmail: Text("jasim1989@gmail.com", style: TextStyle(color: Colors.black)),
                    currentAccountPicture: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Bosch-logo.svg/2560px-Bosch-logo.svg.png"),
                  )
              ),
              ListTile(leading:Icon(Icons.list), title: Text("Products")),
              ListTile(leading:Icon(Icons.settings),title: Text("Account Settings")),
              ListTile(leading:Icon(Icons.card_giftcard),title: Text("My Orders")),
              ListTile(leading:Icon(Icons.scanner),title: Text("Coupon Scan")),
              ListTile(leading:Icon(Icons.local_offer),title: Text("Promotions")),
              ListTile(leading:Icon(Icons.home),title: Text("Reward Points")),
              ListTile(leading:Icon(Icons.help),title: Text("Help Center ")),
              ListTile(leading:Icon(Icons.logout),title: Text("Logout")),
            ],
          ),
        );
  }
}

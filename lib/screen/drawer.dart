import 'package:easy/modules/employeeDashboard/homeEmployeeDashboard.dart';
import 'package:easy/modules/sales/salesDashboard.dart';
import 'package:easy/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboards.dart';



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
                    currentAccountPicture: Image.network("${preferences.getString('profilePicture').toString()}",),
                  )
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Employee Dashboard"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmployeeDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Accounts Module"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Sales Module"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => salesDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Warehouse Module"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.logout),title: Text("Logout"),
                onTap: () {
                  logout();                },
              ),
            ],
          ),
        );
  }
}

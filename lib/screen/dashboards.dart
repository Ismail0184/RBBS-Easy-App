import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';

void main() {
  runApp(ERPApp());
}

class ERPApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserDashboard(),
    );
  }
}

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOverviewCard('Total Sales', '\$50,000', Icons.attach_money, Colors.green),
                _buildOverviewCard('Pending Orders', '25', Icons.pending_actions, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildActivityTile('Order #1234 was shipped.', Icons.local_shipping, Colors.blue),
            _buildActivityTile('New user registered.', Icons.person_add, Colors.green),
            _buildActivityTile('Inventory updated for product #567.', Icons.update, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 150,
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(String description, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle activity tap
      },
    );
  }
}

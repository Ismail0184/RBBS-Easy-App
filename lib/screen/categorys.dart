import 'package:easy/screen/appbar.dart';
import 'package:easy/screen/drawer.dart';
import 'package:easy/screen/sub-category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: CategoriActivity()
    );
  }
}

class CategoriActivity extends StatelessWidget {

  var MyCategories = [
     {"id":"1","image":"https://coatek.com.au/wp-content/uploads/2021/01/Fitted-for-website-thumbnail.jpg", "name":"Power Tools",},
     {"id":"2","image":"https://m.media-amazon.com/images/I/51jsn8ANpdL.jpg", "name":"Automotive Aftermarket",},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'RBBS Easy'),
        drawer: CustomDrawer(),
        body: Column(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 20,bottom: 20),
              width: double.infinity,
              height: 30,
              alignment: Alignment.center,
              child: Text("Categories", style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: MyCategories.length,
                  itemBuilder: (context, index){
                    return

                      GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => subCategoriActivity()),
                        );
                        },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        height: 100,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(MyCategories[index]['image']!, width: 60),
                            Text(MyCategories[index]['name']!),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
            // Other widgets can be added below the ListView
          ],
        ),
      ),
    );
  }
}


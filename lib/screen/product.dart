import 'package:easy/screen/appbar.dart';
import 'package:easy/screen/drawer.dart';
import 'package:easy/screen/productDetails.dart';
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
        theme: ThemeData(primarySwatch: Colors.grey,
        ),
        debugShowCheckedModeBanner: false,
        home: ProductActivity()
    );
  }
}

class ProductActivity extends StatelessWidget {

  var MyCategories = [
    {"id":"1","image":"https://coatek.com.au/wp-content/uploads/2021/01/Fitted-for-website-thumbnail.jpg", "name":"This is car",},
    {"id":"2","image":"https://m.media-amazon.com/images/I/51jsn8ANpdL.jpg", "name":"This is lubricant",},
    {"id":"3","image":"https://cloudfront-us-east-1.images.arcpublishing.com/gray/AHXGQIDKX3NQW2E6OZSWCQWQTA.jpg", "name":"This is Parts",},
    {"id":"4","image":"https://cloudfront-us-east-1.images.arcpublishing.com/gray/AHXGQIDKX3NQW2E6OZSWCQWQTA.jpg", "name":"This is Parts",},
    {"id":"5","image":"https://cloudfront-us-east-1.images.arcpublishing.com/gray/AHXGQIDKX3NQW2E6OZSWCQWQTA.jpg", "name":"This is Parts",},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Products'),
        body:
        Column(
          children: <Widget>[

            Container(
                margin: EdgeInsets.only(top: 20,bottom: 20),
                width: double.infinity,
                height: 30,
                alignment: Alignment.center,
                child: Text("Products", style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
            ),

            Expanded(
              child: ListView.builder(
                  itemCount: MyCategories.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductView()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                        width: 165,
                        height: 250,
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
                        child: Column(
                          children: [
                            Image.network(MyCategories[index]['image']!, width: 160),
                            Text(MyCategories[index]['name']!),

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

class CategoryWidget extends StatelessWidget {
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


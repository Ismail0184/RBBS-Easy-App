import 'package:easy/screen/appbar.dart';
import 'package:easy/screen/drawer.dart';
import 'package:easy/screen/sub-category.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Item {
  final int id;
  final String name;
  final String image;

  Item({required this.id, required this.name, required this.image});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

Future<List<Item>> fetchData() async {
  final response = await http.get(Uri.parse('http://bosch.icpbd.com/api/get-category'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Item.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data from the API');
  }
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriActivity(),
    );
  }
}

class CategoriActivity extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<CategoriActivity> {
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    items = fetchData();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Categories'),
        body:
        FutureBuilder<List<Item>>(
          future: items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final itemList = snapshot.data;
              return
                ListView.builder(
                  itemCount: itemList?.length,
                  itemBuilder: (context, index) {
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
                              Image.network(itemList![index].image!, width: 60),
                              Text(itemList![index].name!),
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
                  },
                );
            }
          },
        ),

      ),
    );
  }
}



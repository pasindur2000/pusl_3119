import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pusl_3119/constants.dart';
import 'package:pusl_3119/models/plants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<Plant> _plantList = Plant.plantList;
  List<String> _plantTypes = [
    'Recommended',
    'Vegetable',
    'Fruits',
    'Grains',
    'Seeds',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    width: size.width * .9,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.black54.withOpacity(.6),),
                        const Expanded(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                              hintText: 'Search Disease',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic,color: Colors.black54.withOpacity(.5),),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50.0,
              width: size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _plantTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Text(
                          _plantTypes[index],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.w300,
                            color: selectedIndex == index
                                ? Constants.primaryColor
                                : Constants.blackColor,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: size.height * .3,
              child: ListView.builder(
                itemCount: _plantList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 20,
                      child: Container(
                         height: 50,
                        width: 50,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(_plantList[index].isFavorated == true ? Icons.favorite : Icons.favorite_border),
                          color: Constants.primaryColor,
                          iconSize: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      right: 50,
                      top: 50,
                      bottom: 50,
                      child: Image.asset('assets/images/1st.png'),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_plantList[index].category,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),),
                          Text(_plantList[index].plantName, style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text( _plantList[index].price.toString() , style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16
                        ),),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Constants.primaryColor.withOpacity(.8),
                  borderRadius: BorderRadius.circular(20),
                ),

              );


              }
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text('New Diseases', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .5,
              child: ListView.builder(
                itemCount: _plantList.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    height: 80.0,
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                height: 80.0,
                                child: Image.asset('assets/images/1st.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_plantList[index].category),
                                  Text(_plantList[index].plantName, style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Constants.blackColor,
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(_plantList[index].price.toString(), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Constants.primaryColor,
                          ),),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

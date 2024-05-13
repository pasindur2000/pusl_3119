import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants.dart';

class ResultPage extends StatelessWidget {
  final File imageFile;
  final String label;
  final double confidence;

  const ResultPage({
    Key? key,
    required this.imageFile,
    required this.label,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(.6),
                    ),
                    child: Icon(Icons.arrow_back_outlined,color: Constants.primaryColor,),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Container(
                    width: 256,
                    height: 256,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    label,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.9)),
                  ),
                  SizedBox(height: 20),
                  if (label.isNotEmpty)
                    FutureBuilder(
                      future: fetchDiseaseInfo(label),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error fetching disease information: ${snapshot.error}');
                        } else if (snapshot.hasData && snapshot.data!.exists) {
                          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
                          if (data != null) {
                            return Container(
                              width: 350,
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
                              ),

                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Possible Causes:',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      data['possibleCauses'] ?? 'N/A',
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Possible Solution:',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      data['possibleSolution'] ?? 'N/A',
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );

                          } else {
                            return Text('Disease information not found');
                          }
                        } else {
                          return Text('Disease information not found');
                        }
                      },
                    ),
                  if (label.isEmpty)
                    Text(
                      'Error fetching disease information',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DocumentSnapshot> fetchDiseaseInfo(String diseaseName) async {
    try {
      return await FirebaseFirestore.instance
          .collection('diseases')
          .doc(diseaseName)
          .get();
    } catch (e) {
      throw Exception('Error fetching disease information: $e');
    }
  }
}

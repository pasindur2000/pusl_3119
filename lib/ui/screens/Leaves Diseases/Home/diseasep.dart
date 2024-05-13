import 'package:flutter/material.dart';
import 'dart:io';

class DiseaseN extends StatelessWidget {
  final File? imageFile; // Make imageFile nullable
  final String label;

  const DiseaseN({
    Key? key,
    required this.imageFile,
    required this.label,
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
                    child: Icon(Icons.arrow_back_outlined,color: Colors.black,), // Changed to black color for the icon
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
                  imageFile != null ? // Check if imageFile is not null
                  Container(
                    width: 256,
                    height: 256,
                    child: Image.file(
                      imageFile!, // Use imageFile only if not null
                      fit: BoxFit.cover,
                    ),
                  ) :
                  Text(
                    'No image selected', // Display message if imageFile is null
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 20),
                  Text(
                    'Error fetching the disease information',
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
}

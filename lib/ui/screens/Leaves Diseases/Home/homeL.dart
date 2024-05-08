import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;
import '../../../../constants.dart';
import 'result_page.dart';

// Define colors
const Color kSecondary = Color(0xFFABCDEF);
const Color kMain = Color(0xFF012345);
const Color kWhite = Colors.white;

class HomeLeaves extends StatefulWidget {
  const HomeLeaves({Key? key}) : super(key: key);

  @override
  State<HomeLeaves> createState() => _HomeLeavesState();
}

class _HomeLeavesState extends State<HomeLeaves> {
  File? filePath;
  String label = '';
  double confidence = 0.0;

  Future<void> _tfliteInit() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
  }

  pickImageGallery()async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );

    if (recognitions == null) {
      devtools.log("Recognition is Null");
      return;
    }
    devtools.log(recognitions.toString());

    setState(() {
      confidence = (recognitions[0]['confidence']*100);
      label = recognitions[0]['label'].toString();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          imageFile: imageMap,
          label: label,
          confidence: confidence,
        ),
      ),
    );

  }
  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfliteInit();
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
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
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 73.0, vertical: 10.0), // Adjust the padding values as needed
                  child: Text(
                    'Instructions',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.all(20.0), // Adjust margin as needed
                  padding: EdgeInsets.all(10.0), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6), // Change color as needed
                    borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(.6),
                          child: Text(
                            '1',
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                        ),
                        title: Text(
                          'Take/Select a photo of an affected plant by tapping the camera button below',
                          style: TextStyle(color: Constants.primaryColor,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(.6),
                          child: Text(
                            '2',
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                        ),
                        title: Text(
                          'Give it a short while before you can get a suggestion of the disease',
                          style: TextStyle(color: Constants.primaryColor,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                      minimumSize: const Size(200, 50), // Change these values to adjust the size
                    ),
                    child: const Text(
                      'Take A Photo',
                      style: TextStyle(
                          color: Color(0xff296e48),
                          fontSize: 20
                      ), ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  ElevatedButton(
                    onPressed: (){
                      pickImageGallery();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                      minimumSize: const Size(200, 50), // Change these values to adjust the size
                    ),
                    child: const Text(
                      'Pick from gallery',
                      style: TextStyle(
                          color: Color(0xff296e48),
                          fontSize: 20
                      ), ),
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

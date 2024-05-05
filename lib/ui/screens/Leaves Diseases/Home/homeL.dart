import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;

import '../../../../constants.dart';

class HomeLeaves extends StatefulWidget {
  const HomeLeaves({Key? key}) : super(key: key);

  @override
  State<HomeLeaves> createState() => _HomeLeavesState();
}

class _HomeLeavesState extends State<HomeLeaves> {

  File? filePath;
  String label = '';
  double confidence = 0.0;

  Future<void> _tfliteInit() async{
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    elevation: 20,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Container(
                              height: 280,
                              width: 280,
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: filePath == null ? const Text('')
                                  : Image.file(filePath!, fit: BoxFit.fill,),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

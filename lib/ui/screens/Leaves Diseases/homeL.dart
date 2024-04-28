import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;

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
        model: "assets/models/model_unquant.tflite",
        labels: "assets/models/labels.txt",
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
      appBar: AppBar(
        title: const Text("Tomato Disease Detection"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/up.png'))
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

              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black
                ),
                child: const Text(
                    'Take a photo'
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              ElevatedButton(
                onPressed: () {
                  pickImageGallery();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black
                ),
                child: const Text(
                    'Pick from Gallery'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
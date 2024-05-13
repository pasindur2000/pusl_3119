import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffi/ffi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pano1/ui/screens/loglistview.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'model_page.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';


late User loggedinuser;
late String client;



class ImagesStitch {
  final dynamicLibrary = Platform.isAndroid
      ? DynamicLibrary.open("libOpenCV_ffi.so")
      : DynamicLibrary.process();

  Future<void> stitchImages(
      final List<String> imagesPathToStitch,
      final String imagePathToCreate,
      final bool isVertical,
      final Function onCompleted) async {
    final stitchFunction = dynamicLibrary.lookupFunction<
        Void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>),
        void Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>)>('stitch');
    stitchFunction(
      imagesPathToStitch.toString().toNativeUtf8(),
      imagePathToCreate.toNativeUtf8(),
      isVertical.toString().toNativeUtf8(),
    );
    onCompleted(imagePathToCreate);
  }
}

class PanoramaScreen extends StatefulWidget {
  const PanoramaScreen({Key? key}) : super(key: key);

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen> {
  final _imagesStitch = ImagesStitch();
  final ImagePicker _picker = ImagePicker();
  String? _imagePathToShow = null;
  bool _panoramaCreated = false;


  ///to get current user
  void getcurrentuser() async {
    try {
      // final user = await _auth.currentUser();
      ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        client = loggedinuser.email!;

        ///i have to call the getdatafrm the function here and parse client as a parameter

        print(loggedinuser.email);




      }
    } catch (e) {
      print(e);
    }
  }
  ///curent ser ed
  ///superinit
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }
  DateTime now = DateTime.now();
  final _firestore = FirebaseFirestore.instance;

  Future<void> _uploadImage() async{
    if(_imagePathToShow != null && _panoramaCreated) {
      File file = File(_imagePathToShow!);
      try {
        // Initialize Firebase Storage with your bucket
        FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://disectornew.appspot.com');

        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference = storage.ref('uploads/${basename(file.path)}');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        //to pload to firestore
        String scanid = "$client$now";
        final pnromaset =
        _firestore.collection("logs").doc(scanid);
        pnromaset.set({
          'scanid': scanid,
          'plink': downloadURL,
          'starcount':0,

        });


        // Print the download URL
        if (kDebugMode) {
          print('Image uploaded successfully. Download URL: $downloadURL');
        }

        setState(() {
          _panoramaCreated = false;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Panorama created and uploaded successfully')),
        );
      } catch (e) {
        // If any error occurs
        if (kDebugMode) {
          print(e);
        }
      }
    } else if(_imagePathToShow != null && !_panoramaCreated) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Panorama not created yet')),
      );
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }


  Future<void> _pickImages() async {
    final imageFiles = await _picker.pickMultiImage();
    if (imageFiles != null) {
      final imagePaths = imageFiles.map((imageFile) => imageFile.path).toList();
      String dirPath =
          "${(await getApplicationDocumentsDirectory()).path}/${DateTime.now()}_.jpg";
      _imagesStitch.stitchImages(
          imagePaths, dirPath, false, (stitchedImagesPath) {
        setState(() {
          _imagePathToShow = dirPath;
          _panoramaCreated = true;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Panorama created successfully')),
        );
      });
    }
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
                    child: Icon(Icons.arrow_back_outlined, color: Constants.primaryColor,),
                  ),
                ),
                GestureDetector(
                  onTap: _uploadImage,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(.6),
                    ),
                    child: Icon(Icons.file_upload_outlined, color: Constants.primaryColor,),
                  ),
                ),
              ],
            ),
          ),
          // Display the panorama image if it's created
          if (_imagePathToShow != null)
            Center(
              child: SizedBox(
                height: 250, // Adjust the height according to your preference
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.file(File(_imagePathToShow!)),
                ),
              ),
            ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(40.0), // Increased padding
              child: ElevatedButton(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                ),
                child: const Text(
                  'Select Images',
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 20
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(40.0), // Increased padding
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ModelPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.6), // Change this value to adjust the opacity
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 20
                  ),  // Change this value to adjust the font size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
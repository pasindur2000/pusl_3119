//adding database to when user apply images it generated panorama and it applied to the 3d model

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:io';

late User loggedinuser;
late String client;

class Single3d extends StatefulWidget {
  final String gemcode;
  final String ilink;

  Single3d({Key? key, required this.gemcode, required this.ilink}) : super(key: key);

  @override
  State<Single3d> createState() => _Single3dState();
}

class _Single3dState extends State<Single3d>
    with SingleTickerProviderStateMixin{

  late Scene _scene;
  Object? _moon;
  Object? _moonObj;
  late AnimationController _controller;

  GlobalKey globalKey = new GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String selectedgemcode;
  String imglink = "";
  late String selecedlink;

  @override
  void initState() {
    super.initState();
    selectedgemcode = widget.gemcode;
    selecedlink = widget.ilink;
    getcurrentuser();
    retrieveData();
    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_moon != null) {
          _moon!.rotation.y = _controller.value * 360;
          _moon!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
  Future<void> retrieveData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentSnapshot _documentSnapshot = await _firestore.collection(
        'logs').doc(selectedgemcode).get();

    if (_documentSnapshot.exists) {
      imglink = _documentSnapshot.get('plink');


      // Now you can use these variables as needed
      print('Name: $imglink');
    } else {
      print('Document does not exist');
    }
  }

  Future<Mesh> generateSphereMesh(
      {num radius = 0.5,
        int latSegments = 32,
        int lonSegments = 64,
        required String texturePath}) async {
    int count = (latSegments + 1) * (lonSegments + 1);
    List<Vector3> vertices = List<Vector3>.filled(count, Vector3.zero());
    List<Offset> texcoords = List<Offset>.filled(count, Offset.zero);
    List<Polygon> indices =
    List<Polygon>.filled(latSegments * lonSegments * 2, Polygon(0, 0, 0));

    int i = 0;
    for (int y = 0; y <= latSegments; ++y) {
      final double v = y / latSegments;
      final double sv = math.sin(v * math.pi);
      final double cv = math.cos(v * math.pi);
      final double adjustedRadius = radius * (0.5 + 0.8 * cv); // Adjust the radius here
      for (int x = 0; x <= lonSegments; ++x) {
        final double u = x / lonSegments;
        vertices[i] = Vector3(
            adjustedRadius * math.cos(u * math.pi * 2.0) * sv,
            adjustedRadius * cv,
            adjustedRadius * math.sin(u * math.pi * 2.0) * sv);
        texcoords[i] = Offset(1.0 - u, 1.0 - v);
        i++;
      }
    }

    i = 0;
    for (int y = 0; y < latSegments; ++y) {
      final int base1 = (lonSegments + 1) * y;
      final int base2 = (lonSegments + 1) * (y + 1);
      for (int x = 0; x < lonSegments; ++x) {
        indices[i++] = Polygon(base1 + x, base1 + x + 1, base2 + x);
        indices[i++] = Polygon(base1 + x + 1, base2 + x + 1, base2 + x);
      }
    }
    Future<ui.Image> loadImageFromUrl(String url) async {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final request = await response.close();
      final List<int> imagesBytes = await consolidateHttpClientResponseBytes(request);
      final Uint8List uint8List = Uint8List.fromList(imagesBytes);
      final Completer<ui.Image> completer = Completer<ui.Image>();
      ui.decodeImageFromList(uint8List, (ui.Image img) {
        completer.complete(img);
      });
      return completer.future;
    }
    ui.Image texture = await loadImageFromUrl(selecedlink);
    // ui.Image texture = await loadImageFromUrl('https://firebasestorage.googleapis.com/v0/b/disectornew.appspot.com/o/uploads%2F2024-05-05%2016%3A47%3A31.449131_.jpg?alt=media&token=d15671b6-e5d6-4e8f-8abb-0434bc591d79');
    final Mesh mesh = Mesh(
        vertices: vertices,
        texcoords: texcoords,
        indices: indices,
        texture: texture,
        texturePath: texturePath);
    return mesh;
  }
  void generateSphereObject(Object parent, String name, double radius,
      bool backfaceCulling, String texturePath) async {
    final Mesh mesh =
    await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent.add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    _moonObj = Object(scale: Vector3(2.0, 2.0, 2.0), backfaceCulling: true, fileName: 'assets/images/background.jpeg');
    _moon = Object(name: 'moon', scale: Vector3(10, 10, 10));
    generateSphereObject(_moon!, 'surface', 0.5, true, 'assets/images/c.jpeg');
    _moonObj!.add(_moon!);
    scene.world.add(_moonObj!);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text( 'Default Title'),
        centerTitle: true,
      ),
      body: Center(
        child:Cube(
          onSceneCreated: _onSceneCreated,
        ),
        /* ElevatedButton(
          child: Text('test'),
          onPressed: (){
            print(imglink);
          },
        ),*/
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

//
class ModelPage extends StatefulWidget {
  const ModelPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage>
    with SingleTickerProviderStateMixin {

  late Scene _scene;
  Object? _moon;
  Object? _moonObj;
  late AnimationController _controller;

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

    ui.Image texture = await loadImageFromAsset(texturePath);
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
    generateSphereObject(_moon!, 'surface', 0.5, true, 'assets/images/panonew.jpeg');
    _moonObj!.add(_moon!);
    scene.world.add(_moonObj!);
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Default Title'),
        centerTitle: true,
      ),
      body: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_model_viewer/flutter_model_viewer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String src1 =
      'https://superd.oss-cn-beijing.aliyuncs.com/pub_upload/2022-03-09/tianxie.glb';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: const [
            SizedBox(
              height: 400,
              child: ModelViewer(
                src: src1,
                ar: false,
                rotationPerSecond: "50deg",
                autoRotate: true,
                autoRotateDelay: 500,
                cameraControls: true,
                openCache: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

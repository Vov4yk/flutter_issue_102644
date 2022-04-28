import 'package:flutter/material.dart';
import 'package:flutter_issues_102644/camera_preview.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Issues 102644',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Container(color: Colors.amber.withAlpha(20)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Page2()),
        ),
        tooltip: 'next',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  void callMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext content) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        CameraAttachmentPreview(
                          onPhoto: () => getImage(),
                          onVideo: () => getImage(),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Divider(),
                ],
              ),
            ),
          );
        });
  }

  void getImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.camera);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: GestureDetector(
        onTap: () => print('tap'),
        child: Container(color: Colors.greenAccent.withAlpha(30)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => callMenu(),
        tooltip: 'camera',
        child: const Icon(Icons.camera),
      ),
    );
  }
}

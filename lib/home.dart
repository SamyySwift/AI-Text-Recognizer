import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloaded = false;
  String result = '';
  File image;
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  FlutterTts flutterTts = FlutterTts();

  final picker = ImagePicker();

  pickImage() async {
    var imagefile = await picker.getImage(source: ImageSource.gallery);

    if (imagefile == null) return null;

    setState(() {
      image = File(imagefile.path);
      isloaded = true;
    });
  }

  cameraImage() async {
    var imagefile = await picker.getImage(source: ImageSource.camera);

    if (imagefile == null) return null;

    setState(() {
      image = File(imagefile.path);
      isloaded = true;
    });
  }

  detectText() async {
    var inputImage = InputImage.fromFilePath(image.path);
    var text = await _textDetector.processImage(inputImage);

    for (TextBlock block in text.textBlocks) {
      for (TextLine line in block.textLines) {
        for (TextElement ele in line.textElements) {
          result = result + ele.getText + ' ';
        }
      }

      setState(() {
        result = result;
      });
    }
  }

  void clear() {
    setState(() {
      isloaded = false;
      result = '';
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _textDetector.close();
  }

  Future _speak() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(result.isEmpty ? 'No text detected' : result);
  }

  Future _pause() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.mic), onPressed: _speak),
          IconButton(icon: Icon(Icons.stop_circle), onPressed: _pause)
        ],
        title: Text(
          'AI Text Recogniser',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          isloaded
              ? Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(image), fit: BoxFit.cover)),
                  ),
                )
              : Center(
                  child: Container(
                      child: Column(
                    children: [
                      Icon(Icons.add_a_photo),
                      SizedBox(height: 20),
                      Text(
                        'No image selected !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  )),
                ),
          // SizedBox(height: 100),
          Spacer(),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                result.isEmpty ? 'No text detected !!!' : result,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Spacer(),
          // SizedBox(height: MediaQuery.of(context).size.height - 800),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: pickImage,
                    onLongPress: cameraImage,
                    icon: Icon(Icons.add_a_photo),
                    label: Text(
                      'Add image',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50))),
                    onPressed: detectText,
                    icon: Icon(Icons.scanner),
                    label: Text(
                      'Extract text',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50))),
                    onPressed: clear,
                    icon: Icon(Icons.clear_rounded, size: 30),
                    label: Text(
                      'Clear',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

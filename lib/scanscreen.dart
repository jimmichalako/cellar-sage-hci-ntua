import 'dart:io';
import 'package:cellar_sage/homescreen.dart';
import 'package:cellar_sage/leaderboardscreen.dart';
import 'package:cellar_sage/scanresults.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'navbar.dart';
import 'package:camera/camera.dart';
import 'package:cellar_sage/profilescreen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _ScanScreen(),
        ),
      ),
    );
  }
}

class _ScanScreen extends StatefulWidget {
  const _ScanScreen();

  @override
  State<_ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<_ScanScreen> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  bool textScanning = false;

  String scannedText = "";

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(
        cameras![0],
        ResolutionPreset.max,
      );
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const Profile();
          }, transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }));
        }
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const HomeScreen();
          }, transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
            height: 65,
            width: 65,
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/logout.png'),
              onPressed: () {
                // Handle logout logic here
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (textScanning) const CircularProgressIndicator(),
                  if (!textScanning && image == null)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey[300]!,
                      alignment: Alignment.center,
                      child: const Text(
                        'Please scan wine label \n or chose an existing photo \n \n Database has wines: Wine 1, Wine 2, ... Wine 8',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff49454f),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (image != null) Image.file(File(image!.path)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: Colors.white,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: Colors.white,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    scannedText,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              )),
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (scannedText == "") {
              showDialog(
                context: context, // Assuming you have access to the context
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Unsuccessful scan. Couldn\'t read label'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop(); // Close the alert
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanResults(
                    scannedText: scannedText,
                    shouldAddScan: true,
                  ),
                ),
              );
            }
          },
          label: const Text(
            'Search',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: Color(0xffffffff),
            ),
          ),
          icon: const Icon(Icons.search), // Wrap Icons.search with Icon widget
          backgroundColor: const Color(0xff6750a4),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(color: Color(0xff211f26)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Add this line
            children: [
              NavBarButton(
                  iconPath: 'assets/home-icon.png',
                  label: 'Home',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }),
              NavBarButton(
                  iconPath: 'assets/camera-icon.png',
                  label: 'Scan',
                  onPressed: () {}),
              NavBarButton(
                  iconPath: 'assets/profile-icon.png',
                  label: 'Profile',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  }),
              NavBarButton(
                  iconPath: 'assets/trophy.png',
                  label: 'Leaderboard',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Leaderboard()));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        image = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      image = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (scannedText == "") {
          scannedText = "$scannedText${line.text}";
        }
        else {
          scannedText = "$scannedText ${line.text}";
        }
        // print(scannedText);
        // print(scannedText.length);
      }
    }
    textScanning = false;
    setState(() {});
  }
}

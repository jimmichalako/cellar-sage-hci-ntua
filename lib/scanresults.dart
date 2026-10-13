import 'dart:convert';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:cellar_sage/login_page.dart';
import 'package:cellar_sage/homescreen.dart';
import 'package:cellar_sage/scanscreen.dart';
import 'package:cellar_sage/userreviewsscreen.dart';
import 'package:cellar_sage/profilescreen.dart';
import 'package:cellar_sage/leaderboardscreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScanResults extends StatelessWidget {
  final String scannedText;
  final bool shouldAddScan;

  const ScanResults(
      {Key? key, required this.scannedText, required this.shouldAddScan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _ScanResults(
            scannedText: scannedText,
            shouldAddScan: shouldAddScan,
          ),
        ),
      ),
    );
  }
}

class _ScanResults extends StatefulWidget {
  final bool shouldAddScan;
  final String scannedText;

  const _ScanResults(
      {Key? key, required this.scannedText, required this.shouldAddScan})
      : super(key: key);

  @override
  State<_ScanResults> createState() => _ScanResultsState();
}

class _ScanResultsState extends State<_ScanResults> {
  double score = 0;
  String wineInfo = '';
  String wineTitle = '';

  late TextEditingController reviewController;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    fetchWine();

  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username').toString();
    return username;
  }

  final String searchWine = 'http://83.212.74.53:5000/hci_api/search_wine';
  final String uriAddScan = 'http://83.212.74.53:5000/hci_api/add_scan';
  final String uriAddReview = 'http://83.212.74.53:5000/hci_api/add_review';

  Future<void> fetchWine() async {
    String username = await getUsername();
    final response = await http.post(
      Uri.parse(searchWine),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'wine_name': widget.scannedText,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      score = data['results'][0][2];
      wineInfo = data['results'][0][1];
      wineTitle = data['results'][0][0];
      setState(() {});

      if (widget.shouldAddScan) {
        var response2 = await http.post(
          Uri.parse(uriAddScan),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'wine_name': wineTitle,
            'username': username,
          }),
        );

        if (!context.mounted) {
          return;
        }

        if (response2.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Scan Added'),
                content: const Text('Your scan has been successfully added.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Scan was not added.'),
                content: const Text('Failed to add scan, unknown reason.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
    if (response.statusCode == 400 && context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No such wine in database.\nTry wine names Wine 1,... Wine 8.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 350,
              child: Image.asset(
                'assets/wine.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                wineTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Score: ${score.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 0.20,
                        letterSpacing: 0.10,
                      ),
                    ),
                    Image.asset(
                      'assets/star.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                )),
            Container(
              height: 150,
              width: 325,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              alignment: Alignment.center,
              child: Text(
                wineInfo.toString(),
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0.10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserReviews(
                                    wineTitle: wineTitle,
                                  )));
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff6750a4),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Center(
                          child: Text(
                            'See user reviews',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: 300,
                                height: 400,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Text(
                                            'Create your review',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                              height: 0.04,
                                              letterSpacing: 0.5,
                                            ),
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text(
                                          'maximum 150 characters',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                            height: 0.04,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: RatingBar(
                                            minRating: 0,
                                            maxRating: 5,
                                            initialRating: 3,
                                            itemSize: 40,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            allowHalfRating: true,
                                            ratingWidget: RatingWidget(
                                                full: const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                half: const Icon(
                                                  Icons.star_half,
                                                  color: Colors.amber,
                                                ),
                                                empty: const Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                )),
                                            onRatingUpdate: (rating) {
                                              score = rating;
                                            }),
                                      ),
                                      SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                              controller: reviewController,
                                              minLines: 1,
                                              maxLines: 5,
                                              maxLength: 150,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              decoration: const InputDecoration(
                                                  hintText: 'Type here',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16),
                                                  border:
                                                      OutlineInputBorder()))),
                                      TextButton(
                                          onPressed: () async {
                                            String username =
                                                await getUsername();
                                            String review =
                                                reviewController.text;
                                            if (review == "" ||
                                                username == "" ||
                                                wineTitle == "") {
                                              return;
                                            }
                                            var response = await http.post(
                                              Uri.parse(uriAddReview),
                                              headers: {
                                                'Content-Type':
                                                    'application/json',
                                              },
                                              body: jsonEncode({
                                                "username": username,
                                                "wine_name": wineTitle,
                                                "review": review,
                                                "score": score,
                                              }),
                                            );

                                            if (!context.mounted) {
                                              return;
                                            }
                                            if (response.statusCode == 200) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Review added'),
                                                    content: const Text(
                                                        'Your review has been successfully added.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                          var respBody =
                                                              jsonDecode(
                                                                  response
                                                                      .body);
                                                          score = respBody[
                                                              'newScore'];
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Review was not added.'),
                                                    content: const Text(
                                                        'Your review was not added.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                              width: 100,
                                              height: 50,
                                              padding: const EdgeInsets.all(12),
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF6750A4),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                              ),
                                              child: const Center(
                                                  child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0.10,
                                                  letterSpacing: 0.10,
                                                ),
                                              ))))
                                    ]),
                              ),
                            );
                          });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff6750a4),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'Write your review',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 0.10,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanScreen()));
                }),
            NavBarButton(
                iconPath: 'assets/profile-icon.png',
                label: 'Profile',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
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
    );
  }
}

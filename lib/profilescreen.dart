import 'package:intl/intl.dart';

import 'leaderboardscreen.dart';
import 'homescreen.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cellar_sage/scanscreen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _ProfileScreen(),
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen();

  @override
  State<_ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfileScreen> {
  final String uriScanNumber = 'http://83.212.74.53:5000/hci_api/get_num_scans';
  final String uriReviewNumber =
      'http://83.212.74.53:5000/hci_api/get_num_reviews';
  final String uriSagePoints =
      'http://83.212.74.53:5000/hci_api/get_sage_points';
  final String uriReviews =
      'http://83.212.74.53:5000/hci_api/get_reviews_of_user';
  final String uriUpdateCreds = 'http://83.212.74.53:5000/hci_api/update_user';
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController=TextEditingController();
    emailController=TextEditingController();
    passwordController=TextEditingController();
}
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username').toString();
    return username;
  }

  Future<Map<String, dynamic>> fetchAllData() async {
    String username = await getUsername();
    final sagePointsResponse = await http.post(
      Uri.parse(uriSagePoints),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );
    final wineReviewsCountResponse = await http.post(
      Uri.parse(uriReviewNumber),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );
    final wineScansResponse = await http.post(
      Uri.parse(uriScanNumber),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );
    final wineReviews = await http.post(
      Uri.parse(uriReviews),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );

    if (sagePointsResponse.statusCode == 200 &&
        wineReviewsCountResponse.statusCode == 200 &&
        wineScansResponse.statusCode == 200 &&
        wineReviews.statusCode == 200) {
      var sagePoints = jsonDecode(sagePointsResponse.body);
      var reviewNumber = jsonDecode(wineReviewsCountResponse.body);
      var scanNumber = jsonDecode(wineScansResponse.body);
      var userReviews = jsonDecode(wineReviews.body);
      return {
        'wineScans': scanNumber["results"][0][0],
        'sagePoints': sagePoints["results"][0][0],
        'wineReviews': reviewNumber["results"][0][0],
        'userReviews': userReviews["results"],
      };
    }
    return {
      'wineScans': '0',
      'sagePoints': '0',
      'wineReviews': '0',
      'userReviews': [
      ],
    };
  }

  Future<void> storeUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const Leaderboard();
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
            return const ScanScreen();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/profile-image.png',
                      fit: BoxFit.cover,
                      width: 150, // Adjust the width as needed
                      height: 150, // Adjust the height as needed
                    ),
                    TextButton(
                      onPressed: () {
                        // Edit profile button
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Profile'),
                              content: SingleChildScrollView(
                                child: SizedBox(
                                  // Set a maximum height
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextField(
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Username',
                                        ),
                                      ),
                                      TextField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                        ),
                                      ),
                                      TextField(
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                          labelText: 'Password',
                                        ),
                                        obscureText: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    passwordController.clear();
                                    usernameController.clear();
                                    emailController.clear();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    // Save the changes
                                    String currUsername = await getUsername();
                                    String username = usernameController.text;
                                    String email = emailController.text;
                                    String password = passwordController.text;

                                    Map<String, String> data = {};
                                    data['current_username'] = currUsername;
                                    if (username.isNotEmpty) {
                                      data['username'] = username;
                                    }
                                    if (email.isNotEmpty) {
                                      data['email'] = email;
                                    }
                                    if (password.isNotEmpty) {
                                      data['password'] = password;
                                    }

                                    try {
                                      var response = await http.post(
                                        Uri.parse(uriUpdateCreds),
                                        headers: {
                                          'Content-Type': 'application/json',
                                        },
                                        body: jsonEncode(data),
                                      );

                                      if (!context.mounted) {
                                        return;
                                      }

                                      if (response.statusCode == 200) {
                                        if (username.isNotEmpty) {
                                          storeUsername(username);
                                        }
                                        Navigator.of(context).pop();
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Failure !'),
                                              content: const Text(
                                                  'Username or email exists, try specifying new.'),
                                              actions: [
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
                                    } catch (e) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Failure !'),
                                            content: Text(
                                                'Something went wrong, ${e.toString()}'),
                                            actions: [
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
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 200, // Adjust the width as needed
                        height: 30, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: const Color(0xffd0bcff),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff381e72),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: fetchAllData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Wine Scans',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              '${snapshot.data?['wineScans']}'),
                                          // Display the number of wine scans
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Sage Points',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              '${snapshot.data?['sagePoints']}'),
                                          // Display the number of sage points
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Wine Reviews',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              '${snapshot.data?['wineReviews']}'),
                                          // Display the number of wine reviews
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                'My Reviews',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: snapshot.data?['userReviews'].length == 0
                                ? Center(child: Text('No reviews yet'))
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data?['userReviews'].length,
                                  itemBuilder: (context, index) {
                                    var review =
                                        snapshot.data?['userReviews'][index];
                                    DateTime postedOn =
                                        DateFormat('EEE, d MMM yyyy')
                                            .parse(review[4]);
                                    String formattedDate =
                                        DateFormat('d MMM yyyy')
                                            .format(postedOn);
                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Posted on: $formattedDate',
                                              // Replace with your small title
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '${review[1]}',
                                            ),
                                          ],
                                        ),
                                        // subtitle: const Text(
                                        //   'Replace this with comments',
                                        // ),
                                        trailing: Text(
                                          '${review[5]} likes',
                                        ),
                                      );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return const CircularProgressIndicator();
                      },
                    )
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
}

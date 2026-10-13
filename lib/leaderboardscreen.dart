import 'package:cellar_sage/homescreen.dart';
import 'package:cellar_sage/scanscreen.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'login_page.dart';
import 'profilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _Leaderboard(),
        ),
      ),
    );
  }
}

class _Leaderboard extends StatefulWidget {
  const _Leaderboard();

  @override
  State<_Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<_Leaderboard> {
  final String uriLeaderboard =
      'http://83.212.74.53:5000/hci_api/get_leaderboard';

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username').toString();
    return username;
  }

  Future<Map<String, dynamic>> fetchAllData() async {
    String username = await getUsername();
    final response = await http.post(
      Uri.parse(uriLeaderboard),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      // all is well
      var allInfo = jsonDecode(response.body);
      return {
        'leaderList': allInfo['results'],
        'playerRank': allInfo['user_rank'],
        'playerPoints': allInfo['user_points'],
        'username': username,
      };
    }
    return {
      'leaderList': [
        ['Error fetching data', 'NaN']
      ],
      'playerRank': 'NaN',
      'playerPoints': 'NaN',
      'username': username,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const Profile();
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchAllData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              var currentUser = snapshot.data?[
                  'username']; // Replace 'username' with the actual key for the username
              var currentPoints = snapshot.data?[
                  'playerPoints']; // Replace 'sage_points' with the actual key for the points
              var currentRank = snapshot.data?['playerRank'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Sage Leaderboard ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 0.04,
                            letterSpacing: 0.50,
                          ),
                        ),
                        Image.asset(
                          'assets/trophygold.png',
                          width: 50,
                          height: 50,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('How to get sage points'),
                                  content: Text('10 points per review made\n5 points for new wine scan\n'
                                      '1 point for each user that likes your review.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: snapshot.data?['leaderList'].length,
                      itemBuilder: (context, index) {
                        var ratedPlayer = snapshot.data?['leaderList'][index];
                        if (ratedPlayer != null) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: ListTile(
                              title: Text(
                                '${ratedPlayer[2]}) ${ratedPlayer[0]}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${ratedPlayer[1]}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.asset('assets/grape.png',
                                      height: 24, width: 24)
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Text("Something went wrong.");
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                    child: Text(
                      'My Ranking',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 0.04,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ListTile(
                      title: Text('$currentRank) $currentUser'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$currentPoints',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Image.asset('assets/grape.png', height: 24, width: 24)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
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
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

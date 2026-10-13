import 'package:cellar_sage/scanresults.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cellar_sage/login_page.dart';
import 'package:cellar_sage/scanscreen.dart';
import 'package:cellar_sage/profilescreen.dart';
import 'package:cellar_sage/leaderboardscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _HomeScreen(),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username').toString();
    return username;
  }

  final String uri = 'http://83.212.74.53:5000/hci_api/get_scans';

  Future<List<dynamic>> fetchWines() async {
    String username = await getUsername();
    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["results"];
    } else {
      return ['No wines to display'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const ScanScreen();
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
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Your Previous Scans',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 600,
              child: FutureBuilder<List<dynamic>>(
                future: fetchWines(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?[0] == "No wines to display") {
                      return const Center(
                        child: Text(
                          'No recent scans to display',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff1d1b20),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var wine = snapshot.data?[index];
                        DateTime postedOn =
                            DateFormat('EEE, d MMM yyyy').parse(wine[3]);
                        String formattedDate =
                            DateFormat('d MMM yyyy').format(postedOn);
                        return Column(children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/wine.png',
                              ),
                              radius: 30,
                            ),
                            title: Text(
                              'ScanID: ${wine[0]} for ${wine[2]}',
                              // Replace 'id' with the actual key
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff1d1b20),
                              ),
                            ),
                            subtitle: Text(
                              'Discovered on: $formattedDate',
                              // Replace 'lastViewed' with the actual key
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff49454f),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanResults(
                                          scannedText: wine[2],
                                          shouldAddScan: false)));
                            },
                          ),
                          const Divider(),
                        ]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ]),
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
                  onPressed: () {}),
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

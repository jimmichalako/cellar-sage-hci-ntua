import 'package:cellar_sage/scanresults.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'leaderboardscreen.dart';
import 'navbar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:cellar_sage/login_page.dart';
import 'package:cellar_sage/scanscreen.dart';
import 'package:cellar_sage/profilescreen.dart';
import 'package:cellar_sage/homescreen.dart';

class UserReviews extends StatelessWidget {
  final String wineTitle;

  const UserReviews({Key? key, required this.wineTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: _UserReviews(
            wineTitle: wineTitle,
          ),
        ),
      ),
    );
  }
}

class _UserReviews extends StatefulWidget {
  final String wineTitle;

  const _UserReviews({Key? key, required this.wineTitle}) : super(key: key);

  @override
  State<_UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<_UserReviews> {
  late String _reviewResult = 'Tap to see a review :D';
  int selectedTileIndex = -1;

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username').toString();
    return username;
  }

  final String uriReviews =
      'http://83.212.74.53:5000/hci_api/get_reviews_of_wine';
  final String uriLikeReview = 'http://83.212.74.53:5000/hci_api/like_review';
  final String getReviewText = 'http://83.212.74.53:5000/hci_api/getReviewText';

  Future<List<dynamic>> fetchReviews() async {
    String username = await getUsername();
    final response = await http.post(
      Uri.parse(uriReviews),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'wine_name': widget.wineTitle,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["results"];
    } else {
      return ['No reviews to display'];
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked, int reviewId) async {
    String username = await getUsername();
    final response = await http.post(
      Uri.parse(uriLikeReview),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'review_id': reviewId,
        'isLiked': isLiked,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      return !isLiked;
    } else {
      return isLiked;
    }

    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    void updateReviewText(String review) async {
      setState(() {
        _reviewResult = review;
      });
    }

    void updateSelectedTile(int index) {
      setState(() {
        selectedTileIndex = index;
      });
    }

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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 10 * fem, 0 * fem),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'User Reviews',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff1d1b20),
            ),
          ),
          Container(
            width: double.infinity,
            height: 327 * fem,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20* fem),
            //   border: Border.all(color: const Color(0xff6750a4)),
            //   //color: const Color(0xffd9d9d9),
            // ),
            padding: EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 0 * fem),
            child: FutureBuilder<List<dynamic>>(
              future: fetchReviews(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?[0] == "No reviews to display") {
                    return const Center(
                      child: Text(
                        'No reviews yet D:',
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
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var review = snapshot.data?[index];
                      DateTime postedOn =
                          DateFormat('EEE, d MMM yyyy').parse(review[4]);
                      String formattedDate =
                          DateFormat('d MMM yyyy').format(postedOn);
                      return Column(
                        children: [
                          ListTile(
                            leading: SizedBox(
                              width: 60 * fem,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${review[6]} ',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff1d1b20),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/star.png',
                                    width: 30,
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                            title: Text(
                              'Posted on: $formattedDate',
                              // Replace 'id' with the actual key
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1d1b20),
                              ),
                            ),
                            subtitle: Text(
                              'From: ${review[2]}',
                              // Replace 'lastViewed' with the actual key
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff49454f),
                              ),
                            ),
                            trailing: SizedBox(
                              width: 50,
                              // Set a specific width for the trailing widget
                              child: LikeButton(
                                likeBuilder: (bool isLiked) {
                                  return Image.asset(
                                    isLiked
                                        ? 'assets/heart-filled.png'
                                        : 'assets/heart-empty.png',
                                  );
                                },
                                isLiked: review[7] != 0 ? true : false,
                                likeCount: review[5],
                                onTap: (bool isLiked) async {
                                  bool newLikeStatus = await onLikeButtonTapped(
                                      isLiked, review[0]);
                                  return newLikeStatus;
                                },
                              ),
                            ),
                            tileColor: selectedTileIndex == index
                                ? Colors.blue.withOpacity(0.2)
                                : null,
                            onTap: () async {
                              // Call the getReview function on tap
                              // Update the UI with the new result
                              setState(() {
                                updateReviewText(review[1]);
                                updateSelectedTile(index);
                              });
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
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
          SizedBox(height: 20 * fem),
          Container(
            width: double.infinity,
            height: 135 * fem,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(20* fem),
              border: Border.all(color: const Color(0xff000000)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _reviewResult,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff49454f),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScanResults(
                        scannedText: widget.wineTitle,
                        shouldAddScan: false,
                      )));
        },
        label: Text(
          'Wine info',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w500,
            height: 1.4285714286 * ffem / fem,
            letterSpacing: 0.1 * fem,
            color: const Color(0xffffffff),
          ),
        ),
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

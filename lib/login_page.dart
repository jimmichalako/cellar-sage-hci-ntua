import 'package:flutter/material.dart';
import 'registerscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cellar Sage",
      home: Scaffold(
        body: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<void> storeUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  final String uri = 'http://83.212.74.53:5000/hci_api/login';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(17 * fem, 11 * fem, 16 * fem, 11 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // logoZdj (54911:2028)
                margin: EdgeInsets.fromLTRB(
                    101 * fem, 0 * fem, 101 * fem, 86 * fem),
                width: double.infinity,
                height: 125 * fem,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(62.5 * fem),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                ),
              ),
              Container(
                // welcomebacksageGHF (54911:2027)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 122 * fem, 27 * fem),
                child: Text(
                  'Welcome back, Sage!',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: Container(
                  padding:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4 * fem),
                      topRight: Radius.circular(4 * fem),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xffe6e0e9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4 * fem),
                            topRight: Radius.circular(4 * fem),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              16 * fem, 4 * fem, 5 * fem, 4 * fem),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4 * fem),
                              topRight: Radius.circular(4 * fem),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Username',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3333333333 * ffem / fem,
                                      color: const Color(0xff49454f),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  usernameController.clear();
                                },
                                padding: EdgeInsets.zero,
                                icon: Image.asset(
                                  'assets/trailing-icon.png',
                                  width: 48 * fem,
                                  height: 48 * fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1 * fem,
                        decoration: const BoxDecoration(
                          color: Color(0xff49454f),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: Container(
                  padding:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4 * fem),
                      topRight: Radius.circular(4 * fem),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xffe6e0e9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4 * fem),
                            topRight: Radius.circular(4 * fem),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              16 * fem, 4 * fem, 5 * fem, 4 * fem),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4 * fem),
                              topRight: Radius.circular(4 * fem),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  // This will hide the text input for password
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3333333333 * ffem / fem,
                                      color: const Color(0xff49454f),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  passwordController.clear();
                                },
                                padding: EdgeInsets.zero,
                                icon: Image.asset(
                                  'assets/trailing-icon.png',
                                  width: 48 * fem,
                                  height: 48 * fem,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1 * fem,
                        decoration: const BoxDecoration(
                          color: Color(0xff49454f),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 100 * fem, 24 * fem),
                width: 213 * fem,
                height: 16 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 115 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 100 * fem,
                          height: 16 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              ' Register here',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.3333333333 * ffem / fem,
                                color: const Color(0xff6750a4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // donthaveanaccountwVB (54911:2024)
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 150 * fem,
                          height: 16 * fem,
                          child: Text(
                            'Don’t have an account?',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.3333333333 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // loginbuttonDBo (54911:2022)
                margin:
                    EdgeInsets.fromLTRB(63 * fem, 0 * fem, 64 * fem, 0 * fem),
                child: TextButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    try {
                      var response = await http.post(
                        Uri.parse(uri),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          "username": username,
                          "password": password,
                        }),
                      );

                      if (response.statusCode == 200) {
                        // Success
                        storeUsername(username);
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } else {
                        // Replace the print with message
                        if (!context.mounted) {
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Failure !'),
                              content: const Text(
                                  'Wrong username or password, try again.'),
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
                      // Replace the print with message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failure !'),
                            content: Text('Unknown error, ${e.toString()}'),
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
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50 * fem,
                    decoration: BoxDecoration(
                      color: const Color(0xff1d1b20),
                      borderRadius: BorderRadius.circular(100 * fem),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x4c000000),
                          offset: Offset(0 * fem, 1 * fem),
                          blurRadius: 1 * fem,
                        ),
                        BoxShadow(
                          color: const Color(0x26000000),
                          offset: Offset(0 * fem, 1 * fem),
                          blurRadius: 1.5 * fem,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Center(
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.4285714286 * ffem / fem,
                            letterSpacing: 0.1000000015 * fem,
                            color: const Color(0xffd0bcff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

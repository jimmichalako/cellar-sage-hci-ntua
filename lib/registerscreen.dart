import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Cellar Sage',
        home: Scaffold(
          body: Center(
            child: RegisterForm(),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final String uri = 'http://83.212.74.53:5000/hci_api/insert_user';
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
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
        // registerscreenGTs (54911:2009)
        padding: EdgeInsets.fromLTRB(16 * fem, 11 * fem, 17 * fem, 11 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // logowK7 (54911:2020)
                margin: EdgeInsets.fromLTRB(
                    102 * fem, 0 * fem, 100 * fem, 25 * fem),
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
                // welcometothecellarsageqQV (54911:2019)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 52 * fem, 27 * fem),
                child: Text(
                  'Welcome to the Cellar, Sage!',
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
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Name',
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
                                    nameController.clear();
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
                                    controller: surnameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Surname',
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
                                    surnameController.clear();
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email',
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
                                    emailController.clear();
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                                16 * fem, 4 * fem, 0 * fem, 4 * fem),
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
                                    controller: confirmpassController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Confirm password',
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
                                    confirmpassController.clear();
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
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 132 * fem, 24 * fem),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 3 * fem, 0 * fem),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Already have an account?',
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.3333333333 * ffem / fem,
                          color: const Color(0xff6750a4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // registerbuttonZkM (54911:2010)
                margin:
                    EdgeInsets.fromLTRB(65 * fem, 0 * fem, 62 * fem, 0 * fem),
                child: TextButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String surname = surnameController.text;
                    String email = emailController.text;
                    String username = usernameController.text;
                    String password = passwordController.text;
                    String repass = confirmpassController.text;

                    if (password != repass) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failed'),
                            content: const Text('Passwords have to match'),
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
                    } else if (username == "" ||
                        name == "" ||
                        surname == "" ||
                        email == "" ||
                        password == "" ||
                        repass == "") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failed'),
                            content: const Text('Please fill in all fields'),
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
                    } else {
                      try {
                        var response = await http.post(
                          Uri.parse(uri),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({
                            "username": username,
                            "password": password,
                            "firstname": name,
                            "surname": surname,
                            "email": email,
                          }),
                        );

                        if (response.statusCode == 200) {
                          if (!context.mounted) {
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success !'),
                                content: const Text(
                                    'Successfully registered, try logging in.'),
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
                        } else {
                          if (!context.mounted) {
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Failure !'),
                                content: const Text(
                                    'Username or email already in use.'),
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
                    }

                    // Check if the passwords are the same
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.fromLTRB(0 * fem, 5 * fem, 0 * fem, 5 * fem),
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
                          offset: Offset(0 * fem, 2 * fem),
                          blurRadius: 3 * fem,
                        ),
                      ],
                    ),
                    child: Container(
                      // statelayerAEM (I54911:2010;53923:27709)
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0x14d0bcff),
                      ),
                      child: Center(
                        child: Center(
                          child: Text(
                            'Register',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

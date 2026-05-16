import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reviveecotech_rider/services/auth_service.dart';
import 'package:reviveecotech_rider/services/notification_service.dart';

import 'package:reviveecotech_rider/screens/dashboard_screen.dart';

import 'theme_controller.dart';
import 'signup_screen.dart';

import '../localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  String tr(String key) {

    return AppLocalizations.of(
      context,
    ).translate(key);
  }

  bool _isPasswordVisible = false;

  final TextEditingController
      _emailController =
          TextEditingController();

  final TextEditingController
      _passwordController =
          TextEditingController();

  final AuthService _authService =
      AuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable:
          isDarkMode,

      builder:
          (context, value, child) {

        return Scaffold(

          backgroundColor:
              isDarkMode.value
                  ? const Color(
                      0xFF1E1E1E)
                  : const Color(
                      0xFFFCF3E3),

          body: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch,

            children: [

              /// HEADER
              Container(
                height: 260,

                color:
                    const Color(
                        0xFF003856),

                child: Padding(
                  padding:
                      const EdgeInsets
                          .only(
                              top: 32),

                  child: Center(
                    child:
                        Image.asset(
                      'assets/images/revive_logo.jpg',

                      width: 300,
                    ),
                  ),
                ),
              ),

              Expanded(
                child:
                    SingleChildScrollView(
                  child: Column(
                    children: [

                      const SizedBox(
                          height:
                              16),

                      Text(
                        tr('login'),

                        style:
                            TextStyle(
                          fontSize:
                              28,

                          fontWeight:
                              FontWeight
                                  .w800,

                          fontFamily:
                              'RedHatDisplay',

                          color:
                              isDarkMode.value
                                  ? Colors.white
                                  : const Color(
                                      0xFF003856),
                        ),
                      ),

                      const SizedBox(
                          height:
                              10),

                      Column(
                        children: [

                          Container(
                            height:
                                2.5,

                            width:
                                double
                                    .infinity,

                            color:
                                const Color(
                                    0xFF003856),
                          ),

                          Container(
                            height:
                                22,

                            width:
                                double
                                    .infinity,

                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(

                                begin:
                                    Alignment.topCenter,

                                end:
                                    Alignment.bottomCenter,

                                colors: [

                                  Colors.black.withAlpha(
                                      76),

                                  Colors.black.withAlpha(
                                      40),

                                  Colors.black.withAlpha(
                                      20),

                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height:
                              15),

                      Text(
                        tr('login_account'),

                        style:
                            TextStyle(
                          fontSize:
                              22,

                          fontWeight:
                              FontWeight
                                  .bold,

                          color:
                              isDarkMode.value
                                  ? Colors.white
                                  : const Color(
                                      0xFF003856),

                          fontFamily:
                              'RedHatDisplay',
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      /// EMAIL
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40,
                        ),

                        child:
                            Container(
                          decoration:
                              BoxDecoration(

                            color:
                                isDarkMode.value
                                    ? const Color(
                                        0xFF2A2A2A)
                                    : const Color(
                                        0xFFFCF3E3),

                            borderRadius:
                                BorderRadius.circular(
                                    50),

                            boxShadow: [

                              BoxShadow(
                                color:
                                    Colors.black.withAlpha(
                                        76),

                                spreadRadius:
                                    2,

                                blurRadius:
                                    10,

                                offset:
                                    const Offset(
                                        0,
                                        4),
                              ),
                            ],
                          ),

                          child:
                              TextField(
                            controller:
                                _emailController,

                            keyboardType:
                                TextInputType.emailAddress,

                            style:
                                TextStyle(
                              color:
                                  isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                            ),

                            decoration:
                                InputDecoration(

                              contentPadding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    20,
                              ),

                              border:
                                  InputBorder.none,

                              hintText:
                                  tr('email'),

                              hintStyle:
                                  TextStyle(

                                color:
                                    isDarkMode.value
                                        ? Colors.white70
                                        : const Color(
                                            0xFF003856),

                                fontWeight:
                                    FontWeight.w500,
                              ),

                              prefixIcon:
                                  const Padding(
                                padding:
                                    EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),

                                child:
                                    Icon(
                                  Icons
                                      .email_outlined,

                                  color:
                                      Color(
                                          0xFF98C13F),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height:
                              25),

                      /// PASSWORD
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40,
                        ),

                        child:
                            Container(
                          decoration:
                              BoxDecoration(

                            color:
                                isDarkMode.value
                                    ? const Color(
                                        0xFF2A2A2A)
                                    : const Color(
                                        0xFFFCF3E3),

                            borderRadius:
                                BorderRadius.circular(
                                    50),

                            boxShadow: [

                              BoxShadow(
                                color:
                                    Colors.black.withAlpha(
                                        76),

                                spreadRadius:
                                    2,

                                blurRadius:
                                    10,

                                offset:
                                    const Offset(
                                        0,
                                        4),
                              ),
                            ],
                          ),

                          child:
                              TextField(
                            controller:
                                _passwordController,

                            obscureText:
                                !_isPasswordVisible,

                            style:
                                TextStyle(
                              color:
                                  isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                            ),

                            decoration:
                                InputDecoration(

                              contentPadding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    20,
                              ),

                              border:
                                  InputBorder.none,

                              hintText:
                                  tr('password'),

                              hintStyle:
                                  TextStyle(

                                color:
                                    isDarkMode.value
                                        ? Colors.white70
                                        : const Color(
                                            0xFF003856),

                                fontWeight:
                                    FontWeight.w500,
                              ),

                              prefixIcon:
                                  const Padding(
                                padding:
                                    EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),

                                child:
                                    Icon(
                                  Icons
                                      .lock_outline,

                                  color:
                                      Color(
                                          0xFF98C13F),
                                ),
                              ),

                              suffixIcon:
                                  IconButton(
                                onPressed:
                                    () {

                                  setState(
                                      () {

                                    _isPasswordVisible =
                                        !_isPasswordVisible;
                                  });
                                },

                                icon:
                                    Padding(
                                  padding:
                                      const EdgeInsets.only(
                                          right:
                                              20),

                                  child:
                                      Icon(

                                    _isPasswordVisible

                                        ? Icons.visibility

                                        : Icons.visibility_off,

                                    color:
                                        const Color(
                                            0xFF98C13F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height:
                              10),

                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              50,
                        ),

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .end,

                          children: [

                            TextButton(

                              onPressed: () async {

                                if (_emailController.text
                                    .trim()
                                    .isEmpty) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    const SnackBar(

                                      content: Text(
                                        'Enter email first',
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                try {

                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(

                                    email:
                                        _emailController.text
                                            .trim(),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    const SnackBar(

                                      content: Text(
                                        'Password reset email sent',
                                      ),
                                    ),
                                  );

                                } catch (e) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    SnackBar(
                                      content: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  );
                                }
                              },

                              child:
                                  Text(
                                tr('forget_password'),

                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                          0xFF003856),

                                  fontWeight:
                                      FontWeight.bold,

                                  fontFamily:
                                      'RedHatDisplay',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      /// LOGIN BUTTON
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40.0,
                        ),

                        child:
                            SizedBox(
                          width:
                              double
                                  .infinity,

                          child:
                              ElevatedButton(

                            onPressed:
                                () async {

                              if (_emailController.text
                                  .trim()
                                  .isEmpty ||

                                  _passwordController.text
                                      .trim()
                                      .isEmpty) {

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  const SnackBar(

                                    content: Text(
                                      'Please enter email and password',
                                    ),
                                  ),
                                );

                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              try {

                                final credential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(

                                  email:
                                      _emailController.text.trim(),

                                  password:
                                      _passwordController.text.trim(),
                                );

                                final token =
                                    await NotificationService
                                        .getToken();

                                if (token != null) {

                                  await FirebaseFirestore.instance
                                      .collection('agents')
                                      .doc(credential.user!.uid)
                                      .set({

                                    'fcmToken': token,

                                  }, SetOptions(
                                    merge: true,
                                  ));
                                }

                                if (!mounted) return;

                                Navigator.pushReplacement(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        const DashboardScreen(),
                                  ),
                                );

                              } on FirebaseAuthException catch (e) {

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  SnackBar(
                                    content: Text(
                                      e.message ??
                                          'Login Failed',
                                    ),
                                  ),
                                );

                              } finally {

                                if (mounted) {

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },

                            style:
                                ElevatedButton.styleFrom(

                              backgroundColor:
                                  const Color(
                                      0xFF98C13F),

                              padding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    16,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        50.0),
                              ),

                              elevation:
                                  8,
                            ),

                            child: _isLoading

                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.white)

                                : Text(
                                    tr('login'),

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          24,

                                      fontWeight:
                                          FontWeight.bold,

                                      color:
                                          Colors.white,

                                      fontFamily:
                                          'RedHatDisplay',
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      /// SOCIAL LOGIN BUTTONS
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 40.0,
                        ),

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            /// GOOGLE
                            Expanded(
                              child:
                                  ElevatedButton.icon(

                                onPressed: () async {

                                  final user =
                                      await _authService
                                          .signInWithGoogle();

                                  if (user != null) {

                                    if (!mounted) return;

                                    Navigator.pushReplacement(

                                      context,

                                      MaterialPageRoute(

                                        builder: (_) =>
                                            const DashboardScreen(),
                                      ),
                                    );
                                  }
                                },

                                icon:
                                    const FaIcon(
                                  FontAwesomeIcons.google,

                                  color:
                                      Colors.red,
                                ),

                                label:
                                    Text(
                                  tr('google'),

                                  style:
                                      TextStyle(

                                    color:
                                        isDarkMode.value
                                            ? Colors.white
                                            : Colors.black,

                                    fontFamily:
                                        'RedHatDisplay',
                                  ),
                                ),

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      isDarkMode.value
                                          ? const Color(
                                              0xFF2A2A2A)
                                          : Colors.white,

                                  minimumSize:
                                      const Size(
                                    double.infinity,
                                    50,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),

                                    side:
                                        const BorderSide(
                                      color:
                                          Color(
                                              0xFF000000),
                                    ),
                                  ),

                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Text(
                            tr('dont_have_account'),

                            style: TextStyle(
                              color:
                                  isDarkMode.value
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),

                          TextButton(
                            onPressed: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) =>
                                       const SignUpScreen(),
                                ),
                              );
                            },

                            child: Text(
                              tr('sign_up'),

                              style: const TextStyle(
                                color: Color(0xFF98C13F),

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
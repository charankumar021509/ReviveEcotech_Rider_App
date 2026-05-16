import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reviveecotech_rider/screens/login_screen.dart';
import 'package:reviveecotech_rider/screens/dashboard_screen.dart';
import 'package:reviveecotech_rider/services/auth_service.dart';
import 'package:reviveecotech_rider/screens/verify_email_screen.dart';
import 'theme_controller.dart';
import '../localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {

  String tr(String key) {

    return AppLocalizations.of(
      context,
    ).translate(key);
  }

  bool _isPasswordVisible = false;

  final AuthService _authService =
      AuthService();

  bool _isLoading = false;

  final TextEditingController
      _nameController =
          TextEditingController();

  final TextEditingController
      _emailController =
          TextEditingController();

  final TextEditingController
      _passwordController =
          TextEditingController();

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

                      /// TITLE
                      Text(
                        tr('sign_up'),

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

                      /// Divider + shadow
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
                        tr('future_text'),

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

                      /// FULL NAME
                      _inputField(
                        controller:
                            _nameController,

                        hint:
                            tr('full_name'),

                        icon: Icons
                            .person_outline,
                      ),

                      const SizedBox(
                          height:
                              25),

                      /// EMAIL
                      _inputField(
                        controller:
                            _emailController,

                        hint:
                            tr('email'),

                        icon: Icons
                            .email_outlined,
                      ),

                      const SizedBox(
                          height:
                              25),

                      /// PASSWORD
                      _passwordField(
                        controller:
                            _passwordController,

                        hint:
                            tr('password'),

                        isVisible:
                            _isPasswordVisible,

                        toggle: () {

                          setState(() {

                            _isPasswordVisible =
                                !_isPasswordVisible;
                          });
                        },
                      ),

                      const SizedBox(
                          height:
                              30),

                      /// SIGNUP BUTTON
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40,
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

                              setState(
                                  () =>
                                      _isLoading =
                                          true);

                              try {

                                final user =
                                    await _authService.signUp(

                                  email:
                                      _emailController.text.trim(),

                                  password:
                                      _passwordController.text.trim(),

                                  name:
                                      _nameController.text.trim(),
                                );

                                if (user != null) {

                                  await FirebaseFirestore.instance
                                      .collection('agents')
                                      .doc(user.uid)
                                      .set({

                                    'name':
                                        _nameController.text.trim(),

                                    'email':
                                        _emailController.text.trim(),

                                    'uid':
                                        user.uid,


                                  });
                                }

                                if (user !=
                                    null) {

                                  if (!mounted)
                                    return;

                                  Navigator.pushReplacement(

                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const VerifyEmailScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {

                                if (!mounted)
                                  return;

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(

                                  SnackBar(
                                    content:
                                        Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }

                              if (mounted) {

                                setState(
                                    () =>
                                        _isLoading =
                                            false);
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
                                        50),
                              ),

                              elevation:
                                  8,
                            ),

                            child: _isLoading

                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.white)

                                : Text(
                                    tr('sign_up'),

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

                      /// BACK TO LOGIN
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          Text(
                            tr('already_account'),

                            style:
                                TextStyle(

                              color:
                                  isDarkMode.value
                                      ? Colors.white70
                                      : Colors.black,

                              fontFamily:
                                  'RedHatDisplay',
                            ),
                          ),

                          GestureDetector(
                            onTap: () =>
                                Navigator.pushReplacement(

                              context,

                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const LoginScreen(),
                              ),
                            ),

                            child: Text(
                              tr('login'),

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,

                                color: Color(
                                    0xFF003856),

                                fontFamily:
                                    'RedHatDisplay',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height:
                              10),

                      /// OR CONNECT WITH
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40.0,
                        ),

                        child: Row(
                          children: [

                            const Expanded(
                              child:
                                  Divider(
                                color: Color(
                                    0xFF003856),

                                thickness:
                                    1,
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal:
                                          10.0),

                              child: Text(
                                tr('or_connect'),

                                style:
                                    TextStyle(
                                  color:
                                      isDarkMode.value
                                          ? Colors.white
                                          : const Color(
                                              0xFF003856),

                                  fontWeight:
                                      FontWeight.bold,

                                  fontFamily:
                                      'RedHatDisplay',
                                ),
                              ),
                            ),

                            const Expanded(
                              child:
                                  Divider(
                                color: Color(
                                    0xFF003856),

                                thickness:
                                    1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      /// SOCIAL LOGIN BUTTONS
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              40.0,
                        ),

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            /// GOOGLE BUTTON
                            Expanded(
                              child:
                                  ElevatedButton.icon(

                                onPressed: () async {

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {

                                    final userCredential =
                                        await _authService
                                            .signInWithGoogle();

                                    if (userCredential != null) {

                                      if (!mounted) return;

                                      Navigator.pushReplacement(

                                        context,

                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardScreen(),
                                        ),
                                      );
                                    }

                                  } catch (e) {

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(

                                      SnackBar(
                                        content: Text(
                                          e.toString(),
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

                                icon: const FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.red,
                                ),

                                label: Text(
                                  tr('google'),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width:
                                    20),

                            /// APPLE BUTTON
                            Expanded(
                              child:
                                  ElevatedButton.icon(
                                onPressed:
                                    () {},

                                icon:
                                    const FaIcon(
                                  FontAwesomeIcons.apple,
                                  color:
                                      Colors.black,
                                ),

                                label:
                                    Text(
                                  tr('apple'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),
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

  Widget _inputField({
    required TextEditingController
        controller,

    required String hint,

    required IconData icon,
  }) {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 40),

      child: Container(
        decoration:
            _boxDecoration(),

        child: TextField(
          controller:
              controller,

          style: TextStyle(
            color:
                isDarkMode.value
                    ? Colors.white
                    : Colors.black,
          ),

          decoration:
              _inputDecoration(
            hint,
            icon,
          ),

          textInputAction:
              TextInputAction.next,
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController
        controller,

    required String hint,

    required bool isVisible,

    required VoidCallback toggle,
  }) {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 40),

      child: Container(
        decoration:
            _boxDecoration(),

        child: TextField(
          controller:
              controller,

          obscureText:
              !isVisible,

          style: TextStyle(
            color:
                isDarkMode.value
                    ? Colors.white
                    : Colors.black,
          ),

          decoration:
              _inputDecoration(

            hint,

            Icons.lock_outline,

            suffix: IconButton(
              onPressed:
                  toggle,

              icon: Icon(

                isVisible
                    ? Icons.visibility
                    : Icons.visibility_off,

                color:
                    const Color(
                        0xFF98C13F),
              ),
            ),
          ),

          textInputAction:
              TextInputAction.done,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() =>
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
                Colors.black
                    .withAlpha(76),

            spreadRadius: 2,

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      );

  InputDecoration
      _inputDecoration(
    String hint,
    IconData icon, {

    Widget? suffix,
  }) =>

      InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(
                vertical: 20),

        border:
            InputBorder.none,

        hintText: hint,

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

        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(
            left: 20,
            right: 10,
          ),

          child: Icon(
            icon,

            color:
                const Color(
                    0xFF98C13F),
          ),
        ),

        suffixIcon:
            suffix == null
                ? null
                : Padding(
                    padding:
                        const EdgeInsets.only(
                            right: 20),

                    child: suffix,
                  ),
      );

  @override
  void dispose() {

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
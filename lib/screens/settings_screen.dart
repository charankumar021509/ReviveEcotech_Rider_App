import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'order_history_screen.dart';
import 'profile_settings_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFCF3E3),

      body: Column(
        children: [

          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),

              child: Column(
                children: [

                  /// ABOUT US
                  _buildSettingsItem(
                    icon:
                        Icons.group_outlined,

                    title: 'About us',

                    onTap: () {

                      showDialog(
                        context: context,

                        builder: (context) =>
                            AlertDialog(
                          title: const Text(
                              'About Us'),

                          content:
                              const Text(
                            'Revive EcoTech helps manage eco-friendly deliveries and recycling services.',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                      'OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// HELP & SUPPORT
                  _buildSettingsItem(
                    icon: Icons
                        .headset_mic_outlined,

                    title:
                        'Help & Support',

                    onTap: () {

                      showDialog(
                        context: context,

                        builder: (context) =>
                            AlertDialog(
                          title: const Text(
                              'Help & Support'),

                          content:
                              const Text(
                            'Contact support@revive.com for assistance.',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                      'OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// PRIVACY POLICY
                  _buildSettingsItem(
                    icon: Icons
                        .privacy_tip_outlined,

                    title:
                        'Privacy Policy',

                    onTap: () {

                      showDialog(
                        context: context,

                        builder: (context) =>
                            AlertDialog(
                          title: const Text(
                              'Privacy Policy'),

                          content:
                              const Text(
                            'Your information is securely protected.',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                      'OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// TERMS
                  _buildSettingsItem(
                    icon: Icons
                        .description_outlined,

                    title:
                        'Terms & Conditions',

                    onTap: () {

                      showDialog(
                        context: context,

                        builder: (context) =>
                            AlertDialog(
                          title: const Text(
                              'Terms & Conditions'),

                          content:
                              const Text(
                            'Use the app responsibly and follow company rules.',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                      'OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// FAQS
                  _buildSettingsItem(
                    icon: Icons
                        .question_answer_outlined,

                    title: 'FAQs',

                    onTap: () {

                      showDialog(
                        context: context,

                        builder: (context) =>
                            AlertDialog(
                          title:
                              const Text(
                                  'FAQs'),

                          content:
                              const Text(
                            'Frequently asked questions will appear here.',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                      'OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// APP VERSION
                  _buildSettingsItem(
                    icon: Icons
                        .file_copy_outlined,

                    title:
                        'App Version',

                    showArrow: false,

                    trailing: const Text(
                      '1.0.0',

                      style: TextStyle(
                        color: Color(
                            0xFF98C13F),

                        fontWeight:
                            FontWeight
                                .bold,

                        fontSize: 16,

                        fontFamily:
                            'RedHatDisplay',
                      ),
                    ),

                    onTap: () {},
                  ),

                  /// ORDER HISTORY
                  _buildSettingsItem(
                    icon: Icons.history,

                    title: 'Order History',

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  /// DASHBOARD
                  _buildSettingsItem(
                    icon: Icons.dashboard,

                    title: 'Dashboard',

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const DashboardScreen(),
                        ),
                      );
                    },
                  ),

                  /// PROFILE
                  _buildSettingsItem(
                    icon: Icons.person,

                    title: 'Profile',

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const ProfileSettingsScreen(),
                        ),
                      );
                    },
                  ),

                  /// LOGOUT
                  _buildSettingsItem(
                    icon: Icons.logout,

                    title: 'Log Out',

                    iconColor:
                        Colors.red,

                    showArrow: false,

                    onTap: () {

                      Navigator
                          .pushReplacement(
                        context,

                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const LoginScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(
      BuildContext context) {

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: const Color(0xFF003856),

        borderRadius:
            const BorderRadius.only(
          bottomLeft:
              Radius.circular(50),
          bottomRight:
              Radius.circular(50),
        ),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withAlpha(
                    80),

            blurRadius: 20,
            spreadRadius: 2,

            offset:
                const Offset(0, 10),
          ),
        ],
      ),

      padding:
          const EdgeInsets.fromLTRB(
              20, 60, 20, 40),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),

            onPressed: () =>
                Navigator.pop(
                    context),
          ),

          const Text(
            'Settings',

            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  'RedHatDisplay',
            ),
          ),

          GestureDetector(
            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileSettingsScreen(),
                ),
              );
            },

            child:
                const CircleAvatar(
              radius: 25,
              backgroundColor:
                  Color(0xFFFCF3E3),

              child: Icon(
                Icons.person,
                size: 30,
                color:
                    Color(0xFF003856),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SETTINGS ITEM =================
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,

    Color iconColor =
        const Color(0xFF003856),

    bool showArrow = true,

    Widget? trailing,

    required VoidCallback onTap,
  }) {

    return Container(
      margin:
          const EdgeInsets.only(
              bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                20),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withAlpha(
                    60),

            blurRadius: 15,
            spreadRadius: 2,

            offset:
                const Offset(0, 6),
          ),
        ],
      ),

      child: ListTile(
        onTap: onTap,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),

        leading: Icon(
          icon,
          color: iconColor,
          size: 32,
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFF003856),

            fontFamily:
                'RedHatDisplay',
          ),
        ),

        trailing: trailing ??
            (showArrow
                ? const Icon(
                    Icons
                        .chevron_right,

                    color: Color(
                        0xFF98C13F),

                    size: 30,
                  )
                : null),
      ),
    );
  }
}
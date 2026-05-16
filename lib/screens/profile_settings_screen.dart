import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'order_history_screen.dart';
import 'theme_controller.dart';
import '../localization/language_controller.dart';
import '../localization/app_localizations.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {

  String tr(String key) {

    return AppLocalizations.of(
      context,
    ).translate(key);
  }

  File? _profileImage;

  String _name = "";
  String _email = "";

  @override
  void initState() {

    super.initState();

    _loadProfileData();
  }

  Future<void> _loadProfileData() async {

    try {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {

        final doc =
            await FirebaseFirestore.instance
                .collection('agents')
                .doc(user.uid)
                .get();

        if (doc.exists) {

          setState(() {

            _name =
                doc['name'] ?? '';

            _email =
                doc['email'] ?? '';
          });
        }
      }
    } catch (e) {

      debugPrint(
        "Profile Load Error: $e",
      );
    }
  }

  Future<void> _updateProfile() async {

    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            EditProfileScreen(),
      ),
    );

    if (result != null && result is Map) {

      setState(() {

        if (result['image'] != null) {
          _profileImage = File(result['image']);
        }

        _name =
            result['lname'] != null &&
                    result['lname']
                        .toString()
                        .isNotEmpty
                ? "${result['fname']} ${result['lname']}"
                : result['fname'];

        _email = result['email'];
      });
    }

    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: isDarkMode.value
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFFCF3E3),

      body: Column(
        children: [

          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.only(bottom: 30),

              child: Column(
                children: [

                  /// GENERAL SETTINGS
                  _buildSectionCard(
                    title: tr('general_settings'),

                    children: [

                      _buildSettingsItem(
                        icon: Icons.dark_mode,
                        title: tr('mode'),

                        subtitle: isDarkMode.value
                            ? tr('dark_mode')
                            : tr('light_mode'),

                        trailing: Switch(

                          value: isDarkMode.value,

                          onChanged: (value) {

                            setState(() {

                              isDarkMode.value = value;
                            });
                          },

                          activeThumbColor:
                              const Color(0xFF0056D2),

                          activeTrackColor:
                              const Color(0xFF80ABEB),
                        ),
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.vpn_key,
                        title: tr('change_password'),

                        onTap: () {
                          _showChangePasswordDialog();
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.translate,
                        title: tr('language'),
                        subtitle: 'English',

                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.edit,
                        title: tr('edit_profile'),

                        onTap: _updateProfile,
                      ),
                    ],
                  ),

                  /// PROFILE OPTIONS
                  _buildSectionCard(
                    title: tr('profile_options'),

                    children: [

                      _buildSettingsItem(
                        icon: Icons.history,
                        title: tr('history'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const OrderHistoryScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.settings,
                        title: tr('settings'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.logout,
                        title: tr('logout'),

                        onTap: () async {

                          try {

                            await FirebaseAuth.instance.signOut();

                            if (!mounted) return;

                            Navigator.of(context).pushAndRemoveUntil(

                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen(),
                              ),

                              (route) => false,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {

    return Container(

      width: double.infinity,

      decoration: const BoxDecoration(

        color: Color(0xFF003856),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),

      padding: const EdgeInsets.fromLTRB(
        20,
        60,
        20,
        40,
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),

                onPressed: () =>
                    Navigator.pop(context),
              ),

              Text(
                tr('profile'),

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 20),

          CircleAvatar(
            radius: 60,

            backgroundColor:
                const Color(0xFFFCF3E3),

            backgroundImage:
                _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,

            child: _profileImage == null

                ? const Icon(
                    Icons.person,
                    size: 70,
                    color: Color(0xFF003856),
                  )

                : null,
          ),

          const SizedBox(height: 15),

          Text(
            _name,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _email,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {

    return Padding(

      padding: const EdgeInsets.all(12),

      child: Card(

        color: isDarkMode.value
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFEEDCC6),

        child: Column(
          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(15),

              child: Text(
                title,

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                  color: isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),

            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {

    return ListTile(

      onTap: onTap,

      leading: Icon(
        icon,

        color: isDarkMode.value
            ? Colors.white
            : Colors.black,
      ),

      title: Text(
        title,

        style: TextStyle(
          color: isDarkMode.value
              ? Colors.white
              : Colors.black,
        ),
      ),

      subtitle: subtitle != null

          ? Text(
              subtitle,

              style: TextStyle(
                color: isDarkMode.value
                    ? Colors.white70
                    : Colors.black54,
              ),
            )

          : null,

      trailing: trailing,
    );
  }

  Widget _buildDivider() {

    return Divider(

      color: isDarkMode.value
          ? Colors.white24
          : Colors.black12,
    );
  }

  void _showChangePasswordDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title:
              Text(tr('change_password')),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: const [

              TextField(
                decoration: InputDecoration(
                  labelText: 'Old Password',
                ),
              ),

              SizedBox(height: 10),

              TextField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.pop(context),

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title:
              Text(tr('select_language')),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              ListTile(
                title:
                    const Text('English'),

                onTap: () {

                  appLocale.value =
                      const Locale('en');

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title:
                    const Text('Hindi'),

                onTap: () {

                  appLocale.value =
                      const Locale('hi');

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title:
                    const Text('Telugu'),

                onTap: () {

                  appLocale.value =
                      const Locale('te');

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
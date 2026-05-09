import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'order_history_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {

  bool _isDarkMode = false;

  dynamic _profileImage;

  String _name = "big Bhai";
  String _email = "helloBhai@gmail.com";

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

        _profileImage = result['image'];

        _name =
            "${result['fname']} ${result['lname']}";

        _email = result['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: _isDarkMode
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

                  // GENERAL SETTINGS
                  _buildSectionCard(
                    title: 'General Settings',

                    children: [

                      _buildSettingsItem(
                        icon: Icons.settings,
                        title: 'Mode',

                        subtitle: _isDarkMode
                            ? 'Dark Mode'
                            : 'Light Mode',

                        trailing: Switch(

                          value: _isDarkMode,

                          onChanged: (value) {

                            setState(() {
                              _isDarkMode = value;
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
                        title: 'Change Password',

                        onTap: () {
                          _showChangePasswordDialog();
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.translate,
                        title: 'Language',
                        subtitle: 'English',

                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.edit,
                        title: 'Edit Profile',

                        onTap: _updateProfile,
                      ),
                    ],
                  ),

                  // PROFILE OPTIONS
                  _buildSectionCard(
                    title: 'Profile Options',

                    children: [

                      // ORDER HISTORY
                      _buildSettingsItem(
                        icon: Icons.history,
                        title: 'Order History',

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

                      // SETTINGS
                      _buildSettingsItem(
                        icon: Icons.settings,
                        title: 'Settings',

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

                      // LOGOUT
                      _buildSettingsItem(
                        icon: Icons.logout,
                        title: 'Logout',

                        onTap: () {

                          showDialog(
                            context: context,

                            builder: (context) {

                              return AlertDialog(

                                title: const Text(
                                  'Logout',
                                ),

                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),

                                actions: [

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },

                                    child: const Text(
                                      'Cancel',
                                    ),
                                  ),

                                  ElevatedButton(
                                    onPressed: () {

                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(

                                        const SnackBar(
                                          content: Text(
                                            'Logged Out Successfully',
                                          ),
                                        ),
                                      );
                                    },

                                    child: const Text(
                                      'Logout',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  // INFORMATION
                  _buildSectionCard(
                    title: 'Information',

                    children: [

                      _buildSettingsItem(
                        icon: Icons.smartphone,
                        title: 'About App',

                        onTap: () {

                          _showInfoDialog(
                            'About App',

                            'This app helps users manage deliveries and activities.',
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.description,
                        title: 'Terms & Conditions',

                        onTap: () {

                          _showInfoDialog(
                            'Terms & Conditions',

                            'You must follow all terms and conditions while using the app.',
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.security,
                        title: 'Privacy Policy',

                        onTap: () {

                          _showInfoDialog(
                            'Privacy Policy',

                            'Your personal data is secure and protected.',
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildSettingsItem(
                        icon: Icons.share,
                        title: 'Share This App',

                        onTap: () {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(
                              content:
                                  Text('Sharing App...'),
                            ),
                          );
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

  // HEADER
  Widget _buildHeader(BuildContext context) {

    return Container(

      width: double.infinity,

      decoration: BoxDecoration(

        color: const Color(0xFF003856),

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
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
                  size: 30,
                ),

                onPressed: () =>
                    Navigator.pop(context),
              ),

              const Text(
                'Profile',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RedHatDisplay',
                ),
              ),

              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 20),

          Stack(
            alignment: Alignment.bottomRight,

            children: [

              GestureDetector(
                onTap: _updateProfile,

                child: Container(

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),

                  child: CircleAvatar(
                    radius: 65,

                    backgroundColor:
                        const Color(0xFFFCF3E3),

                    child: _profileImage == null

                        ? const Icon(
                            Icons.person,
                            size: 75,
                            color:
                                Color(0xFF003856),
                          )

                        : const Icon(
                            Icons.check_circle,
                            size: 75,
                            color: Colors.green,
                          ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8),

                decoration: const BoxDecoration(
                  color: Color(0xFF007BFF),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            _name,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'RedHatDisplay',
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _email,

            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 18,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  // SECTION CARD
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {

    return Padding(

      padding: const EdgeInsets.fromLTRB(
        10,
        20,
        10,
        0,
      ),

      child: Card(

        color: _isDarkMode
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFEEDCC6),

        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10),
        ),

        child: Column(
          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),

              decoration: BoxDecoration(
                color: _isDarkMode
                    ? Colors.black54
                    : const Color(0xFFD6C1A7),
              ),

              child: Text(
                title,

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,

                  color: _isDarkMode
                      ? Colors.white
                      : const Color(0xFF333333),

                  fontFamily: 'RedHatDisplay',
                ),
              ),
            ),

            ...children,
          ],
        ),
      ),
    );
  }

  // SETTINGS ITEM
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {

    return ListTile(

      onTap: onTap,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),

      leading: Icon(
        icon,

        color: _isDarkMode
            ? Colors.white
            : Colors.black87,

        size: 26,
      ),

      title: Text(
        title,

        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,

          color: _isDarkMode
              ? Colors.white
              : Colors.black87,

          fontFamily: 'RedHatDisplay',
        ),
      ),

      subtitle: subtitle != null

          ? Text(
              subtitle,

              style: TextStyle(
                fontSize: 16,

                color: _isDarkMode
                    ? Colors.white70
                    : Colors.black87,

                fontFamily: 'RedHatDisplay',
              ),
            )

          : null,

      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 18,

            color: _isDarkMode
                ? Colors.white70
                : Colors.black54,
          ),
    );
  }

  // DIVIDER
  Widget _buildDivider() {

    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,

      color: _isDarkMode
          ? Colors.white24
          : const Color(0xFFDCCDBB),
    );
  }

  // CHANGE PASSWORD
  void _showChangePasswordDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Change Password',
          ),

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

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      'Password Changed Successfully',
                    ),
                  ),
                );
              },

              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // LANGUAGE
  void _showLanguageDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Select Language',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              ListTile(
                title: const Text('English'),
                onTap: () =>
                    Navigator.pop(context),
              ),

              ListTile(
                title: const Text('Hindi'),
                onTap: () =>
                    Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // INFO DIALOG
  void _showInfoDialog(
    String title,
    String message,
  ) {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(title),

          content: Text(message),

          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.pop(context),

              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
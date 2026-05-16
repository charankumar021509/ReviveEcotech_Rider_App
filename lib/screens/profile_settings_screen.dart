import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dashboard_screen.dart';
import 'order_history_screen.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'theme_controller.dart';
import '../localization/app_localizations.dart';
import '../localization/language_controller.dart';
import '../widgets/custom_bottom_navbar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String _name = 'Agent';
  String _email = '';
  String _phone = '';
  String? _profileImageUrl;
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('agents').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _name = doc.data()?['name'] ?? 'Agent';
            _email = doc.data()?['email'] ?? user.email ?? '';
            _phone = doc.data()?['phone'] ?? '';
            _profileImageUrl = doc.data()?['profileImageUrl'];
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  String tr(String key) {
    return AppLocalizations.of(context).translate(key);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final bool isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFEDF4F0),
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.dark_mode_outlined,
                          title: tr('mode'),
                          subtitle: isDark ? tr('dark_mode') : tr('light_mode'),
                          isDark: isDark,
                          trailing: Switch(
                            value: isDark,
                            onChanged: (val) => isDarkMode.value = val,
                            activeColor: const Color(0xFF10B981),
                          ),
                          onTap: () => isDarkMode.value = !isDarkMode.value,
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.lock_outline_rounded,
                          title: tr('change_password'),
                          isDark: isDark,
                          onTap: () => _showChangePasswordDialog(isDark),
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.language_rounded,
                          title: tr('language'),
                          subtitle: _getLanguageName(appLocale.value.languageCode),
                          isDark: isDark,
                          onTap: () => _showLanguageDialog(isDark),
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.edit_outlined,
                          title: tr('edit_profile'),
                          isDark: isDark,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfileScreen()),
                            );
                            if (result != null) {
                              _loadProfileData();
                            }
                          },
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.white10),
                        ),

                        _buildSettingsItem(
                          icon: Icons.history_rounded,
                          title: tr('history'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
                          },
                        ),

                        _buildSettingsItem(
                          icon: Icons.settings_outlined,
                          title: tr('settings'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                          },
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.white10),
                        ),

                        _buildSettingsItem(
                          icon: Icons.logout_rounded,
                          title: tr('logout'),
                          isDark: isDark,
                          iconColor: Colors.redAccent,
                          showArrow: false,
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              if (!mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                (route) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    if (code == 'hi') return 'Hindi';
    if (code == 'te') return 'Telugu';
    return 'English';
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    const navy = Color(0xFF0B132B);
    const green = Color(0xFF10B981);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? navy : const Color(0xFF003856),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : const Color(0xFF003856).withAlpha(40),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                tr('profile'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'RedHatDisplay',
                ),
              ),
              const SizedBox(width: 48), 
            ],
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: green.withAlpha(150), width: 2),
              boxShadow: [
                BoxShadow(
                  color: green.withAlpha(60),
                  blurRadius: 20,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 54,
              backgroundColor: isDark ? const Color(0xFF162032) : Colors.white24,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null),
              child: (_profileImage == null && _profileImageUrl == null) ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            _name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _email,
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 14,
              fontFamily: 'RedHatDisplay',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isDark,
    Widget? trailing,
    Color? iconColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    final effectiveIconColor = iconColor ?? const Color(0xFF10B981);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: effectiveIconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: effectiveIconColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0B132B),
            fontWeight: FontWeight.bold,
            fontFamily: 'RedHatDisplay',
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null ? Text(
          subtitle,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 13,
            fontFamily: 'RedHatDisplay',
          ),
        ) : null,
        trailing: trailing ?? (showArrow ? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white24 : Colors.black26) : null),
      ),
    );
  }

  void _showChangePasswordDialog(bool isDark) {
    final TextEditingController passwordController = TextEditingController();
    const green = Color(0xFF10B981);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF162032) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(tr('change_password'), style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'New Password',
            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              if (passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password too short")));
                return;
              }
              try {
                await _auth.currentUser?.updatePassword(passwordController.text);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password updated successfully")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF162032) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr('language'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 20),
            _buildLangTile('en', 'English (United Kingdom)', isDark),
            _buildLangTile('hi', 'हिन्दी (Hindi)', isDark),
            _buildLangTile('te', 'తెలుగు (Telugu)', isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLangTile(String code, String name, bool isDark) {
    bool isSelected = appLocale.value.languageCode == code;
    return ListTile(
      leading: Icon(Icons.language_rounded, color: isSelected ? const Color(0xFF10B981) : (isDark ? Colors.white38 : Colors.black38)),
      title: Text(name, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)) : null,
      onTap: () {
        appLocale.value = Locale(code);
        Navigator.pop(context);
      },
    );
  }
}
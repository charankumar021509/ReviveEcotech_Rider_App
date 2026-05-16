import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'order_history_screen.dart';
import 'profile_settings_screen.dart';
import 'login_screen.dart';
import 'theme_controller.dart';
import '../localization/app_localizations.dart';
import '../widgets/custom_bottom_navbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String tr(String key) {
    return AppLocalizations.of(context).translate(key);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final bool isDark = value;
        final bgColor = isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC);
        
        return Scaffold(
          backgroundColor: bgColor,
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark),
              
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.group_outlined,
                          title: tr('about_us'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
                          },
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.headset_mic_outlined,
                          title: tr('help_support'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
                          },
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: tr('privacy_policy'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
                          },
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.description_outlined,
                          title: tr('terms_conditions'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
                          },
                        ),
                        
                        _buildSettingsItem(
                          icon: Icons.question_answer_outlined,
                          title: tr('faqs'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                          },
                        ),
                        
                        const SizedBox(height: 10),
                        Divider(color: isDark ? Colors.white12 : Colors.black12),
                        const SizedBox(height: 10),

                        _buildSettingsItem(
                          icon: Icons.history,
                          title: tr('history'),
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
                          },
                        ),

                        _buildSettingsItem(
                          icon: Icons.logout_rounded,
                          title: tr('logout'),
                          isDark: isDark,
                          iconColor: Colors.redAccent,
                          showArrow: false,
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // App Version
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF10B981).withAlpha(100)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.new_releases_outlined, size: 16, color: Color(0xFF10B981)),
                                SizedBox(width: 8),
                                Text(
                                  "App Version 1.0.0",
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RedHatDisplay',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B132B) : const Color(0xFF003856),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            tr('settings'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'RedHatDisplay',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF10B981).withAlpha(100), width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: isDark ? const Color(0xFF162032) : const Color(0xFFFCF3E3),
                child: Icon(Icons.person, size: 28, color: isDark ? Colors.white : const Color(0xFF003856)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required bool isDark,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withAlpha(isDark ? 30 : 20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: effectiveIconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF003856),
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white30 : Colors.black26,
                    size: 26,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= COMMON UI HELPERS FOR SUB-SCREENS =================
Widget _topHeader(BuildContext context, String title, bool isDark) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0B132B) : const Color(0xFF003856),
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
    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ),
        ),
        const SizedBox(width: 44), // To balance the back button
      ],
    ),
  );
}

Widget _infoCard({required String title, required String content, required bool isDark}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF162032) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: isDark ? Colors.white12 : Colors.transparent),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF003856),
            fontFamily: 'RedHatDisplay',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDark ? Colors.white70 : Colors.black87,
            fontFamily: 'RedHatDisplay',
          ),
        ),
      ],
    ),
  );
}

Widget _darkCard(bool isDark) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0B132B) : const Color(0xFF003856),
      borderRadius: BorderRadius.circular(24),
      border: isDark ? Border.all(color: Colors.white12) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Why Choose Us?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'RedHatDisplay',
          ),
        ),
        const SizedBox(height: 20),
        _featureItem(Icons.shield_outlined, "Trusted & Reliable", "Verified agents at your doorstep."),
        const SizedBox(height: 16),
        _featureItem(Icons.flash_on_rounded, "Fast Service", "Quick pickup within scheduled slots."),
      ],
    ),
  );
}

Widget _featureItem(IconData icon, String title, String subtitle) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withAlpha(40),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF10B981), size: 20),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'RedHatDisplay'),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'RedHatDisplay'),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _supportTile(IconData icon, String title, String subtitle, bool isDark) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF162032) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDark ? Colors.white12 : Colors.transparent),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withAlpha(isDark ? 30 : 20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF10B981)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF003856),
          fontFamily: 'RedHatDisplay',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white60 : Colors.grey.shade600,
          fontFamily: 'RedHatDisplay',
        ),
      ),
    ),
  );
}

Widget _faqTile(String question, String answer, bool isDark) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF162032) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: isDark ? Colors.white12 : Colors.transparent),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: const Color(0xFF10B981),
        collapsedIconColor: isDark ? Colors.white54 : Colors.black54,
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF003856),
            fontFamily: 'RedHatDisplay',
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                height: 1.5,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// ================= ABOUT US SCREEN =================
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _topHeader(context, 'About Us', isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF162032) : Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20)],
                        ),
                        child: const Icon(Icons.recycling, size: 80, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Revive EcoTech",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF003856),
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Earn Money While Recycling",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                      const SizedBox(height: 40),
                      _infoCard(
                        title: "Our Mission",
                        content: "Revive is the ultimate solution for eco-conscious families looking to make a positive impact on the environment while earning money through convenient scrap recycling services.",
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),
                      _darkCard(isDark),
                      const SizedBox(height: 40),
                      Text("© 2026 Revive Ecotech Ltd", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.black54)),
                      const SizedBox(height: 40),
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
}

/// ================= HELP SUPPORT =================
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _topHeader(context, "Help & Support", isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _supportTile(Icons.call_outlined, "Customer Care", "6304218355", isDark),
                      _supportTile(Icons.email_outlined, "Email Support", "reviveecotech@gmail.com", isDark),
                      _supportTile(Icons.help_outline, "FAQ Support", "Common rider questions", isDark),
                      _supportTile(Icons.location_on_outlined, "Pickup Support", "Navigation & pickup help", isDark),
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
}

/// ================= PRIVACY POLICY =================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _topHeader(context, "Privacy Policy", isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _infoCard(
                        title: "Privacy Information",
                        content: "ReviveEcoTech Rider securely stores rider account information, pickup locations, and order details to provide smooth recycling pickup operations.\n\nLocation access is used only for navigation and active pickup services.\n\nYour information is protected and never shared with unauthorized third parties.",
                        isDark: isDark,
                      ),
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
}

/// ================= TERMS =================
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _topHeader(context, "Terms & Conditions", isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _infoCard(
                        title: "Terms & Conditions",
                        content: "Riders must complete pickups responsibly, verify OTPs before completion, and follow company guidelines.\n\nAny misuse, fake completion, or policy violations may result in account suspension.\n\nBy using ReviveEcoTech Rider, you agree to follow all operational and safety policies.",
                        isDark: isDark,
                      ),
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
}

/// ================= FAQ =================
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        final isDark = value;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              _topHeader(context, "FAQs", isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _faqTile("How do I start a pickup?", "Accept the order and wait until pickup time becomes active.", isDark),
                      _faqTile("Why is Start Pickup disabled?", "The pickup time slot has not started yet.", isDark),
                      _faqTile("How do I complete a pickup?", "Enter the customer OTP inside Order Details to complete the order.", isDark),
                      _faqTile("What if OTP is wrong?", "The order cannot be completed until the correct OTP is entered.", isDark),
                      _faqTile("Can I call the customer?", "Yes, use the Call Customer button inside Order Details.", isDark),
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
}
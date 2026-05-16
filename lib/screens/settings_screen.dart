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
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  String tr(String key) {
    return AppLocalizations.of(
      context,
    ).translate(key);
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: isDarkMode,

      builder: (context, value, child) {

        return Scaffold(

          backgroundColor:
              isDarkMode.value
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFFCF3E3),

          bottomNavigationBar:
              const CustomBottomNavBar(
            currentIndex: 2,
          ),

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

                        title:
                            tr('about_us'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const AboutUsScreen(),
                            ),
                          );
                        },
                      ),

                      /// HELP & SUPPORT
                      _buildSettingsItem(
                        icon: Icons
                            .headset_mic_outlined,

                        title:
                            tr('help_support'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),

                      /// PRIVACY POLICY
                      _buildSettingsItem(
                        icon: Icons
                            .privacy_tip_outlined,

                        title:
                            tr('privacy_policy'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),

                      /// TERMS
                      _buildSettingsItem(
                        icon: Icons
                            .description_outlined,

                        title:
                            tr('terms_conditions'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsConditionsScreen(),
                            ),
                          );
                        },
                      ),

                      /// FAQS
                      _buildSettingsItem(
                        icon: Icons
                            .question_answer_outlined,

                        title:
                            tr('faqs'),

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  const FAQScreen(),
                            ),
                          );
                        },
                      ),

                      /// APP VERSION
                      _buildSettingsItem(
                        icon: Icons
                            .file_copy_outlined,

                        title:
                            tr('app_version'),

                        showArrow:
                            false,

                        trailing:
                            const Text(
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
                        icon:
                            Icons.history,

                        title:
                            tr('history'),

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
                        icon:
                            Icons.dashboard,

                        title:
                            tr('home'),

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
                        icon:
                            Icons.person,

                        title:
                            tr('profile'),

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
                        icon:
                            Icons.logout,

                        title:
                            tr('logout'),

                        iconColor:
                            Colors.red,

                        showArrow:
                            false,

                        onTap: () {

                          Navigator.pushReplacement(
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
      },
    );
  }

  Widget _buildHeader(
      BuildContext context) {

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Color(0xFF003856),

        borderRadius:
            BorderRadius.only(
          bottomLeft:
              Radius.circular(50),
          bottomRight:
              Radius.circular(50),
        ),
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

          Text(
            tr('settings'),

            style: const TextStyle(
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
                CircleAvatar(
              radius: 25,

              backgroundColor:
                  const Color(
                      0xFFFCF3E3),

              child: const Icon(
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

        color:
            isDarkMode.value
                ? const Color(
                    0xFF2A2A2A)
                : Colors.white,

        borderRadius:
            BorderRadius.circular(
                20),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
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

          style: TextStyle(
            fontSize: 18,

            fontWeight:
                FontWeight.bold,

            color:
                isDarkMode.value
                    ? Colors.white
                    : const Color(
                        0xFF003856),

            fontFamily:
                'RedHatDisplay',
          ),
        ),

        trailing: trailing ??
            (showArrow
                ? const Icon(
                    Icons.chevron_right,

                    color: Color(
                        0xFF98C13F),

                    size: 30,
                  )
                : null),
      ),
    );
  }
}

/// ================= ABOUT US SCREEN =================
class AboutUsScreen
    extends StatelessWidget {

  const AboutUsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFFCF3E3),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              _topHeader(
                context,
                'About Us',
              ),

              const SizedBox(
                  height: 30),

              CircleAvatar(
                radius: 80,

                backgroundColor:
                    Colors.white,

                child: const Icon(
                  Icons.recycling,
                  size: 80,
                  color:
                      Color(0xFF98C13F),
                ),
              ),

              const SizedBox(
                  height: 20),

              const Text(
                "Revive Eco Tech",

                style: TextStyle(
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xFF003856),
                ),
              ),

              const SizedBox(
                  height: 10),

              const Text(
                "Earn Money While Recycling",

                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                  height: 30),

              _infoCard(
                title: "Our Mission",

                content:
                    "Revive is the ultimate solution for eco-conscious families looking to make a positive impact on the environment while earning money through convenient scrap recycling services.",
              ),

              const SizedBox(
                  height: 25),

              _darkCard(),

              const SizedBox(
                  height: 30),

              const Text(
                "© 2025 Revive Ecotech Ltd",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xFF003856),
                ),
              ),

              const SizedBox(
                  height: 8),

              const Text(
                "Version 1.0.0",

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                  height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= HELP SUPPORT =================
class HelpSupportScreen
    extends StatelessWidget {

  const HelpSupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFFCF3E3),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              _topHeader(
                context,
                "Help & Support",
              ),

              const SizedBox(
                  height: 30),

              _supportTile(
                Icons.call,
                "Customer Care",
                "6304218355",
              ),

              _supportTile(
                Icons.email,
                "Email Support",
                "reviveecotech@gmail.com",
              ),

              _supportTile(
                Icons.help_outline,
                "FAQ Support",
                "Common rider questions",
              ),

              _supportTile(
                Icons.location_on,
                "Pickup Support",
                "Navigation & pickup help",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= PRIVACY POLICY =================
class PrivacyPolicyScreen
    extends StatelessWidget {

  const PrivacyPolicyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFFCF3E3),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              _topHeader(
                context,
                "Privacy Policy",
              ),

              const SizedBox(
                  height: 30),

              _infoCard(
                title:
                    "Privacy Information",

                content:
                    "ReviveEcoTech Rider securely stores rider account information, pickup locations, and order details to provide smooth recycling pickup operations.\n\nLocation access is used only for navigation and active pickup services.\n\nYour information is protected and never shared with unauthorized third parties.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= TERMS =================
class TermsConditionsScreen
    extends StatelessWidget {

  const TermsConditionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFFCF3E3),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              _topHeader(
                context,
                "Terms & Conditions",
              ),

              const SizedBox(
                  height: 30),

              _infoCard(
                title:
                    "Terms & Conditions",

                content:
                    "Riders must complete pickups responsibly, verify OTPs before completion, and follow company guidelines.\n\nAny misuse, fake completion, or policy violations may result in account suspension.\n\nBy using ReviveEcoTech Rider, you agree to follow all operational and safety policies.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= FAQ =================
class FAQScreen
    extends StatelessWidget {

  const FAQScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFFCF3E3),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              _topHeader(
                context,
                "FAQs",
              ),

              const SizedBox(
                  height: 20),

              _faqTile(
                "How do I start a pickup?",
                "Accept the order and wait until pickup time becomes active.",
              ),

              _faqTile(
                "Why is Start Pickup disabled?",
                "The pickup time slot has not started yet.",
              ),

              _faqTile(
                "How do I complete a pickup?",
                "Enter the customer OTP inside Order Details to complete the order.",
              ),

              _faqTile(
                "What if OTP is wrong?",
                "The order cannot be completed until correct OTP is entered.",
              ),

              _faqTile(
                "Can I call the customer?",
                "Yes, use the Call Customer button inside Order Details.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= COMMON HEADER =================
Widget _topHeader(
  BuildContext context,
  String title,
) {

  return Container(
    width: double.infinity,

    decoration: const BoxDecoration(
      color: Color(0xFF003856),

      borderRadius:
          BorderRadius.only(
        bottomLeft:
            Radius.circular(50),

        bottomRight:
            Radius.circular(50),
      ),
    ),

    padding:
        const EdgeInsets.fromLTRB(
            20, 40, 20, 35),

    child: Row(
      children: [

        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),

        Expanded(
          child: Center(
            child: Text(
              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 40),
      ],
    ),
  );
}

/// ================= INFO CARD =================
Widget _infoCard({
  required String title,
  required String content,
}) {

  return Container(
    margin:
        const EdgeInsets.symmetric(
      horizontal: 20,
    ),

    padding:
        const EdgeInsets.all(25),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(30),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: const TextStyle(
            fontSize: 28,
            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFF003856),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          content,

          style: const TextStyle(
            fontSize: 20,
            height: 1.6,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

/// ================= DARK CARD =================
Widget _darkCard() {

  return Container(
    margin:
        const EdgeInsets.symmetric(
      horizontal: 20,
    ),

    padding:
        const EdgeInsets.all(25),

    decoration: BoxDecoration(
      color: const Color(0xFF003856),

      borderRadius:
          BorderRadius.circular(30),
    ),

    child: const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          "Why Choose Us?",

          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        SizedBox(height: 25),

        ListTile(
          leading: Icon(
            Icons.shield_outlined,
            color: Color(0xFF98C13F),
          ),

          title: Text(
            "Trusted & Reliable",

            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          subtitle: Text(
            "Verified agents at your doorstep.",

            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ),

        ListTile(
          leading: Icon(
            Icons.flash_on,
            color: Color(0xFF98C13F),
          ),

          title: Text(
            "Fast Service",

            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          subtitle: Text(
            "Quick pickup within scheduled slots.",

            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  );
}

/// ================= SUPPORT TILE =================
Widget _supportTile(
  IconData icon,
  String title,
  String subtitle,
) {

  return Container(
    margin:
        const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(25),
    ),

    child: ListTile(

      leading: CircleAvatar(
        backgroundColor:
            const Color(
                0xFFFCF3E3),

        child: Icon(
          icon,
          color:
              const Color(
                  0xFF003856),
        ),
      ),

      title: Text(
        title,

        style: const TextStyle(
          fontSize: 22,
          fontWeight:
              FontWeight.bold,

          color:
              Color(0xFF003856),
        ),
      ),

      subtitle: Text(
        subtitle,

        style: const TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

/// ================= FAQ TILE =================
Widget _faqTile(
  String question,
  String answer,
) {

  return Container(
    margin:
        const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(25),
    ),

    child: ExpansionTile(

      title: Text(
        question,

        style: const TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.bold,

          color:
              Color(0xFF003856),
        ),
      ),

      children: [

        Padding(
          padding:
              const EdgeInsets.all(20),

          child: Text(
            answer,

            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
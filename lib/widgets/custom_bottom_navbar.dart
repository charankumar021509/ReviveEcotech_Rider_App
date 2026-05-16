import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/settings_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B132B);

    return Container(
      decoration: BoxDecoration(
        color: navy,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.receipt_long_rounded, "Orders", const OrdersScreen()),
              _buildItem(context, 1, Icons.history_rounded, "History", const OrderHistoryScreen()),
              _buildItem(context, 2, Icons.settings_rounded, "Settings", const SettingsScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label, Widget screen) {
    final bool isActive = currentIndex == index;
    const green = Color(0xFF10B981);

    return Expanded(
      child: InkWell(
        onTap: () {
          if (isActive) return;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => screen,
              transitionsBuilder: (context, anim1, anim2, child) => FadeTransition(opacity: anim1, child: child),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? green : Colors.white38,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? green : Colors.white38,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
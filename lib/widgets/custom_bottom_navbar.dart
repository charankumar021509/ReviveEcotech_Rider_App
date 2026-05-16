import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/settings_screen.dart';

class CustomBottomNavBar
    extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavBar({

    super.key,

    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(

        left: 20,
        right: 20,
        bottom: 15,
      ),

      child: Container(

        decoration: BoxDecoration(

          color: Colors.black,

          borderRadius:
              BorderRadius.circular(40),

          boxShadow: const [

            BoxShadow(

              color: Colors.black26,

              blurRadius: 10,

              offset: Offset(0, 5),
            ),
          ],
        ),

        child: ClipRRect(

          borderRadius:
              BorderRadius.circular(40),

          child: BottomNavigationBar(

            currentIndex:
                currentIndex,

           backgroundColor:
               const Color(0xFF003856),

            selectedItemColor:
                Colors.cyanAccent,

            unselectedItemColor:
                Colors.grey,

            type:
                BottomNavigationBarType.fixed,

            onTap: (index) {

              if (index == 0) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const OrdersScreen(),
                  ),
                );
              }

              if (index == 1) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const OrderHistoryScreen(),
                  ),
                );
              }

              if (index == 2) {

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const SettingsScreen(),
                  ),
                );
              }
            },

            items: const [

              BottomNavigationBarItem(

                icon: Icon(Icons.home),

                label: 'order',
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.history),

                label: 'History',
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.settings),

                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
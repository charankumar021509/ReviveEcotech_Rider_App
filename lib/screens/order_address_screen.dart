import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schedule_screen.dart';
import 'theme_controller.dart';

class AddressScreen extends StatelessWidget {

  final String orderId;
  final String userId;

  final String customer;
  final String pickup;
  final String delivery;
  final String phone;
  final String status;

  final String date;
  final String time;

  final double latitude;
  final double longitude;

  const AddressScreen({
    super.key,

    required this.orderId,
    required this.userId,

    required this.customer,
    required this.pickup,
    required this.delivery,
    required this.phone,
    required this.status,

    required this.date,
    required this.time,

    required this.latitude,
    required this.longitude,
  });

  Future<void> completePickup(
      BuildContext context,
      ) async {

    try {

      /// UPDATE ORDER STATUS
      await FirebaseFirestore.instance
          .collection('pickups')
          .doc(orderId)
          .update({

        'status': 'Completed',
      });

      /// SEND NOTIFICATION
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({

        'userId': userId,

        'title': 'Pickup Completed',

        'message':
        'Your pickup has been completed successfully.',

        'createdAt':
        DateTime.now().toString(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pickup Completed Successfully',
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
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

          appBar: AppBar(
            backgroundColor:
            const Color(0xFF003856),

            elevation: 0,

            centerTitle: true,

            title: const Text(
              'Addresses',

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'RedHatDisplay',
              ),
            ),
          ),

          body: Padding(
            padding:
            const EdgeInsets.all(20),

            child: Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color:
                isDarkMode.value
                    ? const Color(
                    0xFF2A2A2A)
                    : const Color(
                    0xC8A6CB4E),

                borderRadius:
                BorderRadius.circular(
                    20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    customer,

                    style:
                    TextStyle(
                      fontSize: 28,

                      fontWeight:
                      FontWeight.bold,

                      color:
                      isDarkMode.value
                          ? Colors.white
                          : Colors.black,

                      fontFamily:
                      'RedHatDisplay',
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color:
                        Color(0xFF003856),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Pickup: $pickup',

                          style:
                          TextStyle(
                            fontSize: 18,

                            color:
                            isDarkMode.value
                                ? Colors.white
                                : Colors.black,

                            fontFamily:
                            'RedHatDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(
                        Icons.home,
                        color:
                        Color(0xFF003856),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Delivery: $delivery',

                          style:
                          TextStyle(
                            fontSize: 18,

                            color:
                            isDarkMode.value
                                ? Colors.white
                                : Colors.black,

                            fontFamily:
                            'RedHatDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(
                        Icons.phone,
                        color:
                        Color(0xFF003856),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        phone,

                        style:
                        TextStyle(
                          fontSize: 18,

                          color:
                          isDarkMode.value
                              ? Colors.white
                              : Colors.black,

                          fontFamily:
                          'RedHatDisplay',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(
                        Icons.calendar_today,
                        color:
                        Color(0xFF003856),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        date,

                        style:
                        TextStyle(
                          fontSize: 18,

                          color:
                          isDarkMode.value
                              ? Colors.white
                              : Colors.black,

                          fontFamily:
                          'RedHatDisplay',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      const Icon(
                        Icons.access_time,
                        color:
                        Color(0xFF003856),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        time,

                        style:
                        TextStyle(
                          fontSize: 18,

                          color:
                          isDarkMode.value
                              ? Colors.white
                              : Colors.black,

                          fontFamily:
                          'RedHatDisplay',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(

                      color:
                      isDarkMode.value
                          ? Colors.black
                          : Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                          15),
                    ),

                    child: Text(
                      status,

                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.bold,

                        fontSize: 16,

                        color:
                        isDarkMode.value
                            ? Colors.white
                            : Colors.black,

                        fontFamily:
                        'RedHatDisplay',
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      ElevatedButton.icon(

                        onPressed: () async {

                          final Uri googleMapUrl = Uri.parse(

                            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
                          );

                          if (await canLaunchUrl(
                              googleMapUrl)) {

                            await launchUrl(
                              googleMapUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(
                              0xFF003856),

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                15),
                          ),
                        ),

                        icon: const Icon(
                          Icons.map,
                          color: Colors.white,
                        ),

                        label: const Text(
                          'Maps',

                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                            'RedHatDisplay',
                          ),
                        ),
                      ),

                      ElevatedButton.icon(

                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                              const ScheduleScreen(),
                            ),
                          );
                        },

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(
                              0xFF003856),

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                15),
                          ),
                        ),

                        icon: const Icon(
                          Icons.timeline,
                          color: Colors.white,
                        ),

                        label: const Text(
                          'Timeline',

                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                            'RedHatDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// COMPLETE PICKUP BUTTON

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: () =>
                          completePickup(context),

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.green,

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              15),
                        ),
                      ),

                      child: const Text(
                        'Complete Pickup',

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
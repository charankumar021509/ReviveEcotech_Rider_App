import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'order_details_screen.dart';
import 'theme_controller.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'dashboard_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: isDarkMode.value
                ? const Color(0xFF1E1E1E)
                : const Color(0xFFFCF3E3),
            bottomNavigationBar: const CustomBottomNavBar(
              currentIndex: 0,
            ),
            appBar: AppBar(
              backgroundColor: const Color(0xFF003856),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardScreen(),
                    ),
                  );
                },
              ),
              title: const Text(
                "Orders Schedule",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: [
                  Tab(text: "Pending"),
                  Tab(text: "Confirmed"),
                  Tab(text: "Pickup"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildOrdersList(
                  context: context,
                  status: 'Pending',
                  buttonText: 'Accept',
                  nextStatus: 'Confirmed',
                  buttonColor: Colors.orange,
                ),
                _buildOrdersList(
                  context: context,
                  status: 'Confirmed',
                  buttonText: 'Start Pickup',
                  nextStatus: 'Out-for-Pickup',
                  buttonColor: Colors.green,
                ),
                _buildOrdersList(
                  context: context,
                  status: 'Out-for-Pickup',
                  buttonText: 'View Details',
                  nextStatus: '',
                  buttonColor: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList({
    required BuildContext context,
    required String status,
    required String buttonText,
    required Color buttonColor,
    required String nextStatus,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('agents')
          .doc(currentUser!.uid)
          .get(),
      builder: (context, agentSnapshot) {
        if (!agentSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final agentData =
            agentSnapshot.data!.data() as Map<String, dynamic>;

        final isOnline = agentData['isOnline'] ?? true;

        if (!isOnline && status == 'Pending') {
          return const Center(
            child: Text('You are offline'),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: status == 'Pending'
              ? FirebaseFirestore.instance
                  .collection('pickups')
                  .where(
                    'status',
                    isEqualTo: status,
                  )
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('pickups')
                  .where(
                    'status',
                    isEqualTo: status,
                  )
                  .where(
                    'agentId',
                    isEqualTo: currentUser.uid,
                  )
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No $status Orders Found",
                ),
              );
            }

            final orders =
                snapshot.data!.docs.where((doc) {
              final data =
                  doc.data() as Map<String, dynamic>;

              final declinedBy =
                  List<String>.from(
                data['declinedBy'] ?? [],
              );

              return !declinedBy.contains(
                currentUser.uid,
              );
            }).toList();

            // SORT BY NEAREST PICKUP DATE/TIME
            orders.sort((a, b) {
              final dataA =
                  a.data()
                      as Map<String, dynamic>;

              final dataB =
                  b.data()
                      as Map<String, dynamic>;

              final dateTimeA =
                  _getPickupDateTime(dataA);

              final dateTimeB =
                  _getPickupDateTime(dataB);

              return dateTimeA.compareTo(
                dateTimeB,
              );
            });

            if (orders.isEmpty) {
              return Center(
                child: Text(
                  "No $status Orders Found",
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                final data =
                    order.data() as Map<String, dynamic>;

                final address =
                    data['addressDetails']
                        as Map<String, dynamic>?;

                final canStartPickup =
                    DateTime.now().isAfter(
                  _getPickupDateTime(data),
                );

                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDarkMode.value
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xC8A6CB4E),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customer Order",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        (data['scrapCategories']
                                    as List?)
                                ?.join(', ') ??
                            '',
                        style: TextStyle(
                          color: isDarkMode.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        address?['fullAddress']
                                ?.toString() ??
                            '',
                        style: TextStyle(
                          color: isDarkMode.value
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        data['pickupDate']
                                is Timestamp
                            ? "Pickup Date: "
                                "${(data['pickupDate'] as Timestamp).toDate().day}/"
                                "${(data['pickupDate'] as Timestamp).toDate().month}/"
                                "${(data['pickupDate'] as Timestamp).toDate().year}"
                            : "Pickup Date: ${data['pickupDate'] ?? ''}",
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Pickup Time: ${data['pickupTimeSlot'] ?? ''}",
                      ),

                      const SizedBox(height: 15),

                      status == 'Pending'
                          ? Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final orderRef =
                                          FirebaseFirestore
                                              .instance
                                              .collection(
                                                  'pickups')
                                              .doc(order.id);

                                      bool accepted =
                                          false;

                                      await FirebaseFirestore
                                          .instance
                                          .runTransaction(
                                        (transaction) async {
                                          final snapshot =
                                              await transaction
                                                  .get(
                                                      orderRef);

                                          final orderData =
                                              snapshot
                                                  .data();

                                          if (orderData?[
                                                  'agentId'] !=
                                              null) {
                                            return;
                                          }

                                          transaction
                                              .update(
                                            orderRef,
                                            {
                                              'status':
                                                  'Confirmed',
                                              'agentId':
                                                  currentUser
                                                      .uid,
                                              'acceptedAt':
                                                  FieldValue
                                                      .serverTimestamp(),
                                            },
                                          );

                                          accepted =
                                              true;
                                        },
                                      );

                                      if (!accepted) {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Order already accepted by another rider',
                                            ),
                                          ),
                                        );

                                        return;
                                      }

                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'notifications')
                                          .add({
                                        'userId':
                                            data['userId'],
                                        'title':
                                            'Order Accepted',
                                        'message':
                                            'Your order has been accepted by the rider.',
                                        'createdAt':
                                            DateTime.now()
                                                .toString(),
                                      });

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Order Accepted Successfully',
                                          ),
                                        ),
                                      );

                                      Future.delayed(
                                        const Duration(
                                            milliseconds:
                                                300),
                                        () {
                                          final tabController =
                                              DefaultTabController.of(
                                                  context);

                                          if (tabController !=
                                              null) {
                                            tabController
                                                .animateTo(
                                                    1);
                                          }
                                        },
                                      );
                                    },
                                    style: ElevatedButton
                                        .styleFrom(
                                      backgroundColor:
                                          Colors.green,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                15),
                                      ),
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                    ),
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(
                                        color:
                                            Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () async {
                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'pickups')
                                          .doc(order.id)
                                          .update({
                                        'declinedBy':
                                            FieldValue
                                                .arrayUnion([
                                          currentUser.uid,
                                        ]),
                                        'declinedStatus':
                                            true,
                                        'declinedAt':
                                            FieldValue
                                                .serverTimestamp(),
                                      });

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Order Declined',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton
                                        .styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                15),
                                      ),
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                    ),
                                    child: const Text(
                                      'Decline',
                                      style: TextStyle(
                                        color:
                                            Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    status ==
                                            'Confirmed'
                                        ? canStartPickup
                                            ? () async {
                                                final otp =
                                                    1000 +
                                                        (DateTime.now().millisecondsSinceEpoch %
                                                            9000);

                                                await FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        'pickups')
                                                    .doc(
                                                        order.id)
                                                    .update({
                                                  'status':
                                                      nextStatus,
                                                  'pickupOtp':
                                                      otp,
                                                  'pickupStartedAt':
                                                      FieldValue.serverTimestamp(),
                                                });

                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(
                                                      'Pickup Started Successfully\nOTP: $otp',
                                                    ),
                                                  ),
                                                );

                                                Future.delayed(
                                                  const Duration(
                                                      milliseconds:
                                                          300),
                                                  () {
                                                    final tabController =
                                                        DefaultTabController.of(
                                                            context);

                                                    if (tabController !=
                                                        null) {
                                                      tabController.animateTo(
                                                          2);
                                                    }
                                                  },
                                                );
                                              }
                                            : null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        OrderDetailsScreen(
                                                  pickupAddress:
                                                      address?['fullAddress']
                                                              ?.toString() ??
                                                          '',
                                                  dropAddress:
                                                      'Revive EcoTech',
                                                  pickupDate:
                                                      data['pickupDate'] != null
                                                          ? DateFormat(
                                                              'dd/MM/yyyy',
                                                            ).format(
                                                              (data['pickupDate']
                                                                      as Timestamp)
                                                                  .toDate(),
                                                            )
                                                          : '',
                                                  pickupTime:
                                                      data['pickupTimeSlot']
                                                              ?.toString() ??
                                                          '',
                                                  customerPhone:
                                                      data['customerPhone']
                                                              ?.toString() ??
                                                          '',
                                                  scrapItems:
                                                      data['scrapCategories'] ??
                                                          [],
                                                  orderId:
                                                      order.id,
                                                  latitude:
                                                      (address?['latitude'] ??
                                                              0.0)
                                                          .toDouble(),
                                                  longitude:
                                                      (address?['longitude'] ??
                                                              0.0)
                                                          .toDouble(),
                                                  userId:
                                                      data['userId']
                                                              ?.toString() ??
                                                          '',
                                                ),
                                              ),
                                            );
                                          },
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                      status ==
                                              'Confirmed'
                                          ? (canStartPickup
                                              ? Colors.green
                                              : Colors.grey)
                                          : buttonColor,
                                  disabledBackgroundColor:
                                      Colors.grey,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            15),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: Text(
                                  buttonText,
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static DateTime _getPickupDateTime(
    Map<String, dynamic> data,
  ) {
    try {
      final pickupDate =
          data['pickupDate'];

      final pickupTime =
          data['pickupTimeSlot']
                  ?.toString() ??
              '';

      DateTime date;

      if (pickupDate is Timestamp) {
        date = pickupDate.toDate();
      } else {
        date = DateTime.now();
      }

      final cleanedTime =
          pickupTime
              .split('-')
              .first
              .trim();

      final isPM =
          cleanedTime.contains('PM');

      final time = cleanedTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim();

      final parts = time.split(':');

      int hour = int.parse(parts[0]);

      final minute =
          int.parse(parts[1]);

      if (isPM && hour < 12) {
        hour += 12;
      }

      if (!isPM && hour == 12) {
        hour = 0;
      }

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    } catch (e) {
      return DateTime.now();
    }
  }
}
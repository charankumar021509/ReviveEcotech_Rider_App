import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_settings_screen.dart';
import 'order_details_screen.dart';
import 'theme_controller.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_navbar.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  final TextEditingController
      _searchController =
          TextEditingController();

  String searchQuery = '';

  String selectedFilter =
      'Completed';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {

      setState(() {

        searchQuery =
            _searchController.text
                .trim()
                .toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(

      valueListenable:
          isDarkMode,

      builder:
          (context, value, child) {

        return Scaffold(

          backgroundColor:
              isDarkMode.value
                  ? const Color(
                      0xFF1E1E1E)
                  : const Color(
                      0xFFFCF3E3),
                      bottomNavigationBar:
                          const CustomBottomNavBar(
                        currentIndex: 1,
                      ),

          body: Column(
            children: [

              /// ================= HEADER =================

              Container(

                height: 190,

                width:
                    double.infinity,

                decoration:
                    const BoxDecoration(

                  color:
                      Color(0xFF003856),

                  borderRadius:
                      BorderRadius.only(

                    bottomLeft:
                        Radius.circular(
                            35),

                    bottomRight:
                        Radius.circular(
                            35),
                  ),
                ),

                child:
                    _buildHeader(),
              ),

              /// ================= CONTENT =================

              Expanded(

                child:
                    SingleChildScrollView(

                  child: Padding(

                    padding:
                        const EdgeInsets
                            .all(20),

                    child: Column(

                      children: [

                        /// SEARCH BAR
                        _buildSearchBar(),

                        const SizedBox(
                            height: 15),

                        /// ================= FILTER BUTTONS =================

                        Row(

                          children: [

                            /// COMPLETED
                            Expanded(

                              child:
                                  GestureDetector(

                                onTap: () {

                                  setState(() {

                                    selectedFilter =
                                        'Completed';
                                  });
                                },

                                child:
                                    AnimatedContainer(

                                  duration:
                                      const Duration(
                                    milliseconds:
                                        250,
                                  ),

                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        12,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color:
                                        selectedFilter ==
                                                'Completed'

                                            ? Colors.green

                                            : isDarkMode.value
                                                ? const Color(
                                                    0xFF2A2A2A)
                                                : Colors.grey.shade300,

                                    borderRadius:
                                        BorderRadius.circular(
                                            12),
                                  ),

                                  child:
                                      Center(

                                    child:
                                        Text(

                                      'Completed',

                                      style:
                                          TextStyle(

                                        color:
                                            selectedFilter ==
                                                    'Completed'

                                                ? Colors.white

                                                : isDarkMode.value
                                                    ? Colors.white
                                                    : Colors.black,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 12),

                            /// DECLINED
                            Expanded(

                              child:
                                  GestureDetector(

                                onTap: () {

                                  setState(() {

                                    selectedFilter =
                                        'Declined';
                                  });
                                },

                                child:
                                    AnimatedContainer(

                                  duration:
                                      const Duration(
                                    milliseconds:
                                        250,
                                  ),

                                  padding:
                                      const EdgeInsets.symmetric(
                                    vertical:
                                        12,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color:
                                        selectedFilter ==
                                                'Declined'

                                            ? Colors.red

                                            : isDarkMode.value
                                                ? const Color(
                                                    0xFF2A2A2A)
                                                : Colors.grey.shade300,

                                    borderRadius:
                                        BorderRadius.circular(
                                            12),
                                  ),

                                  child:
                                      Center(

                                    child:
                                        Text(

                                      'Declined',

                                      style:
                                          TextStyle(

                                        color:
                                            selectedFilter ==
                                                    'Declined'

                                                ? Colors.white

                                                : isDarkMode.value
                                                    ? Colors.white
                                                    : Colors.black,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 20),

                        _buildHistorySection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= HEADER =================

  Widget _buildHeader() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 40,
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          StreamBuilder<DocumentSnapshot>(

            stream:
                FirebaseFirestore
                    .instance
                    .collection(
                        'agents')
                    .doc(
                      FirebaseAuth
                          .instance
                          .currentUser
                          ?.uid,
                    )
                    .snapshots(),

            builder:
                (context, snapshot) {

              String name =
                  'Agent';

            if (snapshot.hasData &&
                snapshot.data!.exists) {

              final data =
                  snapshot.data!.data()
                      as Map<String,
                          dynamic>;
               name =
                   data['name']
                           ?.toString() ??
                       'Agent';
             }

              return Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(
                    'Welcome back',

                    style: TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                      height: 2),

                  Text(
                    name,

                    style:
                        const TextStyle(

                      color:
                          Colors.white,

                      fontSize: 30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
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

            child: CircleAvatar(

              radius: 35,

              backgroundColor:
                  isDarkMode.value
                      ? const Color(
                          0xFF2A2A2A)
                      : const Color(
                          0xFFFCF3E3),

              child: const Icon(
                Icons.person,

                size: 40,

                color:
                    Color(0xFF003856),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SEARCH BAR =================

  Widget _buildSearchBar() {

    return Container(

      decoration: BoxDecoration(

        color:
            isDarkMode.value
                ? const Color(
                    0xFF2A2A2A)
                : Colors.white,

        borderRadius:
            BorderRadius.circular(
                15),
      ),

      child: TextField(

        controller:
            _searchController,

        style: TextStyle(

          color:
              isDarkMode.value
                  ? Colors.white
                  : Colors.black,
        ),

        decoration:
            InputDecoration(

          hintText:
              'Search orders',

          hintStyle: TextStyle(

            color:
                isDarkMode.value
                    ? Colors.white54
                    : Colors.black54,
          ),

          prefixIcon: Icon(

            Icons.search,

            color:
                isDarkMode.value
                    ? Colors.white54
                    : Colors.black54,
          ),

          border:
              InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 15,
          ),
        ),
      ),
    );
  }

  /// ================= HISTORY SECTION =================

  Widget _buildHistorySection() {

    return StreamBuilder<QuerySnapshot>(

      stream:
          FirebaseFirestore
              .instance
              .collection(
                  'pickups')
              .snapshots(),

      builder:
          (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {

          return const Center(
            child: Text(
              'No Orders Found',
            ),
          );
        }

        final orders =
            snapshot.data!.docs.where(
          (doc) {

            final data =
                doc.data()
                    as Map<String,
                        dynamic>;

            /// FILTER
            bool matchesFilter =
                false;

            if (selectedFilter ==
                'Completed') {

              matchesFilter =

                  data['status'] ==
                      'Completed' &&

                  data['declinedStatus'] !=
                      true;

            } else {

              matchesFilter =
                  data['declinedStatus'] ==
                      true;
            }

            /// SEARCH
            final address =
                data['addressDetails'];

            final fullAddress =
                address?['fullAddress']
                        ?.toString()
                        .toLowerCase() ??
                    '';

            return matchesFilter &&
                fullAddress.contains(
                    searchQuery);
          },
        ).toList();

        if (orders.isEmpty) {

          return Center(

            child: Text(

              selectedFilter ==
                      'Completed'

                  ? 'No Completed Orders'

                  : 'No Declined Orders',
            ),
          );
        }

        return Column(

          children:
              orders.map((order) {

            final data =
                order.data()
                    as Map<String,
                        dynamic>;

            final address =
                data['addressDetails'];

            return Container(

              margin:
                  const EdgeInsets.only(
                      bottom: 15),

              padding:
                  const EdgeInsets.all(
                      18),

              decoration:
                  BoxDecoration(

                color:
                    isDarkMode.value
                        ? const Color(
                            0xFF2A2A2A)
                        : Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    "Customer Order",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Text(

                    address?['fullAddress']
                            ?.toString() ??
                        '',

                    style: TextStyle(

                      color:
                          isDarkMode.value
                              ? Colors.white70
                              : Colors.black87,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Text(

                    "Pickup Date: ${DateFormat(
                      'dd/MM/yyyy',
                    ).format(

                      (data['pickupDate']
                              as Timestamp)
                          .toDate(),
                    )}",
                  ),

                  const SizedBox(
                      height: 5),

                  Text(
                    "Pickup Time: ${data['pickupTimeSlot'] ?? ''}",
                  ),

                  const SizedBox(
                      height: 15),

                  Row(

                    children: [

                      Expanded(

                        child:
                            ElevatedButton(

                          onPressed:
                              () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>

                                    OrderDetailsScreen(

                                  pickupAddress:
                                      address?[
                                                  'fullAddress']
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

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                const Color(
                                    0xFF003856),

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 14,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                      14),
                            ),
                          ),

                          child: const Text(

                            'View Details',

                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
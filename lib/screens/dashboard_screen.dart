    import 'dart:async';

    import 'package:flutter/material.dart';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'package:cloud_firestore/cloud_firestore.dart';

    import 'orders_screen.dart';
    import 'order_history_screen.dart';
    import 'settings_screen.dart';
    import 'profile_settings_screen.dart';
    import 'order_details_screen.dart';
    import 'theme_controller.dart';
    import '../localization/app_localizations.dart';
    import '../services/notification_service.dart';

    class DashboardScreen extends StatefulWidget {
      const DashboardScreen({super.key});

      @override
      State<DashboardScreen> createState() =>
          _DashboardScreenState();
    }

    class _DashboardScreenState
        extends State<DashboardScreen> {

      late AppLocalizations lang;

      int _selectedIndex = 0;

      String riderName = 'Rider';

      bool isLoadingUser = true;

      // ── NEW: online status ──
      bool isOnline = true;

      // ── NEW: stats ──


      Timer? _timer;

      DateTime currentTime = DateTime.now();
      bool _pickupNotificationShown = false;

      @override
      void initState() {

        super.initState();

        _selectedIndex = 0;

        fetchUserData();

        // ── NEW: fetch stats ──


        _startLiveTimer();
      }

     void _startLiveTimer() {

       _timer = Timer.periodic(
         const Duration(seconds: 1),

         (_) async {

           if (!mounted) return;

           setState(() {

             currentTime = DateTime.now();
           });

           try {

             final currentUser =
                 FirebaseAuth.instance.currentUser;

             if (currentUser == null) return;

             final snapshot =
                 await FirebaseFirestore.instance
                     .collection('pickups')
                     .where(
                       'status',
                       isEqualTo: 'Confirmed',
                     )
                     .where(
                       'agentId',
                       isEqualTo: currentUser.uid,
                     )
                     .get();

             if (snapshot.docs.isEmpty) return;

             final docs = snapshot.docs;

             docs.sort((a, b) {

               final dataA =
                   a.data() as Map<String, dynamic>;

               final dataB =
                   b.data() as Map<String, dynamic>;

               final dateA =
                   _getPickupDateTime(
                 pickupDate:
                     dataA['pickupDate'],
                 pickupTimeSlot:
                     dataA['pickupTimeSlot']
                             ?.toString() ??
                         '',
               );

               final dateB =
                   _getPickupDateTime(
                 pickupDate:
                     dataB['pickupDate'],
                 pickupTimeSlot:
                     dataB['pickupTimeSlot']
                             ?.toString() ??
                         '',
               );

               return dateA.compareTo(dateB);
             });

             final nearestOrder =
                 docs.first.data()
                     as Map<String, dynamic>;

             final pickupDateTime =
                 _getPickupDateTime(
               pickupDate:
                   nearestOrder['pickupDate'],
               pickupTimeSlot:
                   nearestOrder['pickupTimeSlot']
                           ?.toString() ??
                       '',
             );

             final remainingSeconds =
                 pickupDateTime
                     .difference(currentTime)
                     .inSeconds;

             if (remainingSeconds <= 0 &&
                 !_pickupNotificationShown) {

               _pickupNotificationShown = true;

               await NotificationService
                   .showLocalNotification(

                 title:
                     'Pickup Time Reached',

                 body:
                     'Order is ready for pickup',
               );
             }

             // reset for next upcoming pickup
             if (remainingSeconds > 0) {

               _pickupNotificationShown = false;
             }

           } catch (e) {

             debugPrint(
               'Timer notification error: $e',
             );
           }
         },
       );
     }

      @override
      void dispose() {

        _timer?.cancel();

        super.dispose();
      }

      Future<void> fetchUserData() async {

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

                riderName =
                    doc['name'] ?? 'Rider';

                isLoadingUser = false;
              });
            }
          }

        } catch (e) {

          setState(() {

            isLoadingUser = false;
          });
        }
      }

      // ── NEW: fetch stats from Firestore ──


      DateTime _getPickupDateTime({
        required dynamic pickupDate,
        required String pickupTimeSlot,
      }) {

        try {

          DateTime parsedDate;

          if (pickupDate is Timestamp) {

            parsedDate =
                pickupDate.toDate();

          } else {

            final dateParts =
                pickupDate
                    .toString()
                    .split('-');

            parsedDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
          }

          String time =
              pickupTimeSlot;

          if (pickupTimeSlot.contains('-')) {

            time =
                pickupTimeSlot
                    .split('-')
                    .first
                    .trim();
          }

          final isPM =
              time.toLowerCase().contains('pm');

          time = time
              .replaceAll('AM', '')
              .replaceAll('PM', '')
              .replaceAll('am', '')
              .replaceAll('pm', '')
              .trim();

          final timeParts =
              time.split(':');

          int hour =
              int.parse(timeParts[0]);

          int minute =
              int.parse(timeParts[1]);

          if (isPM && hour != 12) {

            hour += 12;
          }

          if (!isPM && hour == 12) {

            hour = 0;
          }

          return DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            hour,
            minute,
          );

        } catch (e) {

          return DateTime.now();
        }
      }

      String _formatDuration(
          Duration duration) {

        final hours =
            duration.inHours
                .toString()
                .padLeft(2, '0');

        final minutes =
            (duration.inMinutes % 60)
                .toString()
                .padLeft(2, '0');

        final seconds =
            (duration.inSeconds % 60)
                .toString()
                .padLeft(2, '0');

        return '${hours}h : ${minutes}m : ${seconds}s';
      }

      String formatDate(dynamic date) {

        if (date == null) {
          return '';
        }

        if (date is Timestamp) {

          final converted =
              date.toDate();

          return
              "${converted.day}/"
              "${converted.month}/"
              "${converted.year}";
        }

        return date.toString();
      }

      @override
      Widget build(BuildContext context) {

        lang = AppLocalizations.of(context);

        return ValueListenableBuilder(
          valueListenable: isDarkMode,

          builder: (context, value, child) {

            return Scaffold(

              backgroundColor:
                  isDarkMode.value
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFF5F7FA),

              body: Column(
                children: [

                  /// HEADER
                  Container(
                    height: 165,
                    width: double.infinity,

                    decoration: const BoxDecoration(

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: [

                          Color(0xFF003856),
                          Color(0xFF005B8F),
                          Color(0xFF0077B6),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.only(
                        bottomLeft:
                            Radius.circular(60),

                        bottomRight:
                            Radius.circular(60),
                      ),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),

                    child:
                        _buildHeaderContent(),
                  ),

                  /// BODY
                  Expanded(
                    child:
                        SingleChildScrollView(

                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                20),

                        child: Column(
                          children: [

                            _buildSearchBar(),

                            const SizedBox(
                                height: 25),

                            /// IMAGE BANNER
                            Container(
                              height: 210,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                        25),

                                image:
                                    const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/globe_picture.jpg',
                                  ),

                                  fit: BoxFit.cover,
                                ),

                                boxShadow: [

                                  BoxShadow(
                                    color:
                                        Colors.black
                                            .withAlpha(
                                                70),

                                    blurRadius: 20,

                                    spreadRadius: 2,

                                    offset:
                                        const Offset(
                                            0, 10),
                                  ),
                                ],
                              ),

                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(20),

                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              25),

                                  gradient:
                                      LinearGradient(
                                    begin: Alignment
                                        .topCenter,

                                    end: Alignment
                                        .bottomCenter,

                                    colors: [

                                      Colors.black
                                          .withAlpha(
                                              20),

                                      Colors.black
                                          .withAlpha(
                                              160),
                                    ],
                                  ),
                                ),

                                child:
                                    const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .end,

                                  children: [

                                    Text(
                                      'Revive EcoTech',

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.white,

                                        fontSize: 30,

                                        fontWeight:
                                            FontWeight.bold,

                                        fontFamily:
                                            'RedHatDisplay',
                                      ),
                                    ),

                                    SizedBox(height: 8),

                                    Text(
                                      'Smart Recycling Pickup System',

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.white70,

                                        fontSize: 16,

                                        fontFamily:
                                            'RedHatDisplay',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 25),

                            // ── NEW: STATS SECTION ──
                            _buildStatsSection(),

                            const SizedBox(
                                height: 25),

                            /// ACTIVITY SECTION
                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(20),

                              decoration:
                                  BoxDecoration(

                                gradient:
                                    isDarkMode.value

                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF2A2A2A),
                                              Color(0xFF1E1E1E),
                                            ],
                                          )

                                        : const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color(0xFFF8F8F8),
                                            ],
                                          ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            25),

                                boxShadow: [

                                  BoxShadow(
                                    color:
                                        Colors.black
                                            .withAlpha(
                                                20),

                                    blurRadius: 15,

                                    offset:
                                        const Offset(
                                            0, 6),
                                  ),
                                ],
                              ),

                              child:
                                  _buildActivitySection(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              bottomNavigationBar:
                  _buildBottomNavBar(),
            );
          },
        );
      }

      /// HEADER
      Widget _buildHeaderContent() {

        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
                  25, 45, 25, 18),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    lang.translate('welcome'),

                    style: const TextStyle(
                      color:
                          Colors.white70,

                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    riderName,

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  // ── NEW: Online Status ──
                  const SizedBox(height: 6),

                 GestureDetector(

                   onTap: () async {

                     setState(() {

                       isOnline = !isOnline;
                     });

                     await FirebaseFirestore
                         .instance
                         .collection('agents')
                         .doc(
                           FirebaseAuth
                               .instance
                               .currentUser!
                               .uid,
                         )
                         .update({

                       'isOnline': isOnline,
                     });
                   },

                   child: Container(

                     padding:
                         const EdgeInsets.symmetric(
                       horizontal: 14,
                       vertical: 6,
                     ),

                     decoration: BoxDecoration(

                       color: isOnline
                           ? Colors.green.withAlpha(50)
                           : Colors.red.withAlpha(50),

                       borderRadius:
                           BorderRadius.circular(20),

                       border: Border.all(

                         color: isOnline
                             ? Colors.green
                             : Colors.red,
                       ),
                     ),

                     child: Row(

                       children: [

                         Container(

                           width: 8,
                           height: 8,

                           decoration: BoxDecoration(

                             color: isOnline
                                 ? Colors.green
                                 : Colors.red,

                             shape: BoxShape.circle,
                           ),
                         ),

                         const SizedBox(width: 8),

                         Text(

                           isOnline
                               ? 'Online'
                               : 'Offline',

                           style: TextStyle(

                             color: isOnline
                                 ? Colors.green
                                 : Colors.red,

                             fontWeight:
                                 FontWeight.bold,
                                 fontSize: 12,
                           ),
                         ),
                       ],
                     ),
                   ),
                 )
                ],
              ),

              GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfileSettingsScreen(),
                    ),
                  ).then((_) {

                    fetchUserData();
                  });
                },

                child: Container(
                  padding:
                      const EdgeInsets.all(
                          10),

                  decoration:
                      BoxDecoration(

                    gradient:
                        const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFE8F3FF),
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                            20),

                    boxShadow: [

                      BoxShadow(
                        color:
                            Colors.black
                                .withAlpha(40),

                        blurRadius: 12,

                        offset:
                            const Offset(
                                0, 4),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.person,

                    size: 26,

                    color:
                        Color(0xFF003856),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // ── NEW: STATS SECTION ──
    Widget _buildStatsSection() {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {

        return const SizedBox();
      }

      return StreamBuilder<QuerySnapshot>(

        stream:
            FirebaseFirestore.instance
                .collection('pickups')
                .where(
                  'agentId',
                  isEqualTo:
                      user.uid,
                )
                .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const SizedBox();
          }

          final docs =
              snapshot.data!.docs;

          final today =
              DateTime.now();

          int completedToday = 0;
          int pendingOrders = 0;
          int totalPickups = docs.length;

          for (var doc in docs) {

            final data =
                doc.data()
                    as Map<String,
                        dynamic>;

            final status =
                data['status']
                    ?.toString() ?? '';

            if (status == 'Confirmed') {

              pendingOrders++;
            }

            if (status == 'Completed') {

              final completedAt =
                  data['completedAt'];

              if (completedAt
                  is Timestamp) {

                final completedDate =
                    completedAt
                        .toDate();

                if (completedDate.year ==
                        today.year &&
                    completedDate.month ==
                        today.month &&
                    completedDate.day ==
                        today.day) {

                  completedToday++;
                }
              }
            }
          }

          return Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                'Overview',

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

              const SizedBox(height: 14),

              Row(

                children: [

                  Expanded(
                    child:
                        _buildStatCard(

                      label:
                          'Completed\nToday',

                      value:
                          completedToday
                              .toString(),

                      icon:
                          Icons.check_circle_outline,

                      iconColor:
                          const Color(
                              0xFF98C13F),

                      gradientColors:
                          isDarkMode.value

                              ? const [
                                  Color(
                                      0xFF2A2A2A),
                                  Color(
                                      0xFF1E1E1E),
                                ]

                              : const [
                                  Colors.white,
                                  Color(
                                      0xFFF8FFF0),
                                ],
                    ),
                  ),

                  const SizedBox(
                      width: 12),

                  Expanded(
                    child:
                        _buildStatCard(

                      label:
                          'Pending\nOrders',

                      value:
                          pendingOrders
                              .toString(),

                      icon:
                          Icons
                              .hourglass_empty_rounded,

                      iconColor:
                          const Color(
                              0xFFFFB347),

                      gradientColors:
                          isDarkMode.value

                              ? const [
                                  Color(
                                      0xFF2A2A2A),
                                  Color(
                                      0xFF1E1E1E),
                                ]

                              : const [
                                  Colors.white,
                                  Color(
                                      0xFFFFFBF0),
                                ],
                    ),
                  ),

                  const SizedBox(
                      width: 12),

                  Expanded(
                    child:
                        _buildStatCard(

                      label:
                          'Total\nPickups',

                      value:
                          totalPickups
                              .toString(),

                      icon:
                          Icons
                              .local_shipping_outlined,

                      iconColor:
                          const Color(
                              0xFF0077B6),

                      gradientColors:
                          isDarkMode.value

                              ? const [
                                  Color(
                                      0xFF2A2A2A),
                                  Color(
                                      0xFF1E1E1E),
                                ]

                              : const [
                                  Colors.white,
                                  Color(
                                      0xFFF0F8FF),
                                ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

      Widget _buildStatCard({
        required String label,
        required String value,
        required IconData icon,
        required Color iconColor,
        required List<Color> gradientColors,
      }) {

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withAlpha(18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode.value
                      ? Colors.white54
                      : Colors.black54,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      }

      /// SEARCH BAR
      Widget _buildSearchBar() {

        return Container(
          decoration: BoxDecoration(

            color:
                isDarkMode.value
                    ? const Color(
                        0xFF2A2A2A)
                    : Colors.white,

            borderRadius:
                BorderRadius.circular(20),

            boxShadow: [

              BoxShadow(
                color:
                    Colors.black
                        .withAlpha(20),

                blurRadius: 12,

                offset:
                    const Offset(0, 4),
              ),
            ],

            border: Border.all(
              color:
                  const Color(
                      0xFFE0E0E0),
            ),
          ),

          child: TextField(

            style: TextStyle(
              color:
                  isDarkMode.value
                      ? Colors.white
                      : Colors.black,
            ),

            decoration:
                InputDecoration(

              hintText:
                  lang.translate(
                      'search_orders'),

              border:
                  InputBorder.none,

              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 18,
              ),

              prefixIcon: Icon(
                Icons.search,

                color:
                    isDarkMode.value
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
          ),
        );
      }

      Widget _buildActivitySection() {

        final currentUser =
            FirebaseAuth.instance.currentUser;

        if (currentUser == null) {

          return const Center(
            child: Text(
              'Rider not logged in',
            ),
          );
        }

        return StreamBuilder<QuerySnapshot>(

          stream:
              FirebaseFirestore.instance
                  .collection('pickups')
                  .where(
                    'status',
                    isEqualTo: 'Confirmed',
                  )
                  .where(
                    'agentId',
                    isEqualTo:
                        currentUser.uid,
                  )
                  .snapshots(),

          builder: (context, snapshot) {

            if (!snapshot.hasData) {

              return const SizedBox();
            }

            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {

              return _buildNoActivityCard();
            }

            final docs =
                snapshot.data!.docs;

            docs.sort((a, b) {

              final dataA =
                  a.data()
                      as Map<String,
                          dynamic>;

              final dataB =
                  b.data()
                      as Map<String,
                          dynamic>;

              final dateA =
                  _getPickupDateTime(
                pickupDate:
                    dataA['pickupDate'],
                pickupTimeSlot:
                    dataA['pickupTimeSlot']
                        ?.toString() ?? '',
              );

              final dateB =
                  _getPickupDateTime(
                pickupDate:
                    dataB['pickupDate'],
                pickupTimeSlot:
                    dataB['pickupTimeSlot']
                        ?.toString() ?? '',
              );

              return dateA.compareTo(dateB);
            });

            final order =
                docs.first;

            final data =
                order.data()
                    as Map<String,
                        dynamic>;

            final address =
                data['addressDetails'];

            final pickupDateTime =
                _getPickupDateTime(
              pickupDate:
                  data['pickupDate'],
              pickupTimeSlot:
                  data['pickupTimeSlot']
                      ?.toString() ?? '',
            );

            final isUpcoming =
                currentTime.isBefore(
                    pickupDateTime);

            final remainingTime =
                pickupDateTime
                    .difference(
                        currentTime);

            return Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  lang.translate(
                      'today_activity'),

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                  ),
                ),

                const SizedBox(
                    height: 20),

                if (isUpcoming)
                  _buildUpcomingPickupCard(
                    data: data,
                    remainingTime:
                        remainingTime,
                  )
                else
                  _buildActivePickupCard(
                    order: order,
                    data: data,
                    address: address,
                  ),
              ],
            );
          },
        );
      }

      Widget _buildUpcomingPickupCard({
        required Map<String, dynamic> data,
        required Duration remainingTime,
      }) {

        return Container(

          width: double.infinity,

          padding:
              const EdgeInsets.all(22),

          decoration: BoxDecoration(

            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF003856),
                Color(0xFF005B8F),
              ],
            ),

            borderRadius:
                BorderRadius.circular(24),

            boxShadow: [

              BoxShadow(
                color:
                    Colors.black.withAlpha(30),

                blurRadius: 15,

                offset:
                    const Offset(0, 6),
              ),
            ],
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                children: const [

                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: 28,
                  ),

                  SizedBox(width: 10),

                  Text(
                    'Upcoming Order',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                'Pickup starts in:',

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _formatDuration(
                    remainingTime),

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'Customer: ${data['customerName'] ?? 'Customer'}',

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Pickup Date: ${formatDate(data['pickupDate'])}',

                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Pickup Time: ${data['pickupTimeSlot'] ?? ''}',

                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildActivePickupCard({
        required QueryDocumentSnapshot order,
        required Map<String, dynamic> data,
        required dynamic address,
      }) {

        return GestureDetector(

          onTap: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>

                    OrderDetailsScreen(

                  pickupAddress:
                      address?['fullAddress']
                              ?.toString() ??
                          '',

                  dropAddress:
                      'Revive EcoTech',

                  pickupDate:
                      formatDate(
                          data['pickupDate']),

                  pickupTime:
                      data['pickupTimeSlot']
                              ?.toString() ??
                          '',

                  customerPhone:
                      data['customerPhone']
                              ?.toString() ??
                          '',

                  scrapItems:
                      data['scrapCategories']
                              as List? ??
                          [],

                  orderId: order.id,

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

          child: Container(

            padding:
                const EdgeInsets.all(20),

            decoration:
                BoxDecoration(

              gradient:
                  const LinearGradient(

                begin:
                    Alignment.topLeft,

                end:
                    Alignment.bottomRight,

                colors: [

                  Color(0xFFB5D178),
                  Color(0xFF98C13F),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                      24),

              boxShadow: [

                BoxShadow(

                  color:
                      Colors.black
                          .withAlpha(
                              30),

                  blurRadius: 15,

                  offset:
                      const Offset(
                          0, 6),
                ),
              ],
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Row(
                  children: const [

                    Icon(
                      Icons.local_shipping,
                      size: 28,
                      color: Colors.black,
                    ),

                    SizedBox(width: 10),

                    Text(

                      'Active Pickup',

                      style:
                          TextStyle(

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 20),

                Text(
                  'Customer: ${data['customerName'] ?? 'Customer'}',
                ),

                const SizedBox(
                    height: 10),

                Text(
                  'Scrap Categories: ${(data['scrapCategories'] as List).join(', ')}',
                ),

                const SizedBox(
                    height: 10),

                Text(
                  'Pickup Address: ${address?['fullAddress'] ?? ''}',
                ),

                const SizedBox(
                    height: 10),

                Text(
                  'Pickup Date: ${formatDate(data['pickupDate'])}',
                ),

                const SizedBox(
                    height: 10),

                Text(
                  'Pickup Time: ${data['pickupTimeSlot'] ?? ''}',
                ),

                const SizedBox(
                    height: 25),

                Container(

                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 16,
                  ),

                  decoration:
                      BoxDecoration(

                    gradient:
                        const LinearGradient(
                      colors: [

                        Color(0xFF003856),
                        Color(0xFF005B8F),
                      ],
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                                16),
                  ),

                  child: Center(

                    child: Text(

                      lang.translate(
                          'start_pickup'),

                      style:
                          const TextStyle(

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
            ),
          ),
        );
      }

      Widget _buildNoActivityCard() {

        return Container(

          width: double.infinity,

          padding:
              const EdgeInsets.all(30),

          decoration: BoxDecoration(

            color:
                isDarkMode.value
                    ? const Color(
                        0xFF2A2A2A)
                    : Colors.white,

            borderRadius:
                BorderRadius.circular(24),

            boxShadow: [

              BoxShadow(
                color:
                    Colors.black
                        .withAlpha(15),

                blurRadius: 10,

                offset:
                    const Offset(0, 4),
              ),
            ],
          ),

          child: Column(

            children: [

              Icon(
                Icons.event_busy,

                size: 60,

                color:
                    isDarkMode.value
                        ? Colors.white70
                        : Colors.black54,
              ),

              const SizedBox(height: 20),

              Text(

                'No Activity Today',

                style: TextStyle(

                  fontSize: 22,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildBottomNavBar() {

        return Container(
          margin:
              const EdgeInsets.all(20),

          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),

          decoration: BoxDecoration(

            gradient:
                isDarkMode.value

                    ? const LinearGradient(
                        colors: [
                          Color(0xFF2A2A2A),
                          Color(0xFF1E1E1E),
                        ],
                      )

                    : const LinearGradient(
                        colors: [
                          Color(0xFFB5D178),
                          Color(0xFF98C13F),
                        ],
                      ),

            borderRadius:
                BorderRadius.circular(30),

            boxShadow: [

              BoxShadow(
                color:
                    Colors.black
                        .withAlpha(35),

                blurRadius: 15,

                offset:
                    const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,

            children: [

              _buildNavItem(
                icon: Icons.home,
                index: 0,
                label: lang.translate('home'),
              ),

              _buildNavItem(
                icon: Icons.shopping_bag,
                index: 1,
                label: lang.translate('orders'),
              ),

              _buildNavItem(
                icon: Icons.history,
                index: 2,
                label: lang.translate('history'),
              ),

              _buildNavItem(
                icon: Icons.settings,
                index: 3,
                label: lang.translate('settings'),
              ),
            ],
          ),
        );
      }

      Widget _buildNavItem({
        required IconData icon,
        required int index,
        required String label,
      }) {

        final isSelected =
            _selectedIndex == index;

        return GestureDetector(
          onTap: () {

            setState(() {

              _selectedIndex = index;
            });

            if (index == 1) {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const OrdersScreen(),
                ),
              ).then((_) {

                setState(() {

                  _selectedIndex = 0;
                });
              });
            }

            if (index == 2) {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const OrderHistoryScreen(),
                ),
              ).then((_) {

                setState(() {

                  _selectedIndex = 0;
                });
              });
            }

            if (index == 3) {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const SettingsScreen(),
                ),
              ).then((_) {

                setState(() {

                  _selectedIndex = 0;
                });
              });
            }
          },

          child: AnimatedContainer(
            duration:
                const Duration(
                    milliseconds: 250),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),

            decoration: BoxDecoration(

              color: isSelected
                  ? Colors.white
                  : Colors.transparent,

              borderRadius:
                  BorderRadius.circular(
                      20),
            ),

            child: Row(
              children: [

                Icon(
                  icon,

                  color: isSelected
                      ? Colors.black
                      : const Color(
                          0xFF003856),
                ),

                if (isSelected)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                            left: 8),

                    child: Text(
                      label,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    }
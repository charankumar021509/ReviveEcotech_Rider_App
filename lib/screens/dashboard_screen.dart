import 'package:flutter/material.dart';

import 'package:reviveecotech_rider/screens/profile_settings_screen.dart';
import 'package:reviveecotech_rider/screens/order_details_screen.dart';
import 'package:reviveecotech_rider/screens/orders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFCF3E3),

      body: Column(
        children: [

          // HEADER
          Container(
            height: 250,
            width: double.infinity,

            decoration:
                const BoxDecoration(
              color:
                  Color(0xFF003856),

              borderRadius:
                  BorderRadius.only(
                bottomLeft:
                    Radius.circular(60),
                bottomRight:
                    Radius.circular(60),
              ),
            ),

            child:
                _buildHeaderContent(),
          ),

          // BODY
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

                    // IMAGE BANNER
                    Container(
                      height: 190,
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
                                        60),

                            blurRadius: 12,

                            offset:
                                const Offset(
                                    0, 6),
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
                                      140),
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
                                    Colors
                                        .white,

                                fontSize:
                                    28,

                                fontWeight:
                                    FontWeight
                                        .bold,

                                fontFamily:
                                    'RedHatDisplay',
                              ),
                            ),

                            SizedBox(
                                height: 8),

                            Text(
                              'Smart Recycling Pickup System',

                              style:
                                  TextStyle(
                                color: Colors
                                    .white70,

                                fontSize:
                                    16,

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

                    Container(
                      padding:
                          const EdgeInsets
                              .all(20),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                                    20),
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
  }

  // HEADER
  Widget _buildHeaderContent() {

    return Stack(
      children: [

        Positioned(
          top: 50,
          left: 30,
          right: 30,

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: const [

                  Text(
                    'Welcome back',

                    style: TextStyle(
                      color:
                          Colors.white70,

                      fontSize: 18,

                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Bhai',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontWeight:
                          FontWeight.bold,

                      fontFamily:
                          'RedHatDisplay',
                    ),
                  ),
                ],
              ),

              GestureDetector(
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

                child:
                    const CircleAvatar(
                  radius: 38,

                  backgroundColor:
                      Color(0xFFFCF3E3),

                  child: Icon(
                    Icons.person,
                    size: 45,

                    color:
                        Color(0xFF003856),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,

          child: Center(
            child: Image.asset(
              'assets/images/globe_picture.jpg',
              width: 180,
            ),
          ),
        ),
      ],
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar() {

    return Container(
      decoration: BoxDecoration(
        color:
            const Color(0xFF2C2C2C),

        borderRadius:
            BorderRadius.circular(
                15),
      ),

      child: const TextField(
        style: TextStyle(
            color: Colors.white),

        decoration: InputDecoration(
          hintText: 'Search here',

          hintStyle: TextStyle(
              color: Colors.white54),

          prefixIcon: Icon(
            Icons.search,

            color: Colors.white54,
          ),

          border: InputBorder.none,

          contentPadding:
              EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
        ),
      ),
    );
  }

  // ACTIVITY SECTION
  Widget _buildActivitySection() {

    return Column(
      children: [

        const Text(
          'Activity',

          style: TextStyle(
            fontSize: 26,
            fontWeight:
                FontWeight.bold,

            fontFamily:
                'RedHatDisplay',
          ),
        ),

        const SizedBox(height: 25),

        _buildActivityItem(),
      ],
    );
  }

  // ACTIVITY ITEM
  Widget _buildActivityItem() {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
            const Color(0xC8A6CB4E),

        borderRadius:
            BorderRadius.circular(
                20),
      ),

      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: const [

                Text(
                  'Rahul Sharma',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,

                    fontSize: 18,

                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Pickup Time: 10:30 AM',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Sector 21, Gandhinagar',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  '12.5 KG - Paper',

                  style: TextStyle(
                    fontFamily:
                        'RedHatDisplay',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder:
                      (context) =>
                          const OrderDetailsScreen(),
                ),
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.white,

              foregroundColor:
                  Colors.black,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
            ),

            child:
                const Text('Details'),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVBAR
  Widget _buildBottomNavBar() {

    final navBarItems = [

      {
        'icon': Icons.dashboard,
        'label': 'Dashboard'
      },

      {
        'icon':
            Icons.shopping_bag,
        'label': 'Orders'
      },

      {
        'icon': Icons.person,
        'label': 'Profile'
      },
    ];

    return Container(
      margin:
          const EdgeInsets.all(20),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color:
            const Color(0xC8A6CB4E),

        borderRadius:
            BorderRadius.circular(
                25),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: List.generate(
          navBarItems.length,
          (index) {

            final item =
                navBarItems[index];

            final isSelected =
                _selectedIndex ==
                    index;

            return GestureDetector(

              onTap: () {

                setState(() {

                  _selectedIndex =
                      index;
                });

                if (index == 1) {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const OrdersScreen(),
                    ),
                  );
                }

                if (index == 2) {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const ProfileSettingsScreen(),
                    ),
                  );
                }
              },

              child: isSelected

                  ? Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            20,
                        vertical:
                            10,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            item['icon']
                                as IconData,

                            color:
                                Colors.black,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            item['label']
                                as String,

                            style:
                                const TextStyle(
                              color:
                                  Colors.black,

                              fontFamily:
                                  'RedHatDisplay',
                            ),
                          ),
                        ],
                      ),
                    )

                  : Icon(
                      item['icon']
                          as IconData,

                      color:
                          const Color(
                              0xFF003856),

                      size: 30,
                    ),
            );
          },
        ),
      ),
    );
  }
}
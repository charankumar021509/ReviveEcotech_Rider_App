import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  // ✅ PROFILE IMAGE
  File? _profileImage;

  // ✅ Controllers
  final TextEditingController _firstNameController =
      TextEditingController(text: 'bhai');

  final TextEditingController _lastNameController =
      TextEditingController(text: 'ji');

  final TextEditingController _phoneController =
      TextEditingController(text: '123456789');

  final TextEditingController _emailController =
      TextEditingController(text: 'abc@gmail.com');

  final TextEditingController _addressController =
      TextEditingController(
          text: 'Madhurawada, Endada Road');

  int _selectedIndex = 2;

  // ✅ PICK IMAGE FUNCTION
  Future<void> _pickImage() async {

    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {

        _profileImage =
            File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFFCF3E3),

      resizeToAvoidBottomInset: true,

      body: Column(
        children: [

          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 25,
              ),

              child: Column(
                children: [

                  _buildEditField(
                    'First Name',
                    _firstNameController,
                  ),

                  const SizedBox(height: 20),

                  _buildEditField(
                    'Last Name',
                    _lastNameController,
                  ),

                  const SizedBox(height: 20),

                  _buildEditField(
                    'Phone no.',
                    _phoneController,

                    keyboardType:
                        TextInputType.phone,
                  ),

                  const SizedBox(height: 20),

                  _buildEditField(
                    'Mail',
                    _emailController,

                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  _buildEditField(
                    'Address',
                    _addressController,
                  ),

                  const SizedBox(height: 35),

                  // 🟢 SAVE BUTTON
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),

                    child: SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.pop(context, {

                            'fname':
                                _firstNameController.text,

                            'lname':
                                _lastNameController.text,

                            'phone':
                                _phoneController.text,

                            'email':
                                _emailController.text,

                            'address':
                                _addressController.text,

                            'image':
                                _profileImage,
                          });
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF98C13F,
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    50),
                          ),

                          elevation: 8,
                          shadowColor:
                              Colors.black,
                        ),

                        child: const Text(
                          'Save Changes',

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,

                            color: Colors.white,

                            fontFamily:
                                'RedHatDisplay',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar:
          _buildBottomNavBar(),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(
      BuildContext context) {

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: const Color(0xFF003856),

        borderRadius:
            const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight:
              Radius.circular(50),
        ),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withAlpha(80),

            blurRadius: 20,
            spreadRadius: 2,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      padding:
          const EdgeInsets.fromLTRB(
        20,
        60,
        20,
        40,
      ),

      child: Column(
        children: [

          Row(
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
                    Navigator.pop(context),
              ),

              const Text(
                'Edit Profile',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'RedHatDisplay',
                ),
              ),

              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ PROFILE IMAGE
          Stack(
            alignment:
                Alignment.bottomRight,

            children: [

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withAlpha(180),

                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),

                child: CircleAvatar(
                  radius: 65,

                  backgroundColor:
                      const Color(
                    0xFFFCF3E3,
                  ),

                  backgroundImage:
                      _profileImage != null
                          ? FileImage(
                              _profileImage!,
                            )
                          : null,

                  child:
                      _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 75,

                              color: Color(
                                0xFF003856,
                              ),
                            )
                          : null,
                ),
              ),

              // ✅ PICK IMAGE
              GestureDetector(
                onTap: _pickImage,

                child: Container(
                  padding:
                      const EdgeInsets.all(
                          8),

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFF007BFF),

                    shape:
                        BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= INPUT FIELDS =================
  Widget _buildEditField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Padding(
          padding:
              const EdgeInsets.only(
            left: 30,
            bottom: 8,
          ),

          child: Text(
            label,

            style: const TextStyle(
              color: Color(0xFF98C13F),

              fontWeight:
                  FontWeight.bold,

              fontSize: 16,

              fontFamily:
                  'RedHatDisplay',
            ),
          ),
        ),

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 15,
          ),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                      50),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withAlpha(76),

                  spreadRadius: 2,
                  blurRadius: 10,

                  offset:
                      const Offset(0, 4),
                ),
              ],
            ),

            child: TextField(
              controller: controller,

              keyboardType:
                  keyboardType,

              style: const TextStyle(
                color:
                    Color(0xFF003856),

                fontWeight:
                    FontWeight.w800,

                fontSize: 18,

                fontFamily:
                    'RedHatDisplay',
              ),

              decoration:
                  const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),

                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= BOTTOM NAV BAR =================
  Widget _buildBottomNavBar() {

    final navBarItems = [

      {
        'icon': Icons.dashboard,
        'label': 'Dashboard'
      },

      {
        'icon': Icons.wallet_travel,
        'label': 'Wallet'
      },

      {
        'icon': Icons.settings,
        'label': 'Settings'
      },

      {
        'icon': Icons.history,
        'label': 'History'
      },
    ];

    return Container(
      margin: const EdgeInsets.all(15),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color:
            const Color(0xFFB5D178),

        borderRadius:
            BorderRadius.circular(35),
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

                setState(() =>
                    _selectedIndex =
                        index);
              },

              child: isSelected
                  ? Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                                25),
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
                              fontWeight:
                                  FontWeight.bold,

                              fontFamily:
                                  'RedHatDisplay',
                            ),
                          ),
                        ],
                      ),
                    )

                  : Padding(
                      padding:
                          const EdgeInsets
                              .all(10.0),

                      child: Icon(
                        item['icon']
                            as IconData,

                        color:
                            const Color(
                                0xFF003856),

                        size: 28,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {

    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();

    super.dispose();
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'theme_controller.dart';
import '../localization/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  String tr(String key) {

    return AppLocalizations.of(
      context,
    ).translate(key);
  }

  File? _profileImage;

  final TextEditingController _firstNameController =
      TextEditingController();

  final TextEditingController _lastNameController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _addressController =
      TextEditingController();

  @override
  void initState() {

    super.initState();

    _loadUserData();
  }

  Future<void> _loadUserData() async {

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

            _firstNameController.text =
                doc['name'] ?? '';

            _emailController.text =
                doc['email'] ?? '';

            _phoneController.text =
                doc['phone'] ?? '';

            _addressController.text =
                doc['address'] ?? '';
          });
        }
      }
    } catch (e) {

      debugPrint(
        "Load User Error: $e",
      );
    }
  }

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

    return ValueListenableBuilder(
      valueListenable: isDarkMode,

      builder: (context, value, child) {

        return Scaffold(

          backgroundColor:
              isDarkMode.value
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFFCF3E3),

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
                        tr('first_name'),
                        _firstNameController,
                      ),

                      const SizedBox(height: 20),

                      _buildEditField(
                        tr('last_name'),
                        _lastNameController,
                      ),

                      const SizedBox(height: 20),

                      _buildEditField(
                        tr('phone_number'),
                        _phoneController,

                        keyboardType:
                            TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      _buildEditField(
                        tr('mail'),
                        _emailController,

                        keyboardType:
                            TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      _buildEditField(
                        tr('address'),
                        _addressController,
                      ),

                      const SizedBox(height: 35),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),

                        child: SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: () async {

                              try {

                                final user =
                                    FirebaseAuth.instance.currentUser;

                                if (user != null) {

                                  await FirebaseFirestore.instance
                                      .collection('agents')
                                      .doc(user.uid)
                                      .update({

                                    'name':
                                        _firstNameController.text.trim(),

                                    'email':
                                        _emailController.text.trim(),

                                    'phone':
                                        _phoneController.text.trim(),

                                    'address':
                                        _addressController.text.trim(),
                                  });

                                  if (!mounted) return;

                                  Navigator.pop(context, {
                                    'fname':
                                        _firstNameController.text.trim(),

                                    'lname':
                                        _lastNameController.text.trim(),

                                    'email':
                                        _emailController.text.trim(),

                                    'image':
                                        _profileImage?.path,
                                  });
                                }
                              } catch (e) {

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  SnackBar(
                                    content: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }
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

                            child: Text(
                              tr('save_changes'),

                              style: const TextStyle(
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
        );
      },
    );
  }

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

              Text(
                tr('edit_profile'),

                style: const TextStyle(
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
                      isDarkMode.value
                          ? const Color(
                              0xFF2A2A2A)
                          : const Color(
                              0xFFFCF3E3),

                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!)
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

              color:
                  isDarkMode.value
                      ? const Color(
                          0xFF2A2A2A)
                      : Colors.white,

              borderRadius:
                  BorderRadius.circular(
                      50),
            ),

            child: TextField(
              controller: controller,

              keyboardType:
                  keyboardType,

              style: TextStyle(
                color:
                    isDarkMode.value
                        ? Colors.white
                        : const Color(
                            0xFF003856),

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
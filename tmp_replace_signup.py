import sys

def update_signup_screen():
    file_path = "lib/screens/signup_screen.dart"
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    start_marker = "  @override\n  Widget build(BuildContext context) {"
    end_marker = "  @override\n  void dispose() {"
    
    start_idx = content.find(start_marker)
    end_idx = content.find(end_marker)
    
    if start_idx == -1 or end_idx == -1:
        print("Error: Could not find markers in signup_screen.dart")
        return
        
    replacement = """  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, dynamic value, child) {
        final bool isDark = value;
        final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final textColor = isDark ? Colors.white : const Color(0xFF0B132B);
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final inputFillColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
        
        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/revive_logo.jpg',
                            width: 250,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          tr('sign_up'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr('future_text'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor.withAlpha(180),
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // FULL NAME
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: textColor),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: inputFillColor,
                            hintText: tr('full_name'),
                            hintStyle: TextStyle(color: textColor.withAlpha(150), fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF10B981)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // EMAIL
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: inputFillColor,
                            hintText: tr('email'),
                            hintStyle: TextStyle(color: textColor.withAlpha(150), fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF10B981)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // PASSWORD
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: inputFillColor,
                            hintText: tr('password'),
                            hintStyle: TextStyle(color: textColor.withAlpha(150), fontWeight: FontWeight.w500),
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF10B981)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // SIGNUP BUTTON
                        ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                              return;
                            }
                            setState(() => _isLoading = true);
                            try {
                              final user = await _authService.signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                name: _nameController.text.trim(),
                              );
                              if (user != null) {
                                await FirebaseFirestore.instance.collection('agents').doc(user.uid).set({
                                  'name': _nameController.text.trim(),
                                  'email': _emailController.text.trim(),
                                  'uid': user.uid,
                                });
                                if (!mounted) return;
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerifyEmailScreen()));
                              }
                            } catch (e) {
                              String message = 'Signup Failed';
                              if (e is FirebaseAuthException) { message = e.message ?? 'Signup Failed'; } else { message = e.toString(); }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            elevation: 4,
                            shadowColor: const Color(0xFF10B981).withAlpha(120),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  tr('sign_up'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'RedHatDisplay',
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                tr('or_connect'),
                                style: TextStyle(
                                  color: textColor.withAlpha(180),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RedHatDisplay',
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12, thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    final userCredential = await _authService.signInWithGoogle();
                                    if (userCredential != null) {
                                      if (!mounted) return;
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  } finally {
                                    if (mounted) setState(() => _isLoading = false);
                                  }
                                },
                                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 20),
                                label: Text(tr('google'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: FaIcon(FontAwesomeIcons.apple, color: textColor, size: 22),
                                label: Text(tr('apple'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('already_account'),
                              style: TextStyle(color: textColor.withAlpha(200)),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                              child: Text(
                                tr('login'),
                                style: const TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

"""
    new_content = content[:start_idx] + replacement + content[end_idx:]
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("Updated signup_screen.dart")

update_signup_screen()

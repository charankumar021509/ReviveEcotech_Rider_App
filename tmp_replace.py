import sys

def update_login_screen():
    file_path = "lib/screens/login_screen.dart"
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    start_marker = "  @override\n  Widget build(BuildContext context) {"
    end_marker = "  @override\n  void dispose() {"
    
    start_idx = content.find(start_marker)
    end_idx = content.find(end_marker)
    
    if start_idx == -1 or end_idx == -1:
        print("Error: Could not find markers in login_screen.dart")
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
                          tr('login_account'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                        
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
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
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              if (_emailController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter email first')));
                                return;
                              }
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            },
                            child: Text(
                              tr('forget_password'),
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        ElevatedButton(
                          onPressed: () async {
                            if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
                              return;
                            }
                            setState(() => _isLoading = true);
                            try {
                              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                              final token = await NotificationService.getToken();
                              if (token != null) {
                                await FirebaseFirestore.instance.collection('agents').doc(credential.user!.uid).set(
                                  {'fcmToken': token}, SetOptions(merge: true)
                                );
                              }
                              if (!mounted) return;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                            } catch (e) {
                              // If it's FirebaseAuthException we can get message, otherwise just stringify
                              String message = 'Login Failed';
                              if (e is FirebaseAuthException) {
                                message = e.message ?? 'Login Failed';
                              } else {
                                message = e.toString();
                              }
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
                                  tr('login'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'RedHatDisplay',
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        
                        OutlinedButton.icon(
                          onPressed: () async {
                            final user = await _authService.signInWithGoogle();
                            if (user != null) {
                              if (!mounted) return;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: Text(
                            tr('google'),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RedHatDisplay',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr('dont_have_account'),
                              style: TextStyle(color: textColor.withAlpha(200)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                              },
                              child: Text(
                                tr('sign_up'),
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
    print("Updated login_screen.dart")

update_login_screen()

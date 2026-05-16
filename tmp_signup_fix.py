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
    return Scaffold(
      backgroundColor: const Color(0xFF003856), // Dark Top Background
      body: Stack(
        children: [
          // Background Leaves placeholder / Logo
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/revive_logo.png', // Try png if available, fallback to what exists
                width: 260,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/revive_logo.jpg',
                  width: 260,
                ),
              ),
            ),
          ),
          
          // Bottom White Rounded Container
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFCF3E3), // Cream Background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'RedHatDisplay',
                        color: const Color(0xFF003856),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Become the part of our future',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'RedHatDisplay',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Full Name
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF3E3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF679B3D)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Email
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF3E3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                          prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF679B3D)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF3E3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF679B3D)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF679B3D),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Sign Up Button
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
                        backgroundColor: const Color(0xFF5A8E22), // Solid dark green
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        shadowColor: const Color(0xFF5A8E22).withAlpha(100),
                      ),
                      child: _isLoading 
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'RedHatDisplay',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    
                    // OR divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black.withAlpha(30), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'RedHatDisplay',
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.black.withAlpha(30), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Social Login
                    ElevatedButton.icon(
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
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 22),
                      label: const Text(
                        'Sign up with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'RedHatDisplay',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 2,
                        shadowColor: Colors.black.withAlpha(20),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // LOGIN LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF5A8E22),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
"""
    new_content = content[:start_idx] + replacement + content[end_idx:]
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("Updated signup_screen.dart")

update_signup_screen()

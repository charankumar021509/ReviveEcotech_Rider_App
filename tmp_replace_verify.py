import sys

def update_verify_email_screen():
    file_path = "lib/screens/verify_email_screen.dart"
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # ADD IMPORT
    if "import 'theme_controller.dart';" not in content:
        content = content.replace("import 'package:reviveecotech_rider/screens/dashboard_screen.dart';", "import 'package:reviveecotech_rider/screens/dashboard_screen.dart';\nimport 'theme_controller.dart';")

    start_marker = "  @override\n  Widget build(BuildContext context) {"
    end_marker = "}\n" # since it's the end of file, we can just find it this way
    
    start_idx = content.find(start_marker)
    # the last '}'
    end_idx = content.rfind('}')
    
    if start_idx == -1:
        print("Error: Could not find build method")
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
                      children: [
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.mark_email_read_outlined,
                          size: 70,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'VERIFY YOUR E-MAIL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'RedHatDisplay',
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'We have sent a verification link to\\n${user?.email}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            fontFamily: 'RedHatDisplay',
                            color: textColor.withAlpha(180),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _checkVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF10B981).withAlpha(120),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              "I have verified",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _secondsRemaining == 0 ? _resendEmail : null,
                                child: Text(
                                  'Resend Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RedHatDisplay',
                                    color: _secondsRemaining == 0
                                        ? const Color(0xFF10B981)
                                        : textColor.withAlpha(100),
                                  ),
                                ),
                              ),
                              Text(
                                '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RedHatDisplay',
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
"""
    new_content = content[:start_idx] + replacement + "}\n"
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("Updated verify_email_screen.dart")

update_verify_email_screen()

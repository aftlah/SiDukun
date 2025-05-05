import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool isPhoneLogin = false;
  String? _verificationId;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_convertToIndonesianFormat);

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

  void _convertToIndonesianFormat() {
    final current = phoneController.text;
    if (current.startsWith('0')) {
      final newText = current.replaceFirst('0', '+62 ');
      phoneController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  void _loginWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackBar('Email dan password tidak boleh kosong');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        setState(() {
          isLoading = false;
        });

        _showSuccessSnackBar('Login berhasil! Selamat datang di SiDukun.');
        // Add delay before navigation to show the success message
        Future.delayed(const Duration(seconds: 0), () {
          _navigateToDashboard();
        });
        
      } else {
        _showErrorSnackBar('Login email gagal');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loginWithPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _showErrorSnackBar('Masukkan nomor HP');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setState(() {
            isLoading = false;
          });
          _showSuccessSnackBar('Login berhasil! Selamat datang kembali.');
          Future.delayed(const Duration(seconds: 0), () {
            _navigateToDashboard();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          _showErrorSnackBar('Verifikasi gagal: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            isLoading = false;
          });
          _showOTPDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showOTPDialog() {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Masukkan Kode OTP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kode verifikasi telah dikirim ke nomor Anda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              maxLength: 6,
              decoration: InputDecoration(
                counterText: '',
                hintText: '------',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Colors.blue[900] ?? Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Colors.blue[900] ?? Colors.blueGrey, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child:  Text(
              'Batal',
              style: TextStyle(color: Colors.blue[900]),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child:
                Text('Verifikasi', style: TextStyle(color: Colors.blue[900])),
            onPressed: () async {
              final smsCode = otpController.text.trim();
              if (_verificationId != null && smsCode.isNotEmpty) {
                final credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId!,
                  smsCode: smsCode,
                );
                try {
                  await _auth.signInWithCredential(credential);
                  Navigator.pop(context); // Close dialog
                  _showSuccessSnackBar(
                      'Login berhasil! Selamat datang kembali.');
                  Future.delayed(const Duration(seconds: 1), () {
                    _navigateToDashboard();
                  });
                } catch (e) {
                  _showErrorSnackBar('OTP salah');
                }
              }
            },
          )
        ],
      ),
    );
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _toggleLoginMode() {
    setState(() {
      isPhoneLogin = !isPhoneLogin;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.removeListener(_convertToIndonesianFormat);
    phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo or App Name
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[900]!.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 60,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Column(
                  children: [
                    Text(
                      'Login SiDukun',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '(Sistem Informasi Data Kependudukan)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blue[900]!.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  isPhoneLogin
                      ? 'Masuk dengan nomor HP Anda'
                      : 'Masuk dengan email dan password Anda',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 20),

                // Login Form
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      if (!isPhoneLogin) ...[
                        // Email Input
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        // Password Input
                        _buildTextField(
                          controller: passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                      ] else ...[
                        // Phone Input
                        _buildTextField(
                          controller: phoneController,
                          label: 'Nomor HP',
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : (isPhoneLogin
                                  ? _loginWithPhone
                                  : _loginWithEmail),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Toggle Login Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isPhoneLogin
                          ? 'Ingin login dengan email?'
                          : 'Ingin login dengan nomor HP?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: _toggleLoginMode,
                      child: Text(
                        isPhoneLogin ? 'Login Email' : 'Login Nomor HP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Colors.blue[900]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

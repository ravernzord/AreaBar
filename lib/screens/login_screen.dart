import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;

  // Function to send OTP
  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _navigateToHome();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  // Function to manually enter OTP
  Future<void> _signInWithOtp() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text,
    );
    await _auth.signInWithCredential(credential);
    _navigateToHome();
  }

  // Navigate to Home screen after successful login
  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50), // Add spacing at the top

              // Tagline
              const Text(
                "Join the conversation, pick a side",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,  // Black text for tagline
                ),
              ),

              const SizedBox(height: 40),

              // Phone Number Input
              const Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone, color: Colors.black), // Black icon
                  hintText: '+1234567890',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black), // Black text for input
              ),
              const SizedBox(height: 20),

              // Send OTP Button
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  // Black button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Send OTP",
                  style: TextStyle(fontSize: 16, color: Colors.white),  // White text for contrast
                ),
              ),
              const SizedBox(height: 30),

              // OTP Input
              const Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black), // Black icon
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black), // Black text for input
              ),
              const SizedBox(height: 20),

              // Verify OTP Button
              ElevatedButton(
                onPressed: _signInWithOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  // Black button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Verify & Sign In",
                  style: TextStyle(fontSize: 16, color: Colors.white),  // White text for contrast
                ),
              ),

              const SizedBox(height: 20),

              // Footer Text
              const Text(
                'Don’t share your OTP with anyone!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

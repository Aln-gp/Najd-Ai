import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  void _handleLogin(Future<dynamic> loginMethod) async {
    setState(() => _isLoading = true);
    var user = await loginMethod;
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل الدخول، حاول مرة ثانية يا بعد حيي.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('نجد AI 🌾', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 10),
              const Text('المجلس الافتراضي والـفـزعـة الـرقـمـيـة', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40),
              if (_isLoading) const CircularProgressIndicator(color: Colors.amber)
              else ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                  label: const Text('الدخول عبر قوقل', style: TextStyle(fontSize: 18, color: Colors.white)),
                  onPressed: () => _handleLogin(_auth.signInWithGoogle()),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => _handleLogin(_auth.signInAsGuest()),
                  child: const Text('الدخول كـ ضيف 👤', style: TextStyle(fontSize: 16, color: Colors.amber)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

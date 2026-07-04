import 'package:flutter/material.dart';
import 'majlis_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  // دالة للانتقال السريع إلى المجلس بعد نجاح الدخول أو الدخول كمجهول
  void _navigateToMajlis() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MajlisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4), // هوية نجد الهادئة
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار تطبيق نجد الهيبّي
              Icon(Icons.blur_on, size: 90, color: Colors.green[800]),
              const SizedBox(height: 10),
              Text(
                'منصة Najd AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'بناء الأنظمة، المواقع، الألعاب، والتطبيقات 🚀',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // صندوق حقول الإدخال
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // حقل البريد الإلكتروني
                      TextField(
                        controller: _emailController,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // حقل الرقم السري
                      TextField(
                        controller: _passwordController,
                        textAlign: TextAlign.right,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'كلمة السر',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      
                      // زر نسيان كلمة السر
                      if (!_isSignUp)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('جاري إرسال رابط استعادة كلمة السر للإيميل... 🔑')),
                              );
                            },
                            child: const Text('نسيت كلمة السر؟', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      const SizedBox(height: 10),

                      // زر الدخول / إنشاء الحساب الرئيسي
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _navigateToMajlis,
                          child: Text(
                            _isSignUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                      // التبديل بين الدخول وإنشاء حساب
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          _isSignUp ? 'لديك حساب بالفعل؟ سجل دخولك' : 'ليس لديك حساب؟ أنشئ حساباً الآن',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // خط فاصل لطرق الدخول الأخرى
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('أو سجل عبر', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // أزرار قوقل والهاتف
              Row(
                children: [
                  // تسجيل عبر قوقل
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                      label: const Text('Google', style: TextStyle(color: Colors.black87)),
                      onPressed: _navigateToMajlis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // تسجيل عبر الهاتف
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.phone_android, color: Colors.blue),
                      label: const Text('رقم الهاتف', style: TextStyle(color: Colors.black87)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('طلب كود التحقق SMS... 💬')),
                        );
                        _navigateToMajlis();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // [ميزة الكرم] زر الدخول كـ مجهول (ضيف) بدون قيود
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.person_outline),
                  label: const Text(
                    'الدخول كـ مجهول (مجلس الجود) 🌾',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _navigateToMajlis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

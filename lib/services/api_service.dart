import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiService {
  static const String openRouterKey = String.fromEnvironment('OPENROUTER_KEY');
  static const String firebaseKey = String.fromEnvironment('FIREBASE_KEY');

  static const String dashboardUrl = 'https://your-firebase-project.firebaseio.com/app_status.json?auth=$firebaseKey';
  static const String openRouterUrl = 'https://openrouter.ai/api/v1/chat/completions';

  static Future<bool> checkAppStatus() async {
    try {
      final response = await http.get(Uri.parse(dashboardUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_active'] ?? true;
      }
    } catch (e) {
      print("خطأ في لوحة التحكم: $e");
    }
    return true;
  }

  // الدالة المطورة لإرسال النص مع صورة (اختيارية)
  static Future<String> askNajdAI(String prompt, {String? imageBase64}) async {
    try {
      // تجهيز محتوى الرسالة بشكل مرن (نص فقط أو نص وصورة)
      List<Map<String, dynamic>> userMessageContent = [
        {'type': 'text', 'text': prompt}
      ];

      if (imageBase64 != null) {
        userMessageContent.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$imageBase64'
          }
        });
      }

      final response = await http.post(
        Uri.parse(openRouterUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openRouterKey',
          'HTTP-Referer': 'https://github.com/najd-ai',
          'X-Title': 'Najd AI App',
        },
        body: jsonEncode({
          // تم ترقية الموديل ليدعم الرؤية (Vision) وقراءة الصور والملفات تلقائياً
          'model': 'google/gemini-2.5-flash', 
          'messages': [
            {
              'role': 'system', 
              'content': 'أنت نجد AI، فزعة بلهجة بدوية وعامية حماسية تساعد في الكود، القصيد، تحليل الصور، وقراءة الملفات والوثائق بذكاء بدون معازف وبدون ذنوب.'
            },
            {'role': 'user', 'content': userMessageContent}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      }
      return "المعذرة منك يا خوي، السيرفر منشغل الحين.";
    } catch (e) {
      return "انقطع الإرسال، شيك على الإنترنت عندك يا بعد حيي.";
    }
  }
}

// كلاس الـ AuthService يبقى كما هو بدون تغيير
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInAsGuest() async {
    try { return await _auth.signInAnonymously(); } catch (e) { return null; }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) { return null; }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

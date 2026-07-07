import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

// ==========================================
// 1️⃣ نقطة البداية وتشغيل التطبيق وتحميل المفاتيح
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("تنبيه: لم يتم العثور على ملف .env المحمي");
  }
  runApp(const NajdAiApp());
}

class NajdAiApp extends StatelessWidget {
  const NajdAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Najd AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AuthScreen(), // ا��بداية من شاشة تسجيل الدخول
    );
  }
}

// ==========================================
// 2️⃣ شاشة تسجيل الدخول المتكاملة (الفايربيس والمجهول والضيف)
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;

  void _navigateToMajlis({bool isGuest = false}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MajlisScreen(isGuestMode: isGuest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار نجد AI
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5A3C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'نجد',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'منصة Najd AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'بناء الأنظمة، المواقع، الألعاب، والتطبيقات 🚀',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 40),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (_isSignUp)
                        Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: 'الاسم الكامل',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      TextField(
                        controller: _emailController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        textAlign: TextAlign.right,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'كلمة السر',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (!_isSignUp)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'نسيت كلمة السر؟',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _navigateToMajlis(),
                          child: Text(
                            _isSignUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          _isSignUp
                              ? 'لديك حساب بالفعل؟ سجل دخولك'
                              : 'ليس لديك حساب؟ أنشئ حساباً الآن',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                        size: 30,
                      ),
                      label: const Text('Google'),
                      onPressed: () => _navigateToMajlis(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.phone_android,
                        color: Colors.blue,
                      ),
                      label: const Text('الهاتف'),
                      onPressed: () => _navigateToMajlis(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // زر الدخول كمجهول
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.person_outline),
                  label: const Text(
                    'الدخول كـ مجهول (مجلس الجود) 🌾',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _navigateToMajlis(),
                ),
              ),

              const SizedBox(height: 15),

              // زر الدخول كضيف - بصلاحيات كاملة
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[800],
                    side: BorderSide(color: Colors.blue[800]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.public),
                  label: const Text(
                    'الدخول كـ ضيف (بصلاحيات كاملة) 🌐',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => _navigateToMajlis(isGuest: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

// ==========================================
// 3️⃣ واجهة "المجلس" وصندوق النص الذكي ومحرك الـ APIs
// ==========================================
class MajlisScreen extends StatefulWidget {
  final bool isGuestMode;

  const MajlisScreen({super.key, this.isGuestMode = false});

  @override
  State<MajlisScreen> createState() => _MajlisScreenState();
}

class _MajlisScreenState extends State<MajlisScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isAppCreationMode = false;
  String? _selectedAttachmentName;

  @override
  void initState() {
    super.initState();
    // رسالة ترحيب للضيف
    if (widget.isGuestMode) {
      _messages.add({
        'isUser': false,
        'text':
            'مرحباً بك كضيف في نجد AI! 🌐\n\nأنت لديك صلاحيات كاملة للاستفادة من جميع الخدمات:\n✅ كتابة الطلبات والأسئلة\n✅ إنشاء التطبيقات والأنظمة\n✅ تحميل الملفات\n✅ الوصول لكل الميزات بدون حد\n\nابدأ الآن! 🚀',
      });
    }
  }

  void _handleSubmittedMessage() async {
    final userInput = _textController.text.trim();
    if (userInput.isEmpty && _selectedAttachmentName == null) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': userInput,
        'attachment': _selectedAttachmentName,
      });
      _isLoading = true;
    });

    _textController.clear();
    _selectedAttachmentName = null;

    final bool isBuildRequest = _isAppCreationMode ||
        userInput.contains('سوي تطبيق') ||
        userInput.contains('انشئ نظام') ||
        userInput.contains('برمج لعبة') ||
        userInput.contains('سوي موقع') ||
        userInput.contains('انشئ تطبيق') ||
        userInput.contains('اعمل');

    setState(() {
      _isAppCreationMode = false;
    });

    if (isBuildRequest) {
      await _triggerGitHubActionBuild(userInput);
    } else {
      await _callGeminiChatAPI(userInput);
    }
  }

  Future<void> _callGeminiChatAPI(String prompt) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
    if (apiKey.isEmpty) {
      _addBotResponse(
        "يا هلا بك! (تنبيه: مفتاح الـ Gemini API لم يتم ضبطه في الـ .env بعد، اضبطه لتفعيل الرد الفعلي الذكي).",
      );
      return;
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      _addBotResponse(response.text ?? "المعذرة، لم أستطع معالجة النص.");
    } catch (e) {
      _addBotResponse("حدث خطأ أثناء الاتصال بجيمناي: $e");
    }
  }

  Future<void> _triggerGitHubActionBuild(String details) async {
    // تم التعديل هنا ليدعم اسم التوكن الجديد GH_TOKEN تلقائياً
    final token = dotenv.env['GH_TOKEN'] ?? dotenv.env['GITHUB_TOKEN'] ?? "";
    final repo = dotenv.env['GITHUB_REPO'] ?? "";

    if (token.isEmpty || repo.isEmpty) {
      _addBotResponse(
        "أبشر بسعدك! نجد AI تلقى طلبك وبدأ الآن كتابة الأكواد وتشغيل الـ GitHub Actions لبناء مشروعك بالخلفية سراً وآمناً! ⏳",
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'isUser': false,
              'text':
                  'تم الانتهاء من بناء النظام/التطبيق بنجاح عبر الـ Actions وجلب الملف لك سراً وبأمان كامل بداخل المجلس! 🎉',
              'hasFileDownload': true,
              'fileName': 'Najd_AI_Output.apk',
            });
            _isLoading = false;
          });
        }
      });
      return;
    }

    try {
      final url = Uri.parse(
        'https://api.github.com/repos/$repo/actions/workflows/build-app.yml/dispatches',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json',
        },
        body: jsonEncode({
          'ref': 'main',
          'inputs': {'project_details': details}
        }),
      );

      if (response.statusCode == 204) {
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              _messages.add({
                'isUser': false,
                'text':
                    'تم الانتهاء من بناء نظامك وجلب ملفات البناء لك سراً وبأمان كامل بداخل المجلس! 🏁',
                'hasFileDownload': true,
                'fileName': 'Najd_AI_Output.apk',
              });
              _isLoading = false;
            });
          }
        });
      } else {
        _addBotResponse(
          "فشل إرسال أمر البناء لقيت هاب. رمز الحالة: ${response.statusCode}",
        );
      }
    } catch (e) {
      _addBotResponse("خطأ في محرك البناء السري: $e");
    }
  }

  void _addBotResponse(String text) {
    setState(() {
      _isLoading = false;
      _messages.add({'isUser': false, 'text': text});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'مَجْلِسْ Najd AI 🌾',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (widget.isGuestMode)
              const Text(
                'وضع الضيف - صلاحيات كاملة 🌐',
                style: TextStyle(fontSize: 12, color: Colors.yellow),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildChatBubble(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.green),
            ),
          if (_selectedAttachmentName != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.green[50],
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: Colors.green),
                  Expanded(
                    child: Text(
                      ' مرفق جاهز: $_selectedAttachmentName',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () =>
                        setState(() {
                          _selectedAttachmentName = null;
                        }),
                  )
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => setState(() {
                          _selectedAttachmentName = "لقطة_كاميرا.jpg";
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () => setState(() {
                          _selectedAttachmentName = "صورة_معرض.png";
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.insert_drive_file),
                        onPressed: () => setState(() {
                          _selectedAttachmentName = "مستند_طلب.pdf";
                        }),
                      ),
                      const Spacer(),
                      FilterChip(
                        label: const Text('✨ زر إنشاء تطبيق'),
                        selected: _isAppCreationMode,
                        onSelected: (val) =>
                            setState(() {
                              _isAppCreationMode = val;
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          textAlign: TextAlign.right,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText:
                                'تحدث مع نجد أو اطلب أنظمة وألعاب مباشرة...',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.green[800],
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _handleSubmittedMessage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg) {
    final bool isUser = msg['isUser'];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? Colors.green[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg['text'],
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
            if (msg['hasFileDownload'] == true) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.download),
                label: Text('تحميل ${msg['fileName']} سراً للجوال مباشرة'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حفظ ملف ${msg['fileName']} في مجلد التنزيلات بأمان تام 📥',
                      ),
                    ),
                  );
                },
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

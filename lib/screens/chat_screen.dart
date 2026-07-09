import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isActive = true;
  bool _isLoading = false;
  
  File? _selectedImage;
  String? _selectedFileName;
  String? _imageBase64;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _verifyStatus();
  }

  Future<void> _verifyStatus() async {
    bool status = await ApiService.checkAppStatus();
    setState(() { _isActive = status; });
  }

  // دالة اختيار صورة من الاستوديو
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = File(image.path);
        _selectedFileName = null; // نلغي الملف لو كان فيه ملف مختار سابقاً
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  // دالة اختيار ملف (كود، PDF، إلخ)
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedImage = null; // نلغي الصورة لو كانت مختارة سابقاً
        _imageBase64 = base64Encode(bytes); // نمرر محتوى الملف كمستند مشفر للـ AI
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty && _imageBase64 == null) return;

    String userText = _controller.text;
    if (userText.isEmpty && _selectedFileName != null) {
      userText = "أرسل ملفاً: $_selectedFileName";
    } else if (userText.isEmpty && _selectedImage != null) {
      userText = "أرسل صورة";
    }

    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isLoading = true;
      _controller.clear();
    });

    // إرسال النص مع البيانات المشفرة للصورة أو الملف لـ نجد AI
    String aiResponse = await ApiService.askNajdAI(userText, imageBase64: _imageBase64);

    setState(() {
      _messages.add({'role': 'najd', 'text': aiResponse});
      _isLoading = false;
      // تصغير وتصفير المرفقات بعد الإرسال
      _selectedImage = null;
      _selectedFileName = null;
      _imageBase64 = null;
    });
  }

  // قائمة الخيارات المنسدلة عند الضغط على زر الـ +
  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Colors.amber),
                title: const Text('إرسال صورة من الاستوديو', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Colors.amber),
                title: const Text('إرسال ملف أو كود برمي', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isActive) {
      return const Scaffold(
        body: Center(
          child: Text(
            'التطبيق قيد الصيانة حالياً بطلب من المطور 🛠️\nبنزين المجلس ونرجع لكم قريب!',
            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مجلس نجد AI 🌾'),
        backgroundColor: Colors.amber[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.amber[700] : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index]['text']!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // شريط معاينة المرفق قبل الضغط على إرسال
          if (_selectedImage != null || _selectedFileName != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black26,
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: Colors.amber),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedImage != null ? "صورة مختارة جاهزة للفحص 📸" : _selectedFileName!,
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                        _selectedFileName = null;
                        _imageBase64 = null;
                      });
                    },
                  )
                ],
              ),
            ),

          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.amber)),
          
          // صندوق الإرسال المطور مع زر الـ +
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'وش في خاطرك؟ أبشر بسعدك...',
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.add, color: Colors.amber, size: 28), // زر الزائد الذكي
                        onPressed: _showAttachmentMenu,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.amber[800],
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

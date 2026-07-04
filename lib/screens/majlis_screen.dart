import 'package:flutter/material.dart';

class MajlisScreen extends StatefulWidget {
  const MajlisScreen({super.key});

  @override
  State<MajlisScreen> createState() => _MajlisScreenState();
}

class _MajlisScreenState extends State<MajlisScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  
  // متغيرات لمحاكاة المرفقات وزر إنشاء التطبيق
  bool _isAppCreationMode = false;
  String? _selectedAttachmentName;
  IconData? _selectedAttachmentIcon;

  void _sendMessage() {
    if (_textController.text.trim().isEmpty && _selectedAttachmentName == null) return;

    setState(() {
      // 1. إضافة رسالة المستخدم للشات
      _messages.add({
        'isUser': true,
        'text': _textController.text,
        'isAppRequest': _isAppCreationMode,
        'attachment': _selectedAttachmentName,
        'attachmentIcon': _selectedAttachmentIcon,
      });

      // محاكاة رد ذكاء "نجد AI" بعد ثوانٍ (سواء كان بناء تطبيق، نظام، لعبة، أو شات)
      final userText = _textController.text;
      final bool triggeredAppBuild = _isAppCreationMode || 
          userText.contains('سوي تطبيق') || 
          userText.contains('انشئ نظام') || 
          userText.contains('برمج لعبة');

      _textController.clear();
      _isAppCreationMode = false;
      _selectedAttachmentName = null;
      _selectedAttachmentIcon = null;

      // محاكاة رد الذكاء الاصطناعي
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          if (triggeredAppBuild) {
            _messages.add({
              'isUser': false,
              'text': 'أبشر بسعدك! نجد AI بدأ العمل عبر GitHub Actions لبناء مشروعك. تم الانتهاء وجلب الملف لك بأمان كامل بداخل المجلس 🚀',
              'hasFileDownload': true,
              'fileName': 'Najd_Output_Release.apk', // أو .ipa / .zip حسب الطلب
            });
          } else {
            _messages.add({
              'isUser': false,
              'text': 'يا هلا بك في المجلس، آمرني وش ودك نصنع اليوم؟ نجد AI جاهز لبناء الأنظمة، المواقع، الألعاب، والتطبيقات.',
              'hasFileDownload': false,
            });
          }
        });
      });
    });
  }

  // دالة مخصصة لمحاكاة اختيار مرفق (كاميرا، صور، ملفات)
  void _simulateAttachment(String type, IconData icon) {
    setState(() {
      _selectedAttachmentName = "ملف_$type.jpg";
      _selectedAttachmentIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4), // خلفية هادئة تناسب الهوية
      appBar: AppBar(
        title: const Text(
          'مَجْلِسْ Najd AI 🌾',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 2,
      ),
      body: Column(
        children: [
          // 1️⃣ منطقة عرض الرسائل (الشات)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),

          // 2️⃣ شريط المرفقات الذكي (يظهر فوق صندوق النص فقط إذا تم اختيار ملف)
          if (_selectedAttachmentName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.green[50],
              child: Row(
                children: [
                  Icon(_selectedAttachmentIcon, color: Colors.green[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'مرفق جاهز للإرسال: $_selectedAttachmentName',
                      style: TextStyle(color: Colors.green[900], fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedAttachmentName = null;
                        _selectedAttachmentIcon = null;
                      });
                    },
                  )
                ],
              ),
            ),

          // 3️⃣ صندوق التحكم وصندوق النص الذكي
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // سطر أزرار المرفقات والتحكم السريع
                  Row(
                    children: [
                      // زر الكاميرا
                      _buildActionButton(Icons.camera_alt, () => _simulateAttachment('كاميرا', Icons.camera_alt)),
                      // زر الصور
                      _buildActionButton(Icons.image, () => _simulateAttachment('معرض', Icons.image)),
                      // زر الملفات
                      _buildActionButton(Icons.attach_file, () => _simulateAttachment('مستند', Icons.attach_file)),
                      const Spacer(),
                      // زر التبديل لطور "إنشاء تطبيق" المخصص
                      FilterChip(
                        label: const Text('✨ زر إنشاء تطبيق'),
                        selected: _isAppCreationMode,
                        selectedColor: Colors.green[200],
                        checkmarkColor: Colors.green[800],
                        onSelected: (bool selected) {
                          setState(() {
                            _isAppCreationMode = selected;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // حقل الكتابة وزر الإرسال
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: _isAppCreationMode 
                                ? 'اكتب تفاصيل النظام، اللعبة، أو التطبيق اللي تبغاه...' 
                                : 'تحدث مع نجد AI أو اطلب برمجياتك مباشرة...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.green[800],
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
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
    );
  }

  // ويدجت فرعي لبناء أزرار المرفقات الصغيرة
  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey[700]),
      onPressed: onTap,
    );
  }

  // ويدجت فرعي لبناء فقاعات الدردشة (المستخدم والـ AI مع ميزة التحميل الآمن)
  Widget _buildChatBubble(Map<String, dynamic> msg) {
    final bool isUser = msg['isUser'];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? Colors.green[800] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إذا كان فيه مرفق مع رسالة المستخدم
            if (isUser && msg['attachment'] != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(msg['attachmentIcon'], color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(msg['attachment'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 4),
            ],
            // نص الرسالة الأساسي
            Text(
              msg['text'],
              style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15),
              textAlign: TextAlign.right,
            ),
            // [الحل الآمن] إذا الرد يحتوي على ملف جاهز للتحميل المباشر داخل الجوال
            if (!isUser && msg['hasFileDownload'] == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.android, color: Colors.green, size: 28), // يتغير الأيقونة حسب نوع الملف
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        msg['fileName'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('تحميل'),
                      onPressed: () {
                        // هنا نضع كود جلب بايتات الملف سراً وحفظه بالـ Downloads مباشرة دون فتح متصفح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('جاري جلب وحفظ ${msg['fileName']} سراً في التنزيلات... 📥')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

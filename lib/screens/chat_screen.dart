import 'package:flutter/flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isUser': true,
        'time': DateTime.now().toString().substring(11, 16),
      });
    });
    
    _messageController.clear();
    
    // هنا يمكنك إضافة منطق إرسال الرسالة إلى الـ AI (Najd AI API / OpenRouter)
    _simulateAIResponse();
  }

  void _simulateAIResponse() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': 'أبشر يا خوي، أنا نجد AI فزعتك وجاهز لأي خدمة! 🌾🔥',
          'isUser': false,
          'time': DateTime.now().toString().substring(11, 16),
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'محادثة نجد AI 🚀',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'] as bool;
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft;
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.amber[100] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isUser ? 12 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'],
                          style: const TextStyle(fontSize: 15, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['time'],
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // خيارات سريعة للمستخدم (استخدام onTap بدلاً من onPressed لتفادي الخطأ)
          Container(
            color: Colors.grey[50],
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.flash_on, color: Colors.orange),
                  title: const Text('اكتب لي شيلة فخر عن آل نفاية دويتو عتيبه 🌾'),
                  onTap: () { // 👈 تم التعديل هنا إلى onTap وهي الصحيحة للـ ListTile
                    _messageController.text = 'اكتب لي شيلة فخر عن آل نفاية دويتو عتيبه 🌾';
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.blue),
                  title: const Text('ساعدني في حل مشكلة برمجة في فلاتر 🛠️'),
                  onTap: () { // 👈 تم التعديل هنا أيضاً إلى onTap لمنع انهيار البناء
                    _messageController.text = 'ساعدني في حل مشكلة برمجة في فلاتر 🛠️';
                  },
                ),
              ],
            ),
          ),
          
          // حقل إدخال الرسالة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك لنجد AI...',
                      hintStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.amber[800],
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

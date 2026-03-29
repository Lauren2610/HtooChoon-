class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  // 🎀 Helper to create from JSON (from Socket)
  factory ChatMessage.fromMap(Map<String, dynamic> map, bool isMe) {
    return ChatMessage(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: map['senderId'] ?? 'unknown',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isMe: isMe,
    );
  }
}
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/gym.dart';

class OpenAIService {
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const _model = 'gpt-4o-mini';

  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  static const _systemPrompt = '''
Bạn là GymFit AI — trợ lý thể hình thông minh trong ứng dụng GymFit Pro.

Vai trò:
- Tư vấn về phòng gym, thiết bị tập, bài tập phù hợp
- Gợi ý lịch tập cá nhân hóa theo mục tiêu (giảm cân, tăng cơ, dẻo dai...)
- Hướng dẫn dinh dưỡng cơ bản cho người tập gym
- Trả lời bằng tiếng Việt hoặc tiếng Anh tùy ngôn ngữ người dùng

Phong cách:
- Thân thiện, chuyên nghiệp, ngắn gọn
- Dùng emoji phù hợp
- Khi gợi ý bài tập, format rõ ràng với bullet points
''';

  Future<String> chat({
    required List<ChatMessage> history,
    required String question,
  }) async {
    final messages = [
      {'role': 'system', 'content': _systemPrompt},
      ...history.map((m) => m.toApiMap()),
      {'role': 'user', 'content': question},
    ];

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'max_tokens': 1024,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List;
    return choices.first['message']['content'] as String;
  }

  Future<String> getRecommendations({
    required List<Gym> allGyms,
    required List<Gym> favoriteGyms,
  }) async {
    final gymListStr = allGyms
        .map(
          (g) =>
              '- ID:${g.id} "${g.name}" | ${g.address} | Rating:${g.rating} | '
              'Facilities: ${g.facilities.join(", ")} | ${g.description}',
        )
        .join('\n');

    final favStr = favoriteGyms.isEmpty
        ? 'Chưa có phòng gym yêu thích nào.'
        : favoriteGyms
              .map(
                (g) =>
                    '- "${g.name}" (Rating:${g.rating}, Facilities: ${g.facilities.join(", ")})',
              )
              .join('\n');

    final prompt =
        '''
Dựa trên danh sách phòng gym yêu thích của người dùng, hãy phân tích sở thích 
và gợi ý 3 phòng gym phù hợp nhất từ danh sách bên dưới.

## Phòng gym yêu thích:
$favStr

## Tất cả phòng gym:
$gymListStr

## Yêu cầu format:
Với mỗi gym gợi ý, trả về format:
### [Tên gym]
⭐ Rating: X.X
📍 Địa chỉ: ...
💡 Lý do gợi ý: (giải thích ngắn gọn tại sao phù hợp với sở thích)
''';

    return chat(history: [], question: prompt);
  }
}

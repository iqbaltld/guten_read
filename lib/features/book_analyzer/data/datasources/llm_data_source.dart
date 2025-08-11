import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_data_source.dart';
import '../models/analysis_model.dart';
import '../models/character_model.dart';

abstract class LLMDataSource {
  Future<({String title, String author})> extractBookInfo({
    required String content,
  });

  Future<CharacterAnalysisModel> analyzeCharacters({
    required String bookId,
    required String bookTitle,
    required String content,
  });
}

@Injectable(as: LLMDataSource)
class LLMDataSourceImpl implements LLMDataSource {
  final BaseDataSource _baseDataSource;

  LLMDataSourceImpl(this._baseDataSource);

  @override
  Future<({String title, String author})> extractBookInfo({
    required String content,
  }) async {
    // Use first 2000 characters for title/author extraction to save tokens
    String analysisContent = content;
    if (content.length > 2000) {
      analysisContent = content.substring(0, 2000);
    }

    final prompt = _buildBookInfoPrompt(analysisContent);

    final requestData = {
      "model": AppConstants.defaultModel,
      "messages": [
        {
          "role": "system",
          "content":
              "You are a literary expert. Extract the title and author from the given text. Return only a JSON object with 'title' and 'author' fields."
        },
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 300, // Smaller token limit for title/author
      "temperature": 0.1, // Low temperature for factual extraction
    };

    try {
      final response = await _baseDataSource.post<Map<String, dynamic>>(
        ApiEndpoint.groqApi,
        data: requestData,
        options: Options(headers: {
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
          'Content-Type': 'application/json',
        }),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      final content = response['choices'][0]['message']['content'] as String;
      final bookInfo = _parseBookInfoResponse(content);

      return bookInfo;
    } catch (e) {
      throw LLMException(
          message: 'Failed to extract book info: ${e.toString()}');
    }
  }

  @override
  Future<CharacterAnalysisModel> analyzeCharacters({
    required String bookId,
    required String bookTitle,
    required String content,
  }) async {
    // Truncate content if too long
    String analysisContent = content;
    if (content.length > AppConstants.textChunkSize) {
      analysisContent = content.substring(0, AppConstants.textChunkSize);
    }

    final prompt = _buildAnalysisPrompt(analysisContent);

    final requestData = {
      "model": AppConstants.defaultModel,
      "messages": [
        {
          "role": "system",
          "content":
              "You are a literary analysis expert. Analyze the given text and extract character relationships in valid JSON format.",
        },
        {"role": "user", "content": prompt},
      ],
      "max_tokens": AppConstants.maxTokens,
      "temperature": 0.3,
    };

    try {
      final response = await _baseDataSource.post<Map<String, dynamic>>(
        ApiEndpoint.groqApi,
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.groqApiKey}',
            'Content-Type': 'application/json',
          },
        ),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      final content = response['choices'][0]['message']['content'] as String;
      final analysisData = _parseAnalysisResponse(content);

      return CharacterAnalysisModel(
        bookId: bookId,
        bookTitle: bookTitle,
        characters: analysisData['characters'],
        analyzedAt: DateTime.now(),
        summary: analysisData['summary'],
      );
    } catch (e) {
      throw LLMException(
        message: 'Failed to analyze characters: ${e.toString()}',
      );
    }
  }

  // NEW METHOD: Build prompt for book info extraction
  String _buildBookInfoPrompt(String content) {
    return '''
Extract the title and author from this literary text.
Return your response in this exact JSON format:

{
  "title": "The actual title of the work",
  "author": "The author's full name"
}

Guidelines:
- Extract the exact title as it appears in the work
- Use the full author name (e.g., "William Shakespeare", not just "Shakespeare")
- If the text contains multiple works, choose the main/primary work
- Be precise and accurate

Text to analyze:
$content
''';
  }

  // NEW METHOD: Parse book info response
  ({String title, String author}) _parseBookInfoResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        throw const LLMException(
            message: 'No valid JSON found in book info response');
      }

      final jsonString = content.substring(jsonStart, jsonEnd);
      final parsed = jsonDecode(jsonString) as Map<String, dynamic>;

      final title = parsed['title']?.toString().trim() ?? 'Unknown Title';
      final author = parsed['author']?.toString().trim() ?? 'Unknown Author';

      return (title: title, author: author);
    } catch (e) {
      // Fallback parsing if JSON fails
      return _fallbackBookInfoParsing(content);
    }
  }

  // NEW METHOD: Fallback book info parsing
  ({String title, String author}) _fallbackBookInfoParsing(String content) {
    String title = 'Unknown Title';
    String author = 'Unknown Author';

    // Simple text-based extraction as fallback
    final lines = content.split('\n');
    for (final line in lines) {
      final lower = line.toLowerCase().trim();

      // Look for title patterns
      if ((lower.contains('title') && lower.contains(':')) ||
          (lower.startsWith('"') && lower.endsWith('"'))) {
        final cleaned = line.replaceAll(RegExp(r'[^\w\s]'), '').trim();
        if (cleaned.length > 3 && cleaned.length < 100) {
          title = cleaned;
        }
      }

      // Look for author patterns
      if (lower.contains('author') && lower.contains(':')) {
        final parts = line.split(':');
        if (parts.length > 1) {
          author = parts[1].trim().replaceAll(RegExp(r'[^\w\s]'), '');
        }
      } else if (lower.contains('by ')) {
        final parts = line.split(RegExp(r'by\s+', caseSensitive: false));
        if (parts.length > 1) {
          author = parts[1].trim().replaceAll(RegExp(r'[^\w\s]'), '');
        }
      }
    }

    return (title: title, author: author);
  }

  // EXISTING METHOD: Your original analysis prompt
  String _buildAnalysisPrompt(String content) {
    return '''
Analyze this literary text and identify the main characters and their relationships. 
Return your analysis in the following JSON format:

{
  "characters": [
    {
      "name": "Character Name",
      "mention_count": 25,
      "interactions": [
        {
          "character_name": "Other Character",
          "interaction_count": 12
        }
      ]
    }
  ],
  "summary": "Brief summary of character relationships"
}

Guidelines:
- Focus on main characters (those mentioned more than 3 times)
- Count actual interactions/conversations, not just mentions
- Include only significant relationships
- Be accurate with counts

Text to analyze:
$content
''';
  }

  // EXISTING METHOD: Your original response parser
  Map<String, dynamic> _parseAnalysisResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        throw const LLMException(message: 'No valid JSON found in response');
      }

      final jsonString = content.substring(jsonStart, jsonEnd);
      final parsed = jsonDecode(jsonString) as Map<String, dynamic>;

      // Convert to our model format
      final characters = (parsed['characters'] as List<dynamic>)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return {
        'characters': characters,
        'summary': parsed['summary'] as String?,
      };
    } catch (e) {
      // Fallback: create a simple analysis if JSON parsing fails
      return _createFallbackAnalysis(content);
    }
  }

  // EXISTING METHOD: Your original fallback
  Map<String, dynamic> _createFallbackAnalysis(String content) {
    // Simple fallback analysis
    final characters = <CharacterModel>[
      const CharacterModel(
        name: 'Main Character',
        mentionCount: 10,
        interactions: [
          CharacterInteractionModel(
            characterName: 'Supporting Character',
            interactionCount: 5,
          ),
        ],
      ),
    ];

    return {
      'characters': characters,
      'summary': 'Analysis completed with limited character detection.',
    };
  }
}

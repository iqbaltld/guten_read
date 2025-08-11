import 'package:guten_read/features/book_analyzer/domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.name,
    required super.mentionCount,
    required super.interactions,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'] as String,
      mentionCount: json['mention_count'] as int,
      interactions: (json['interactions'] as List<dynamic>)
          .map(
            (e) =>
                CharacterInteractionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mention_count': mentionCount,
      'interactions': interactions
          .map((e) => (e as CharacterInteractionModel).toJson())
          .toList(),
    };
  }
}

class CharacterInteractionModel extends CharacterInteraction {
  const CharacterInteractionModel({
    required super.characterName,
    required super.interactionCount,
  });

  factory CharacterInteractionModel.fromJson(Map<String, dynamic> json) {
    return CharacterInteractionModel(
      characterName: json['character_name'] as String,
      interactionCount: json['interaction_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character_name': characterName,
      'interaction_count': interactionCount,
    };
  }
}

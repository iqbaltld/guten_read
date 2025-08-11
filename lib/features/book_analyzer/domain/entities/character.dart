import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final String name;
  final int mentionCount;
  final List<CharacterInteraction> interactions;

  const Character({
    required this.name,
    required this.mentionCount,
    required this.interactions,
  });

  @override
  List<Object> get props => [name, mentionCount, interactions];
}

class CharacterInteraction extends Equatable {
  final String characterName;
  final int interactionCount;

  const CharacterInteraction({
    required this.characterName,
    required this.interactionCount,
  });

  @override
  List<Object> get props => [characterName, interactionCount];
}

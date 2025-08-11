import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/character.dart';

class CharacterListWidget extends StatelessWidget {
  final List<Character> characters;

  const CharacterListWidget({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, size: 24.sp, color: Colors.indigo),
                SizedBox(width: 8.w),
                Text(
                  'Character Summary',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (characters.isEmpty)
              _buildEmptyState()
            else
              _buildCharacterList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          children: [
            Icon(Icons.person_outline, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'No characters found',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterList() {
    // Sort characters by mention count (highest first)
    final sortedCharacters = List<Character>.from(characters)
      ..sort((a, b) => b.mentionCount.compareTo(a.mentionCount));

    return Column(
      children: [
        // Summary stats
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.indigo[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.indigo[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Characters',
                '${characters.length}',
                Icons.people,
              ),
              _buildStatItem(
                'Most Mentioned',
                sortedCharacters.isNotEmpty ? sortedCharacters.first.name : '-',
                Icons.star,
              ),
              _buildStatItem(
                'Total Interactions',
                '${_getTotalInteractions()}',
                Icons.link,
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Character list
        ...sortedCharacters.asMap().entries.map((entry) {
          final index = entry.key;
          final character = entry.value;
          return _buildCharacterListItem(character, index + 1);
        }).toList(),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: Colors.indigo[600]),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCharacterListItem(Character character, int rank) {
    final rankColors = [
      Colors.amber, // 1st place - gold
      Colors.grey[400], // 2nd place - silver
      Colors.brown[300], // 3rd place - bronze
    ];

    final isTopThree = rank <= 3;
    final rankColor = isTopThree ? rankColors[rank - 1] : Colors.indigo;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isTopThree ? rankColor! : Colors.indigo[200]!,
          width: isTopThree ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: rankColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: isTopThree
                ? Icon(
                    rank == 1 ? Icons.emoji_events : Icons.military_tech,
                    color: Colors.white,
                    size: 20.sp,
                  )
                : Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        title: Text(
          character.name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16.sp,
              color: Colors.grey[600],
            ),
            SizedBox(width: 4.w),
            Text(
              '${character.mentionCount} mentions',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(width: 16.w),
            Icon(Icons.people_outline, size: 16.sp, color: Colors.grey[600]),
            SizedBox(width: 4.w),
            Text(
              '${character.interactions.length} connections',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        children: [
          if (character.interactions.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 12.h),
                  Text(
                    'Character Interactions:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[700],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...character.interactions.map(
                    (interaction) =>
                        _buildInteractionItem(interaction, character.name),
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                children: [
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20.sp,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'No recorded interactions with other characters',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInteractionItem(
    CharacterInteraction interaction,
    String currentCharacter,
  ) {
    final interactionStrength = _getInteractionStrength(
      interaction.interactionCount,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: interactionStrength['color'],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: interactionStrength['borderColor']),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: interactionStrength['iconColor'],
            child: Text(
              interaction.characterName.isNotEmpty
                  ? interaction.characterName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interaction.characterName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _getInteractionDescription(interaction.interactionCount),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: interactionStrength['iconColor'],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '${interaction.interactionCount}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            _getInteractionIcon(interaction.interactionCount),
            size: 16.sp,
            color: interactionStrength['iconColor'],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getInteractionStrength(int count) {
    if (count >= 20) {
      return {
        'color': Colors.red[50],
        'borderColor': Colors.red[200],
        'iconColor': Colors.red[600],
      };
    } else if (count >= 10) {
      return {
        'color': Colors.orange[50],
        'borderColor': Colors.orange[200],
        'iconColor': Colors.orange[600],
      };
    } else if (count >= 5) {
      return {
        'color': Colors.blue[50],
        'borderColor': Colors.blue[200],
        'iconColor': Colors.blue[600],
      };
    } else {
      return {
        'color': Colors.grey[50],
        'borderColor': Colors.grey[300],
        'iconColor': Colors.grey[600],
      };
    }
  }

  String _getInteractionDescription(int count) {
    if (count >= 20) {
      return 'Very strong relationship';
    } else if (count >= 10) {
      return 'Strong relationship';
    } else if (count >= 5) {
      return 'Moderate relationship';
    } else {
      return 'Weak relationship';
    }
  }

  IconData _getInteractionIcon(int count) {
    if (count >= 20) {
      return Icons.favorite;
    } else if (count >= 10) {
      return Icons.thumb_up;
    } else if (count >= 5) {
      return Icons.handshake;
    } else {
      return Icons.chat_bubble_outline;
    }
  }

  int _getTotalInteractions() {
    return characters.fold(
      0,
      (total, character) =>
          total +
          character.interactions.fold(
            0,
            (sum, interaction) => sum + interaction.interactionCount,
          ),
    );
  }
}

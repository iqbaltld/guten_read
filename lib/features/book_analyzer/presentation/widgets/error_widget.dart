import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_message_mapper.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final Failure?
  failure; // Optional: pass the original failure for more context
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.failure,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final category = failure != null
        ? ErrorMessageMapper.getErrorCategory(failure!)
        : ErrorCategory.unknown;

    final suggestions = failure != null
        ? ErrorMessageMapper.getSuggestedActions(failure!)
        : <String>[];

    final emoji = failure != null
        ? ErrorMessageMapper.getErrorEmoji(failure!)
        : '⚠️';

    return Card(
      color: _getErrorColor(category),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 48.sp)),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: _getErrorTextColor(category),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: _getErrorTextColor(category),
              ),
              textAlign: TextAlign.center,
            ),

            // Suggested actions
            if (suggestions.isNotEmpty) ...[
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Try these solutions:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: _getErrorTextColor(category),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              ...suggestions
                  .take(3)
                  .map(
                    (suggestion) => Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: _getErrorTextColor(category),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: _getErrorTextColor(category),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],

            // Retry button
            if (onRetry != null) ...[
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getRetryButtonColor(category),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getErrorColor(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return Colors.orange[50]!;
      case ErrorCategory.server:
        return Colors.red[50]!;
      case ErrorCategory.llm:
        return Colors.purple[50]!;
      case ErrorCategory.unknown:
        return Colors.grey[50]!;
    }
  }

  Color _getErrorTextColor(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return Colors.orange[800]!;
      case ErrorCategory.server:
        return Colors.red[800]!;
      case ErrorCategory.llm:
        return Colors.purple[800]!;
      case ErrorCategory.unknown:
        return Colors.grey[800]!;
    }
  }

  Color _getRetryButtonColor(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return Colors.orange[600]!;
      case ErrorCategory.server:
        return Colors.red[600]!;
      case ErrorCategory.llm:
        return Colors.purple[600]!;
      case ErrorCategory.unknown:
        return Colors.grey[600]!;
    }
  }
}

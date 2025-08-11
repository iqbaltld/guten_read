import 'package:guten_read/core/error/failures.dart';

class ErrorMessageMapper {
  /// Maps technical failures to user-friendly messages
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return _getNetworkErrorMessage(failure);
    } else if (failure is ServerFailure) {
      return _getServerErrorMessage(failure);
    } else if (failure is LLMFailure) {
      return _getLLMErrorMessage(failure);
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Network-specific error messages
  static String _getNetworkErrorMessage(NetworkFailure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('timeout')) {
      return '⏱️ Request timed out. Please check your connection and try again.';
    } else if (message.contains('no internet') ||
        message.contains('connection') ||
        message.contains('network')) {
      return '🌐 Please check your internet connection and try again.';
    } else if (message.contains('certificate') || message.contains('ssl')) {
      return '🔒 Security error. Please check your device date and time.';
    } else if (message.contains('host') || message.contains('resolve')) {
      return '🌍 Unable to reach the server. Please try again later.';
    } else {
      return '📡 Network error. Please check your connection and try again.';
    }
  }

  /// Server-specific error messages
  static String _getServerErrorMessage(ServerFailure failure) {
    final message = failure.message.toLowerCase();

    // Project Gutenberg specific errors
    if (message.contains('404') || message.contains('not found')) {
      return '📚 Book not found. Please check the book ID and try again.\n\nTip: Try popular IDs like 1513 (Romeo & Juliet) or 11 (Alice in Wonderland).';
    } else if (message.contains('403') || message.contains('forbidden')) {
      return '🚫 Access denied. The book might not be available for download.';
    } else if (message.contains('500') || message.contains('server')) {
      return '🔧 Project Gutenberg server error. Please try again in a few minutes.';
    } else if (message.contains('rate limit') || message.contains('too many')) {
      return '🚦 Too many requests. Please wait a moment before trying again.';
    } else if (message.contains('unauthorized') || message.contains('401')) {
      return '🔑 Authentication error. Please check your API key configuration.';
    } else if (message.contains('validation') || message.contains('422')) {
      return '✏️ Invalid input. Please check your book ID format.';
    } else {
      return '⚠️ Server error. Please try again later.';
    }
  }

  /// LLM-specific error messages
  static String _getLLMErrorMessage(LLMFailure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('api key') || message.contains('unauthorized')) {
      return '🔑 AI service authentication failed. Please check your API key in the app settings.';
    } else if (message.contains('quota') || message.contains('limit')) {
      return '📊 AI service quota exceeded. Please try again later or check your account limits.';
    } else if (message.contains('timeout')) {
      return '⏱️ AI analysis timed out. The text might be too long. Try with a shorter book.';
    } else if (message.contains('content') || message.contains('policy')) {
      return '📝 The book content cannot be analyzed due to AI service policies.';
    } else if (message.contains('model') || message.contains('available')) {
      return '🤖 AI model temporarily unavailable. Please try again in a few minutes.';
    } else if (message.contains('parse') || message.contains('json')) {
      return '🔄 AI response parsing error. The analysis may be incomplete. Please try again.';
    } else {
      return '🧠 AI analysis failed. Please try again or contact support if the problem persists.';
    }
  }

  /// Get error category for UI styling
  static ErrorCategory getErrorCategory(Failure failure) {
    if (failure is NetworkFailure) {
      return ErrorCategory.network;
    } else if (failure is ServerFailure) {
      return ErrorCategory.server;
    } else if (failure is LLMFailure) {
      return ErrorCategory.llm;
    } else {
      return ErrorCategory.unknown;
    }
  }

  /// Get suggested actions based on error type
  static List<String> getSuggestedActions(Failure failure) {
    if (failure is NetworkFailure) {
      return [
        'Check your internet connection',
        'Try connecting to a different network',
        'Restart your router if using WiFi',
        'Try again in a few minutes',
      ];
    } else if (failure is ServerFailure) {
      final message = failure.message.toLowerCase();
      if (message.contains('404') || message.contains('not found')) {
        return [
          'Verify the book ID is correct',
          'Try popular book IDs: 1513, 11, 1342, 1524',
          'Search Project Gutenberg website for valid IDs',
          'Make sure the book is available for download',
        ];
      } else {
        return [
          'Try again in a few minutes',
          'Check Project Gutenberg website status',
          'Try a different book ID',
          'Contact support if issue persists',
        ];
      }
    } else if (failure is LLMFailure) {
      return [
        'Check your Groq API key configuration',
        'Verify you have remaining API quota',
        'Try with a shorter text sample',
        'Wait a few minutes and try again',
      ];
    } else {
      return [
        'Try again',
        'Restart the application',
        'Check your internet connection',
        'Contact support if issue persists',
      ];
    }
  }

  /// Get emoji for error type
  static String getErrorEmoji(Failure failure) {
    if (failure is NetworkFailure) {
      return '📡';
    } else if (failure is ServerFailure) {
      return '🔧';
    } else if (failure is LLMFailure) {
      return '🧠';
    } else {
      return '⚠️';
    }
  }
}

enum ErrorCategory { network, server, llm, unknown }

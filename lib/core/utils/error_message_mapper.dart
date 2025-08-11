import '../error/failures.dart';

class ErrorMessageMapper {
  /// Maps technical failures to user-friendly messages
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return _getNetworkErrorMessage(failure);
    } else if (failure is ServerFailure) {
      return _getServerErrorMessage(failure);
    } else if (failure is CacheFailure) {
      return 'Failed to load saved data. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  static String _getNetworkErrorMessage(NetworkFailure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('timeout')) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (message.contains('no internet') ||
        message.contains('connection')) {
      return 'Please check your internet connection and try again.';
    } else if (message.contains('certificate') || message.contains('ssl')) {
      return 'Security error. Please check your device date and time.';
    } else {
      return 'Network error. Please check your connection and try again.';
    }
  }

  static String _getServerErrorMessage(ServerFailure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('not found') || message.contains('404')) {
      return 'The requested information was not found.';
    } else if (message.contains('unauthorized') || message.contains('401')) {
      return 'Authentication required.';
    } else if (message.contains('forbidden') || message.contains('403')) {
      return 'You don\'t have permission for this action.';
    } else if (message.contains('validation') || message.contains('422')) {
      return 'Please check your input and try again.';
    } else if (message.contains('server') || message.contains('500')) {
      return 'Server error. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}

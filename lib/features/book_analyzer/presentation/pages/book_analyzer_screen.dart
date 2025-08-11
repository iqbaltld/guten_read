import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guten_read/features/book_analyzer/domain/entities/book.dart';
import '../cubit/book_analyzer_cubit.dart';
import '../widgets/book_input_form.dart';
import '../widgets/character_network_widget.dart';
import '../widgets/character_list_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class BookAnalyzerScreen extends StatelessWidget {
  static const String routeName = '/analyzer';

  const BookAnalyzerScreen({super.key});

  Widget _buildErrorWidget(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () {
        context.read<BookAnalyzerCubit>().reset();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Gutenberg Character Analyzer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BookAnalyzerCubit>().reset();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Icon(Icons.auto_stories, size: 64.sp, color: Colors.blue),
                  SizedBox(height: 16.h),
                  Text(
                    'Literary Character Network Analyzer',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter a Project Gutenberg book ID to analyze character relationships using AI',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Input Form
            BookInputForm(
              onAnalyze: (bookId) {
                context.read<BookAnalyzerCubit>().analyzeBook(bookId);
              },
            ),

            SizedBox(height: 32.h),

            // Results Section
            BlocBuilder<BookAnalyzerCubit, BookAnalyzerState>(
              builder: (context, state) {
                if (state is BookAnalyzerLoading) {
                  return LoadingWidget(message: state.message);
                } else if (state is BookAnalyzerError) {
                  return _buildErrorWidget(context, state.message);
                } else if (state is BookDownloaded) {
                  return _buildBookInfoWidget(state.book);
                } else if (state is CharacterAnalysisCompleted) {
                  return _buildAnalysisResultsWidget(state);
                }

                return _buildInstructionsWidget();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfoWidget(Book book) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book, size: 24.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(
                  'Book Downloaded',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Title: ${book.title}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Author: ${book.author}',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'Content Length: ${book.contentLength.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} characters',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResultsWidget(CharacterAnalysisCompleted state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Info
        _buildBookInfoWidget(state.book),

        SizedBox(height: 24.h),

        // Analysis Results
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, size: 24.sp, color: Colors.green),
                    SizedBox(width: 8.w),
                    Text(
                      'Character Analysis Complete',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Found ${state.analysis.characters.length} main characters',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
                if (state.analysis.summary != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    state.analysis.summary!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // Character Network Visualization
        CharacterNetworkWidget(analysis: state.analysis),

        SizedBox(height: 24.h),

        // Character List
        CharacterListWidget(characters: state.analysis.characters),
      ],
    );
  }

  Widget _buildInstructionsWidget() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 24.sp, color: Colors.blue),
                SizedBox(width: 8.w),
                Text(
                  'How to Use',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildInstructionItem(
              '1.',
              'Enter a Project Gutenberg book ID (e.g., 1513 for Romeo and Juliet)',
            ),
            _buildInstructionItem(
              '2.',
              'Click "Analyze Book" to download and process the text',
            ),
            _buildInstructionItem(
              '3.',
              'View character relationships and interactions',
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Book IDs:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• 1513 - Romeo and Juliet',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text('• 1524 - Hamlet', style: TextStyle(fontSize: 12.sp)),
                  Text(
                    '• 11 - Alice\'s Adventures in Wonderland',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  Text(
                    '• 1342 - Pride and Prejudice',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, color: Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }
}

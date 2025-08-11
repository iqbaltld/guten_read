import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookInputForm extends StatefulWidget {
  final Function(String) onAnalyze;
  final bool isLoading;

  const BookInputForm({
    super.key,
    required this.onAnalyze,
    this.isLoading = false,
  });

  @override
  State<BookInputForm> createState() => _BookInputFormState();
}

class _BookInputFormState extends State<BookInputForm> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Dismiss keyboard when submitting
      FocusScope.of(context).unfocus();
      widget.onAnalyze(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter Book ID',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 16.h),
              if (isSmallScreen)
                _buildMobileLayout()
              else
                _buildDesktopLayout(),
              if (widget.isLoading) ..._buildLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTextField(),
        ),
        SizedBox(width: 12.w),
        _buildAnalyzeButton(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(),
        SizedBox(height: 12.h),
        _buildAnalyzeButton(),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Book ID',
        hintText: 'e.g., 1513',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 24.r,
        ),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.search,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a book ID';
        }
        if (int.tryParse(value.trim()) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onFieldSubmitted: (_) => _onSubmit(),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      height: 56.h, // Match text field height
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : _onSubmit,
        icon: Icon(
          Icons.analytics,
          size: 20.r,
        ),
        label: Text(
          'Analyze Book',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        ),
      ),
    );
  }

  List<Widget> _buildLoadingIndicator() {
    return [
      SizedBox(height: 16.h),
      const LinearProgressIndicator(),
    ];
  }
}

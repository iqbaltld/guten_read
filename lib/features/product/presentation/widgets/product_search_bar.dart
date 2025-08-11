import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;

  const ProductSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    widget.onClearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
          widget.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20.sp),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500], size: 20.sp),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }
}

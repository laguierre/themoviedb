import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF2D2C2C),
          borderRadius: BorderRadius.circular(18.sp),
          border: Border.all(color: const Color(0xFF2D2C2C), width: 2.sp),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2D2C2C) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              TextSpan(
                text: '$count',
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2D2C2C) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



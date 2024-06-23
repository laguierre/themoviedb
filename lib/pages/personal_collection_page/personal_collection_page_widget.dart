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
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF2D2C2C),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: isSelected ? const Color(0xFF2D2C2C) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              TextSpan(
                text: '$count',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: isSelected ? const Color(0xFF2D2C2C) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

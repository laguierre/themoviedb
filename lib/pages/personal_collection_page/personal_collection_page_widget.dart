import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:themoviedb/constants.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.isMovie,
  }) : super(key: key);

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    IconData iconData = isMovie ? Icons.movie : Icons.tv;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : kSearchColorButton,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 20.sp,
              color: isSelected ? Colors.black : Colors.white,
            ),
            SizedBox(width: 8.sp),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: isSelected ? kSearchColorButton : Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text: '$count',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: isSelected ? kSearchColorButton : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

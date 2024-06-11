import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:themoviedb/constants.dart';


class QtyMovies extends StatelessWidget {
  const QtyMovies({
    Key? key,
    required this.qtyMovie,
    required this.qtySeries,
    required this.movieLanguage,
  }) : super(key: key);

  final int qtyMovie;
  final int qtySeries;
  final String movieLanguage;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: kTextDetailsColor, fontSize: 18.sp),
        children: <TextSpan>[
          TextSpan(text: '📽  $movieLanguage: '),
          TextSpan(
              text: '$qtyMovie',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          const TextSpan(text: '       📺  Series: '),
          TextSpan(
              text: '$qtySeries',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

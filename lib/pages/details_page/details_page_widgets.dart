import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/responsive.dart';

import 'details_page.dart';

class OverviewText extends StatelessWidget {
  const OverviewText({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.movie.overview,
      overflow: TextOverflow.ellipsis,
      maxLines: 10,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 12.sp, color: kTextDetailsColor),
    );
  }
}

class GenresListCard extends StatelessWidget {
  const GenresListCard({
    Key? key,
    required this.moviesProvider,
  }) : super(key: key);

  final MoviesProvider moviesProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.sp,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: moviesProvider.movieDetails.genres!.length,
          itemBuilder: (context, index) {
            String genres = moviesProvider.movieDetails.genres![index].name!;
            return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10.sp),
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.sp)),
                child: Text(
                  genres,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ));
          }),
    );
  }
}

class CastMovie extends StatelessWidget {
  const CastMovie({
    Key? key,
    required this.performers,
  }) : super(key: key);

  final List performers;

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizeScreen.isTablet(context);
    double sizeBoxHeight = 130.sp;
    return SizedBox(
        height: sizeBoxHeight,
        width: 300.sp,
        child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            padEnds: false,
            pageSnapping: false,
            controller: PageController(
              initialPage: 0,
              viewportFraction: isTablet ? 0.2 : 0.35,
            ),
            itemCount: performers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8.sp, 0),
                child: Column(
                  children: [
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0.sp),
                        child: FadeInImage(
                            height: sizeBoxHeight * 0.9,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'lib/assets/images/no-image.jpg',
                                  fit: BoxFit.fitWidth);
                            },
                            placeholder: const AssetImage(
                                'lib/assets/images/no-image.jpg'),
                            image: NetworkImage(performers[index].getPhoto())),
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      performers[index].name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }));
  }
}

class MovieDetailsInfo extends StatelessWidget {
  const MovieDetailsInfo({
    Key? key,
    required this.size,
    required this.moviesProvider,
    required this.movie,
  }) : super(key: key);

  final Size size;
  final MoviesProvider moviesProvider;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizeScreen.isTablet(context);
    return SizedBox(
      height: SizeScreen.getHeight(context) * 0.7,
      child: Row(
        children: [
          SizedBox(
            width: isTablet ? SizeScreen.getWidth(context) * 0.2 : SizeScreen.getWidth(context) * 0.23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.sp),
                const CustomBackButton(),
                const Spacer(),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    moviesProvider.releaseDate.substring(0, 7),
                    style: TextStyle(
                        color: Colors.white, fontSize: kDescriptionDetailsText),
                  ),
                ),
                SizedBox(height: 8.sp),
                Icon(
                  Icons.calendar_today_rounded,
                  size: kDescriptionDetailsText + 6,
                  color: Colors.white,
                ),
                isTablet ? SizedBox(height: 50.sp) : const Spacer(),
                RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      moviesProvider.duration,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: kDescriptionDetailsText),
                    )),
                SizedBox(height: 8.sp),
                Icon(
                  Icons.access_time,
                  size: kDescriptionDetailsText + 8,
                  color: Colors.white,
                ),
                isTablet ? SizedBox(height: 50.sp) : const Spacer(),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    movie.voteAverage.toString(),
                    style: TextStyle(
                        color: Colors.white, fontSize: kDescriptionDetailsText),
                  ),
                ),
                SizedBox(height: 8.sp),
                Icon(
                  Icons.star,
                  size: kDescriptionDetailsText + 10,
                  color: Colors.yellowAccent,
                ),
                //SizedBox(height: 10.sp),
              ],
            ),
          ),
          Expanded(
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20.sp)),
                  child: PosterImage(
                    image: movie.getPosterImg(),

                  )))
        ],
      ),
    );
  }
}

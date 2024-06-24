import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/details_page/details_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/top_button_provider.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(
      {Key? key, required this.movie, required this.index, required this.type})
      : super(key: key);

  final Movie movie;
  final int index;
  final String type;

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(32.w),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.sp),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32.w),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.w),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: DetailsPage(movie: movie, type: type),
                            childCurrent: this,
                          ),
                        );
                      },
                      child: PosterImage(image: movie.getPosterImg()),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6.sp),
                      width: 40.w,
                      height: 75.sp,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 10,
                            blurRadius: 25,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFFF83A43), Color(0xB0F83A43)],
                        ),
                        borderRadius: BorderRadius.circular(30.sp),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.sp),
                            decoration: const BoxDecoration(
                              color: Color(0xFF323E4B),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            movie.voteAverage.toStringAsFixed(1).toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              movie.title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage(
      {Key? key,
        required this.backgroundPageController,
        required this.movies,
        required this.pageValue})
      : super(key: key);

  final PageController backgroundPageController;
  final List<Movie> movies;
  final double pageValue;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(children: [
      SizedBox(
          width: size.width,
          height: size.height,
          child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: backgroundPageController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Opacity(
                    opacity: (1 - (index - pageValue).abs()).clamp(0, 1),
                    child: PosterImage(
                      image: movies[index].getPosterImg(),
                    )
                );
              }))
    ]);
  }
}

class MovieListCards extends StatelessWidget {
  const MovieListCards({
    Key? key,
    required this.pageController,
    required this.movies,
    required this.pageValue,
  }) : super(key: key);

  final PageController pageController;
  final List<Movie>? movies;
  final double pageValue;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        pageSnapping: true,
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        itemCount: movies!.length,
        itemBuilder: (context, index) {
          if (index == pageValue.floor() + 1 ||
              index == pageValue.floor() + 2) {
            return Transform.translate(
                offset: Offset(0.0, 100 * (index - pageValue)),
                child: MovieCard(
                  movie: movies![index],
                  index: index,
                  type: Provider.of<TopButtonModel>(context).type,
                ));
          } else if (index == pageValue.floor() ||
              index == pageValue.floor() - 1) {
            return Transform.translate(
                offset: Offset(0.0, 100 * (pageValue - index)),
                child: MovieCard(
                  movie: movies![index],
                  index: index,
                  type: Provider.of<TopButtonModel>(context).type,
                ));
          } else {
            return MovieCard(
              movie: movies![index],
              index: index,
              type: Provider.of<TopButtonModel>(context).type,
            );
          }
        });
  }
}

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.8]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/details_page/details_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/providers/top_button_provider.dart';
import 'package:themoviedb/responsive.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(
      {Key? key, required this.movie, required this.index, required this.type})
      : super(key: key);
  final Movie movie;
  final int index;
  final String type;

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizeScreen.isTablet(context);
    double scale =
        isTablet ? kSizePosterCoefficientTablet : kSizePosterCoefficientPhone;

    return Container(
      /*margin: EdgeInsets.fromLTRB(10.sp,
          isTablet ? 150.sp : (SizeScreen.diagonal(context) * 0.21).sp, 10.0.sp, 0.0),*/
      margin: EdgeInsets.fromLTRB(10.sp,
          (SizeScreen.diagonal(context) * 0.21).sp, 10.0.sp, 0.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(
                0.9,
              ),
              blurRadius: 30),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 32.sp : 32.sp),
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.sp, 18.sp, 16.sp, 0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isTablet ? 16.sp : 16.sp),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: DetailsPage(movie: movie, type: type),
                                childCurrent: this));
                      },
                      child: AspectRatio(
                          aspectRatio: isTablet ? 11 / 16 : 9 / 16,
                          child: PosterImage(
                              image: movie.getPosterImg(), scale: scale))),
                ),
                const Spacer(),
                Text(
                  movie.title.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    //fontSize: 20.0 * dg * 0.0012,
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isTablet ? SizedBox(height: 30.sp) : SizedBox(height: 30.sp),
              ],
            ),
          ),
          Align(
            alignment: Alignment(isTablet ? 0.58.sp : 0.70.sp, isTablet ? 0.43.sp : 0.7),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 50.sp,
              height: 90.sp,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFF83A43), Color(0xB0F83A43)],
                ),
                borderRadius: BorderRadius.circular(isTablet ? 30.sp : 30.sp),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 6.sp : 8.sp),
                    decoration: const BoxDecoration(
                        color: Color(0xFF323E4B), shape: BoxShape.circle),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: isTablet ? 30.sp : 20.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    movie.voteAverage.toStringAsFixed(1).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),
                  isTablet ? SizedBox(height: 4.sp) : SizedBox(height: 5.sp),
                ],
              ),
            ),
          ),
        ],
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
                    scale: 1,
                  ),
                );
              }))
    ]);
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.moviesProvider,
    required this.language,
    required this.onPressed,
  }) : super(key: key);

  final MoviesProvider moviesProvider;
  final String language;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          side:  BorderSide(
            width: 2.sp,
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 15.0.sp,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Text(
              language,
              style:  TextStyle(fontSize: 16.sp),
            ),
          ],
        ));
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

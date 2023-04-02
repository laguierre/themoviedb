import 'package:flutter/material.dart';
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
    double dg = SizeScreen.diagonal(context);
    bool isTablet = SizeScreen.isTablet(context);
    double scale = isTablet? kSizePosterCoefficientTablet : kSizePosterCoefficientPhone;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 220, 10.0, 0.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(
                0.9,
              ),
              blurRadius: 30),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 48 : 32),
        ),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isTablet ? 32 : 16),
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
                          child: PosterImage(image: movie.getPosterImg(), scale: scale))),
                ),
                const Spacer(),
                Text(
                  movie.title.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.0 * dg * 0.0012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isTablet
                    ? const SizedBox(height: 45)
                    : const SizedBox(height: 30),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0.88, 0.72),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 100 * dg * 0.001,
              width: 50 * dg * 0.0012,
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
                borderRadius: BorderRadius.circular(isTablet? 40 : 30),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 14 : 8),
                    decoration: const BoxDecoration(
                        color: Color(0xFF323E4B), shape: BoxShape.circle),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: isTablet? 30 : 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    movie.voteAverage.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20 * dg * 0.001),
                  ),
                  isTablet
                      ? const SizedBox(height: 12)
                      : const SizedBox(height: 5),
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
          side: const BorderSide(
            width: 2,
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 15.0,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Text(
              language,
              style: const TextStyle(fontSize: 16),
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

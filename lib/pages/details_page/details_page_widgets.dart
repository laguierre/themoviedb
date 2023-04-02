import 'package:flutter/material.dart';
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
      style: TextStyle(fontSize: 16, color: kTextDetailsColor),
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
      height: 35,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: moviesProvider.movieDetails.genres!.length,
          itemBuilder: (context, index) {
            String genres = moviesProvider.movieDetails.genres![index].name!;
            return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
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
    return SizedBox(
        height: 200,
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
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage(
                        height: 150.0,
                        width: 110,
                        fit: BoxFit.cover,
                        imageErrorBuilder:(context, error, stackTrace) {
                          return Image.asset('lib/assets/images/no-image.jpg',
                              fit: BoxFit.fitWidth
                          );
                        },
                        placeholder:
                            const AssetImage('lib/assets/images/no-image.jpg'),
                        image: NetworkImage(performers[index].getPhoto())),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    performers[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
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
    double scale = isTablet? kSizePosterCoefficientTablet : kSizePosterCoefficientPhone;
    return SizedBox(
      height: size.height * scale,
      child: Row(
        children: [
          SizedBox(
            width: isTablet ? size.width * 0.12 : size.width * 0.3,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const CustomBackButton(),
                isTablet? const SizedBox(height: 50): const Spacer(),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    moviesProvider.releaseDate.substring(0, 7),
                    style: const TextStyle(
                        color: Colors.white, fontSize: kDescriptionDetailsText),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: kDescriptionDetailsText + 6,
                  color: Colors.white,
                ),
                isTablet? const SizedBox(height: 50): const Spacer(),
                RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      moviesProvider.duration,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: kDescriptionDetailsText),
                    )),
                const SizedBox(height: 10),
                const Icon(
                  Icons.access_time,
                  size: kDescriptionDetailsText + 8,
                  color: Colors.white,
                ),
                isTablet? const SizedBox(height: 50): const Spacer(),

                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    movie.voteAverage.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: kDescriptionDetailsText),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.star,
                  size: kDescriptionDetailsText + 10,
                  color: Colors.yellowAccent,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(30)),
                  child: PosterImage(
                    image: movie.getPosterImg(),
                    scale: isTablet
                        ? kSizePosterCoefficientTablet
                        : kSizePosterCoefficientPhone,
                  )))
        ],
      ),
    );
  }
}

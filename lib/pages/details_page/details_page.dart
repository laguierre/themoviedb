import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/cast_model.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/providers/top_button_provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);
    return Scaffold(
        body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF0D0D0D),
                  Color(0xFF1A1A1A),
                ])),
            child: FutureBuilder(
                future: moviesProvider.getDetails(
                    widget.movie.id.toString(),
                    Provider.of<TopButtonModel>(context).type),
                builder: (context, AsyncSnapshot<MovieDetails> snapshot) {
                  if (snapshot.hasData) {

                    return FutureBuilder(
                        future: moviesProvider.getCast(
                            (widget.movie.id).toString(),
                            Provider.of<TopButtonModel>(context).type),
                        builder:
                            (context, AsyncSnapshot<List<Actor>> snapshot) {
                          if ((snapshot.hasData)) {
                            final performers = snapshot.data;
                            return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(children: [
                                  MovieDetailsInfo(
                                      size: size,
                                      moviesProvider: moviesProvider,
                                      movie: widget.movie),
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 30, 20, 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.movie.title,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: kTextDetailsColor),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              widget.movie.overview,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kTextDetailsColor),
                                            ),
                                            const SizedBox(height: 20),
                                            GenresListCard(
                                                moviesProvider: moviesProvider),
                                            const SizedBox(height: 20),
                                            CastMovie(performers: performers!),
                                          ]))
                                ]));
                          } else {
                            return const CustomGIF();
                          }
                        });
                  } else {
                    return const CustomGIF();
                  }
                })));
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
    return SizedBox(
        height: 200,
        child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            padEnds: false,
            pageSnapping: false,
            controller: PageController(
              initialPage: 1,
              viewportFraction: 0.35,
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
    return SizedBox(
      height: size.height * 0.55,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2C2C),
                    borderRadius: BorderRadius.circular(15),
                    //shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.only(left: 10),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(),
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
                const Spacer(),
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
                const Spacer(),
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
                  child: PosterImage(image: movie.getPosterImg())))
        ],
      ),
    );
  }
}

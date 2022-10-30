import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/providers/movie_provider.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({
    Key? key,
    required this.enabled,
    required this.onTapBack,
    required this.focusNode,
    required this.textController,
    required this.onTapSearch,
  }) : super(key: key);
  final bool enabled;
  final VoidCallback onTapBack;
  final VoidCallback onTapSearch;
  final FocusNode focusNode;
  final TextEditingController textController;

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  void initState() {
    widget.textController.addListener(() {
      Provider
          .of<MoviesProvider>(context, listen: false)
          .query = widget.textController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 45, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(color: kSearchColorTextField, width: 2),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.8)),
      child: Row(
        children: [
          if (widget.enabled)
            IconButton(
                color: kSearchColorTextField,
                padding: const EdgeInsets.all(0),
                onPressed: widget.onTapBack,
                icon: const Icon(Icons.arrow_back_ios)),
          Expanded(
            child: TextField(
              onChanged: (text) {
                // Provider.of<MoviesProvider>(context, listen: false).query =        text;
              },
              focusNode: widget.focusNode,
              controller: widget.textController,
              enabled: widget.enabled,
              autofocus: widget.enabled,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.none),
                contentPadding:
                EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 20.0,
                decoration: TextDecoration.none,
                color: kSearchColorTextField,
              ),
            ),
          ),
          IconButton(
              color: kSearchColorTextField,
              padding: const EdgeInsets.all(0),
              onPressed: widget.onTapSearch,
              icon: const Icon(Icons.search)),
        ],
      ),
    );
  }
}

class PosterImage extends StatelessWidget {
  const PosterImage({
    Key? key,
    required this.image,
    this.scale = kSizePosterCoefficient,
  }) : super(key: key);
  final String image;
  final double scale;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return FadeInImage(
      fadeInDuration: const Duration(milliseconds: 150),
      height: size.height * scale,
      fit: BoxFit.cover,
      placeholder: const AssetImage('lib/assets/images/no-image.jpg'),
      image: NetworkImage(image),
    );
  }
}

class CustomGIF extends StatelessWidget {
  const CustomGIF({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 80, child: Image.asset('lib/assets/images/loading.gif')));
  }
}

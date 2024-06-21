import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_fade/image_fade.dart';
import 'package:themoviedb/constants.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({
    Key? key,
    required this.enabled,
    required this.onTapBack,
    required this.focusNode,
    required this.textController,
    required this.onTapSearch,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onTapBack;
  final VoidCallback onTapSearch;
  final FocusNode focusNode;
  final TextEditingController textController;
  final ValueChanged<String> onFieldSubmitted;

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  late GlobalKey<FormFieldState<String>> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormFieldState<String>>();
    super.initState();
    widget.textController.addListener(() {});
    // Solicita el foco al iniciar
    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.focusNode.requestFocus(FocusNode());

      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 40.sp,
      margin: EdgeInsets.fromLTRB(20.sp, 40.sp, 20.sp, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Row(
        children: [
          if (widget.enabled)
            IconButton(
              color: Colors.black,
              padding: const EdgeInsets.all(0),
              onPressed: widget.onTapBack,
              icon: Icon(Icons.arrow_back_ios, size: 16.sp),
            ),
          Expanded(
            child: TextFormField(
              key: formKey,
              focusNode: widget.focusNode,
              controller: widget.textController,
              enabled: widget.enabled,
              keyboardType: TextInputType.text,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: const TextStyle(
                    color: Colors.grey, decoration: TextDecoration.none),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 6.sp, horizontal: 6.sp),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 16.0.sp,
                decoration: TextDecoration.none,
                color: Colors.black,
              ),
              onTap: () {
                widget.focusNode.requestFocus(FocusNode());

              },
            ),
          ),
          IconButton(
            color: Colors.black,
            padding: const EdgeInsets.all(0),
            onPressed: widget.onTapSearch,
            icon: Icon(Icons.search, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
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
            width: 80.sp, child: Image.asset('lib/assets/images/loading.gif')));
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C2C),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: IconButton(
        padding: EdgeInsets.only(left: 7.sp),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class PosterImage extends StatelessWidget {
  const PosterImage({
    Key? key,
    this.image =
        'https://cdn11.bigcommerce.com/s-auu4kfi2d9/stencil/59512910-bb6d-0136-46ec-71c445b85d45/e/933395a0-cb1b-0135-a812-525400970412/icons/icon-no-image.svg',
  }) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return ImageFade(
      image: NetworkImage(image),
      duration: const Duration(milliseconds: 500),
      syncDuration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      fit: BoxFit.cover,
      placeholder:
          Image.asset('lib/assets/images/no-image.jpg', fit: BoxFit.fitHeight),
      errorBuilder: (context, error) => Container(
        color: const Color(0xFF6F6D6A),
        alignment: Alignment.center,
        child: const Icon(
          Icons.warning,
          color: Colors.black26,
          size: 128.0,
        ),
      ),
    );
  }
}

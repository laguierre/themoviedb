class MovieCollection {
  int id;
  String title;
  double rating;
  String type;
  String date;

  MovieCollection({
    required this.id,
    required this.title,
    required this.rating,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'rating': rating,
        'type': type,
        'date': date,
      };

  static MovieCollection fromJson(Map<String, dynamic> json) => MovieCollection(
        id: json['id'],
        title: json['title'],
        rating: json['rating'],
        type: json['type'],
        date: json['date'],
      );
}

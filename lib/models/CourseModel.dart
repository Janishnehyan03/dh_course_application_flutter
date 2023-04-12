class Course {
  final String title;
  final String price;
  final String id;
  final String imageUrl;
  final String description;
  final String slug;
  final List<Video> videos;

  Course(
      {required this.title,
      required this.price,
      required this.videos,
      required this.id,
      required this.description,
      required this.imageUrl,
      required this.slug});

  factory Course.fromJson(dynamic json) {
    List<Video> videos = [];
    if (json['videos'] != null) {
      var videoList = json['videos'] as List;
      videos = videoList.map((video) => Video.fromJson(video)).toList();
    }

    return Course(
        title: json['title'],
        price: json['price'].toString(),
        videos: videos,
        id: json['_id'],
        imageUrl: json['thumbnail'],
        description: json['description'],
        slug: json['slug']);
  }

  static List<Course> coursesFromSnapShot(List snapShot) {
    return snapShot.map((data) {
      return Course.fromJson(data);
    }).toList();
  }
}

class Video {
  String title;

  Video({
    required this.title,
  });

  factory Video.fromJson(dynamic json) {
    return Video(
      title: json['videoTitle'],
      // url: json['videoUrl'],
    );
  }
}

class Photo {
  final String title;
  final String url;
  Photo.fromJsonMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        url = map['url'];
}

import 'package:equatable/equatable.dart';

class PicsumPhoto extends Equatable {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  const PicsumPhoto({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PicsumPhoto.fromJson(Map<String, dynamic> json) {
    return PicsumPhoto(
      id: json['id'] as String,
      author: json['author'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'width': width,
      'height': height,
      'url': url,
      'download_url': downloadUrl,
    };
  }

  @override
  List<Object?> get props => [id, author, width, height, url, downloadUrl];

  @override
  String toString() {
    return 'PicsumPhoto(id: $id, author: $author, width: $width, height: $height)';
  }
}

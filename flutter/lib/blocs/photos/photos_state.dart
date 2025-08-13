import 'package:equatable/equatable.dart';
import '../../models/picsum_photo.dart';

enum PhotosStatus { initial, loading, success, failure, loadingMore }

class PhotosState extends Equatable {
  final PhotosStatus status;
  final List<PicsumPhoto> photos;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const PhotosState({
    this.status = PhotosStatus.initial,
    this.photos = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  PhotosState copyWith({
    PhotosStatus? status,
    List<PicsumPhoto>? photos,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return PhotosState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        photos,
        errorMessage,
        currentPage,
        hasReachedMax,
      ];
}

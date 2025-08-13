import 'package:equatable/equatable.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];
}

class PhotosLoadRequested extends PhotosEvent {
  final int page;
  final int limit;

  const PhotosLoadRequested({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object> get props => [page, limit];
}

class PhotosRefreshRequested extends PhotosEvent {
  const PhotosRefreshRequested();
}

class PhotosLoadMoreRequested extends PhotosEvent {
  const PhotosLoadMoreRequested();
}

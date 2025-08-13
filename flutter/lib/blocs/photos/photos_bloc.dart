import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/picsum_repository.dart';
import '../../models/picsum_photo.dart';
import 'photos_event.dart';
import 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PicsumRepository repository;

  PhotosBloc({required this.repository}) : super(const PhotosState()) {
    on<PhotosLoadRequested>(_onLoadRequested);
    on<PhotosRefreshRequested>(_onRefreshRequested);
    on<PhotosLoadMoreRequested>(_onLoadMoreRequested);
  }

  Future<void> _onLoadRequested(
    PhotosLoadRequested event,
    Emitter<PhotosState> emit,
  ) async {
    emit(state.copyWith(status: PhotosStatus.loading));

    try {
      final photos = await repository.getPhotos(
        page: event.page,
        limit: event.limit,
      );

      emit(
        state.copyWith(
          status: PhotosStatus.success,
          photos: photos,
          currentPage: event.page,
          hasReachedMax: photos.length < event.limit,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PhotosStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    PhotosRefreshRequested event,
    Emitter<PhotosState> emit,
  ) async {
    emit(const PhotosState(status: PhotosStatus.loading));

    try {
      final photos = await repository.getPhotos(page: 1, limit: 10);

      emit(
        PhotosState(
          status: PhotosStatus.success,
          photos: photos,
          currentPage: 1,
          hasReachedMax: photos.length < 10,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PhotosStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    PhotosLoadMoreRequested event,
    Emitter<PhotosState> emit,
  ) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: PhotosStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final newPhotos = await repository.getPhotos(page: nextPage, limit: 10);

      emit(
        state.copyWith(
          status: PhotosStatus.success,
          photos: List.of(state.photos)..addAll(newPhotos),
          currentPage: nextPage,
          hasReachedMax: newPhotos.length < 10,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PhotosStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

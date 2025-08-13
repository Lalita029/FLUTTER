import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/photos/photos_bloc.dart';
import '../blocs/photos/photos_event.dart';
import '../blocs/photos/photos_state.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../models/picsum_photo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PhotosBloc>().add(const PhotosLoadRequested(limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo Gallery',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PhotosBloc>().add(const PhotosLoadRequested(limit: 10));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginBloc>().add(const LoginLogoutRequested());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<PhotosBloc, PhotosState>(
        builder: (context, state) {
          switch (state.status) {
            case PhotosStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PhotosStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load photos',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Unknown error',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PhotosBloc>().add(const PhotosLoadRequested(limit: 10));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case PhotosStatus.success:
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PhotosBloc>().add(const PhotosLoadRequested(limit: 10));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: state.photos.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _PhotoListItem(photo: state.photos[index]);
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

class _PhotoListItem extends StatelessWidget {
  final PicsumPhoto photo;

  const _PhotoListItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth - 24; // Subtract horizontal padding (12px * 2)
    final imageHeight = imageWidth * photo.height / photo.width; // Calculate height from aspect ratio

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Image.network(
              photo.downloadUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Title (Author)
        Text(
          photo.author,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, // Semi-Bold
            color: Colors.black87, // Dark text color
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        // Description
        Text(
          'Photo #${photo.id} — ${photo.url}',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, // Regular
            color: Colors.grey[700], // Dark grey color
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

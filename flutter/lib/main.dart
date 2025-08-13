import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'repositories/picsum_repository.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/photos/photos_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PicsumRepository>(
          create: (context) => PicsumRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          BlocProvider<PhotosBloc>(
            create: (context) => PhotosBloc(
              repository: context.read<PicsumRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Picsum App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.montserratTextTheme(),
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

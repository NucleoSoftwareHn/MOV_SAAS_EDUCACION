import 'package:flutter/material.dart';
import 'package:flutter_nodejs_base/models/features/auth/user_model.dart';
import 'package:flutter_nodejs_base/screens/features/docentes/docente_screen.dart';
import 'package:flutter_nodejs_base/screens/layout/home_screen.dart'; 

class AppRoutes {
AppRoutes._();

  static const String home = '/home';
  static const String docente = '/docente';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(user: user),
          settings: settings,
        );

      case docente:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => DocentesScreen(user: user),
          settings: settings,
        ); 

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
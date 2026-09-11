import 'package:flutter/material.dart';
import 'package:flutter_nodejs_base/models/features/auth/user_model.dart';
import 'package:flutter_nodejs_base/screens/layout/custom_drawer.dart'; 

class DocentesScreen extends StatelessWidget {
  final UserModel user;

  const DocentesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Docentes'),
      ),
      // Al colocar CustomDrawer aquí, reaparece el botón hamburguesa automáticamente
      drawer: CustomDrawer(user: user), 
      body: const Center(
        child: Text('Contenido de Docentes'),
      ),
    );
  }
}
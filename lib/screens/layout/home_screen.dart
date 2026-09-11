import 'package:flutter/material.dart';
import 'package:flutter_nodejs_base/screens/layout/custom_drawer.dart';
import 'package:flutter_nodejs_base/shared/theme/app_colors.dart';
import '../../models/features/auth/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'analytics':
        return Icons.analytics_outlined;
      case 'people':
        return Icons.people_outline;
      case 'settings':
        return Icons.settings_outlined;
      case 'bus':
        return Icons.directions_bus_outlined;
      case 'restaurant':
        return Icons.restaurant_menu_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Panel Principal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.notifications_outlined, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.red,
                  ),
                )
              ],
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text(
                user.nombre.isNotEmpty ? user.nombre[0].toUpperCase() : 'U',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryColor),
              ),
            ),
          ),
        ],
      ),

      drawer: CustomDrawer(user: user),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo superior
              Text(
                '¡Bienvenido, ${user.nombre}!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              // Banner / Tarjeta de resumen superior (Similiar a la tarjeta de la imagen)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor.withOpacity(0.8), primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portal Activo',
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gestión y Módulos del Sistema',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified_user_outlined, color: Colors.white, size: 40),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Módulos Habilitados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              // Grid / Wrap de Módulos Centrales con diseño moderno
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                ),
                itemCount: user.centerModules.length,
                itemBuilder: (context, index) {
                  final mod = user.centerModules[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_getIconData(mod.ICONO), color: primaryColor, size: 24),
                        ),
                        const Spacer(),
                        Text(
                          mod.PANTALLA,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
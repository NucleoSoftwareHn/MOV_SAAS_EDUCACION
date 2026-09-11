import 'package:flutter/material.dart';
import 'package:flutter_nodejs_base/shared/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/features/auth/user_model.dart';
import '../../../services/features/auth/auth_service.dart';
import '../../screens/login/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  final UserModel user;

  const CustomDrawer({super.key, required this.user});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late List<dynamic> _currentDrawerMenu;
  bool _showingCenterModules = false;

  @override
  void initState() {
    super.initState();
    _currentDrawerMenu = widget.user.hamburgerMenu;
  }

  void _loadCenterModulesInDrawer() {
    setState(() {
      _currentDrawerMenu = widget.user.centerModules;
      _showingCenterModules = true;
    });
  }

  void _resetToHamburgerMenu() {
    setState(() {
      _currentDrawerMenu = widget.user.hamburgerMenu;
      _showingCenterModules = false;
    });
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'analytics':
        return Icons.analytics_outlined;
      case 'people':
        return Icons.people_outline;
      case 'settings':
        return Icons.settings_outlined;
      case 'calendar':
        return Icons.calendar_today_outlined;
      case 'documents':
        return Icons.description_outlined;
      case 'help':
        return Icons.help_outline;
      default:
        return Icons.dashboard_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER CON LOGO Y TÍTULO (Estilo Nexora)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  // Logo (puedes reemplazar con Image.asset si lo tienes en assets)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Nexora',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Perfil del Usuario Compacto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      widget.user.nombre.isNotEmpty ? widget.user.nombre[0].toUpperCase() : 'U',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Padre / Tutor', // O puedes usar un campo de rol de tu user model si lo tienes
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Divider(color: Color(0xFFE2E8F0)),
            ),

            // 2. BOTÓN DE INICIO FIJO CON ESTILO SELECCIONADO (PÍLDORA)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _buildDrawerItem(
                icon: Icons.home_rounded,
                title: 'Inicio',
                isSelected: currentRoute == AppRoutes.home && !_showingCenterModules,
                onTap: () {
                  Navigator.pop(context);
                  if (currentRoute == AppRoutes.home) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                    arguments: widget.user,
                  );
                },
              ),
            ),

            // Botón para alternar módulos centrales si lo deseas mantener
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: _buildDrawerItem(
                icon: _showingCenterModules ? Icons.menu : Icons.widgets_outlined,
                title: _showingCenterModules ? 'Menú Principal' : 'Módulos Centrales',
                isSelected: false,
                onTap: () {
                  if (_showingCenterModules) {
                    _resetToHamburgerMenu();
                  } else {
                    _loadCenterModulesInDrawer();
                  }
                },
              ),
            ),

            const SizedBox(height: 4),

            // 3. LISTA DINÁMICA DE OPCIONES
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                children: _currentDrawerMenu.map((mod) {
                  final routeName = mod.URL != null && mod.URL.startsWith('/') ? mod.URL : '/${mod.URL}';
                  final isActive = currentRoute == routeName;

                  return _buildDrawerItem(
                    icon: _getIconData(mod.ICONO),
                    title: mod.PANTALLA,
                    isSelected: isActive,
                    onTap: () {
                      Navigator.pop(context);
                      if (mod.URL != null && mod.URL.isNotEmpty) {
                        if (currentRoute == routeName) return;
                        Navigator.pushNamed(context, routeName, arguments: widget.user);
                      }
                    },
                  );
                }).toList(),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Color(0xFFE2E8F0)),
            ),

            // 4. CERRAR SESIÓN
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildDrawerItem(
                icon: Icons.logout_rounded,
                title: 'Cerrar sesión',
                isDestructive: true,
                isSelected: false,
                onTap: () async {
                  await AuthService().logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para mantener el estilo de píldora redondeada de los ítems
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive 
        ? Colors.red 
        : (isSelected ? AppColors.primary : const Color(0xFF475569));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
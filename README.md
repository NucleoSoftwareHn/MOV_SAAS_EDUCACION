<<<<<<< HEAD
# MOV_SAAS_EDUCACION
Repositorio para el aplicativo móvil 
=======
# Flutter Node.js Base

Proyecto base Flutter preparado para consumir un backend Node.js.

## Requisitos

- Flutter instalado
- Dart incluido con Flutter
- Android Studio/Xcode según plataforma

## Ejecutar

```bash
flutter pub get
flutter run
```

## Generar modelos

El proyecto incluye `json_serializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Para desarrollo:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Configuración del backend

Editar:

`lib/core/constants/api_config.dart`

Android Emulator:

```dart
static const String baseUrl = 'http://10.0.2.2:3001/api/dev';
```

iOS Simulator / escritorio:

```dart
static const String baseUrl = 'http://localhost:3001/api/dev';
```

Dispositivo físico:

```dart
static const String baseUrl = 'http://IP_DE_TU_PC:3001/api/dev';
```

## Login

El ejemplo asume:

`POST /login`

con:

```json
{
  "usuario": "usuario",
  "password": "password"
}
```

Y opcionalmente una respuesta con:

```json
{
  "token": "JWT",
  "usuario_data": {
    "P_USUARIO": "usuario"
  }
}
```

Adapta `AuthService` si tu API usa nombres diferentes.

## Importante para Android

Si tu backend usa HTTP (no HTTPS), el proyecto necesitará permitir tráfico HTTP en Android para algunos escenarios. Para desarrollo local, se puede habilitar en `android/app/src/main/AndroidManifest.xml`.
>>>>>>> 65ae6a2 (Primer commit)

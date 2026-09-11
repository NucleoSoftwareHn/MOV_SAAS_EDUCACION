import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(name: 'P_USUARIO')
  final String usuario;

  LoginModel({
    required this.usuario,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}


class ModuleModel {
  final int    ID_PANTALLA;
  final String PANTALLA;
  final String URL;
  final String ICONO;
  final int    UBICACION_ID; 

  ModuleModel({
    required this.ID_PANTALLA,
    required this.PANTALLA,
    required this.URL,
    required this.ICONO,
    required this.UBICACION_ID,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      ID_PANTALLA  : json['ID_PANTALLA']  ?? 0,
      PANTALLA     : json['PANTALLA']     ?? json['PANTALLA'] ?? '',
      URL          : json['URL']          ?? json['URL'],
      ICONO        : json['ICONO']        ?? json['ICONO'],
      UBICACION_ID : json['UBICACION_ID'] ?? 1,
    );
  }
}


class UserModel {
  final int UUID;
  final int UUID2;
  final String usuario;
  final String nombre;
  final List<ModuleModel> modules;

  UserModel({
    required this.UUID,
    required this.UUID2,
    required this.usuario,
    required this.nombre,
    required this.modules,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      UUID: json['UUID'] ?? 0,
      UUID2: json['UUID2'] ?? 0,
      usuario: json['USUARIO'] ?? '',
      nombre: json['nombre'] ?? 'Mario Velasquez',
      modules: (json['dataAccesos'] as List<dynamic>?)
              ?.map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Getters auxiliares para filtrar según la ubicación deseada
  List<ModuleModel> get hamburgerMenu =>
      modules.where((m) => m.UBICACION_ID == 1).toList();

  List<ModuleModel> get centerModules =>
      modules.where((m) => m.UBICACION_ID == 2).toList();

  List<ModuleModel> get footerLinks =>
      modules.where((m) => m.UBICACION_ID == 3).toList();
}
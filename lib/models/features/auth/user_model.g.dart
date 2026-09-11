
part of 'user_model.dart';

LoginModel _$UserModelFromJson(Map<String, dynamic> json) => LoginModel(
      usuario: json['P_USUARIO'] as String,
    );

Map<String, dynamic> _$UserModelToJson(LoginModel instance) => <String, dynamic>{
      'P_USUARIO': instance.usuario,
    };

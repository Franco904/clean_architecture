import 'package:clean_architecture/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    return RemoteAccountModel(accessToken: json['accessToken']);
  }

  Account toEntity() => Account(token: accessToken);
}

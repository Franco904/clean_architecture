import '../../domain/domain.dart';
import '../utils/utils.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('accessToken')) throw HttpError.invalidData;

    return RemoteAccountModel(accessToken: json['accessToken']);
  }

  Account toEntity() => Account(token: accessToken);
}

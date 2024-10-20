import 'package:realm/realm.dart';

// Define the UserModel class extending RealmObject
part 'user_model.realm.dart';

@RealmModel()
class _UserModel {
  @PrimaryKey()
  late String id;

  late String accessToken;
  late String refreshToken;
}

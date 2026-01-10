import 'package:warehouse/utils/storage_service.dart';

const user_key = "user";

createUser({id, user_name}) async {
  var obj = {"username": user_name, "id": id};

  await saveJson(user_key, obj);
}

deleteUser() async {
  await deleteJson(user_key);
}

getUserId() async {
  var user = await loadJson(user_key);
  return user['id'];
}

getUser() async {
  var user = await loadJson(user_key);
  return user;
}

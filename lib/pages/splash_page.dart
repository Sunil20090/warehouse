import 'package:flutter/material.dart';
import 'package:warehouse/constants/image_constant.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/pages/home_page.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';
import 'package:warehouse/utils/user_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    login().then((value) {
      if (value) {
        moveToDashboard();
      } else {}
    });
  }

  Future<bool> login() async {
    var body = {"username": "sunil.k20090", "password": "hello@12345"};

    ApiResponse response = await postService(URL_LOGIN, body);

    if (response.isSuccess) {
      if (response.body['status'] == "OK") {
        await createUser(
          user_name: response.body["username"],
          id: response.body['id'],
        );
        return true;
      } else {
        showAlert(context, response.body['heading'], response.body['message']);
        return false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLOR_WHITE,
      alignment: Alignment.center,
      child: SizedBox(width: 50, height: 50, child: Image.asset(ICON_APP_ICON)),
    );
  }

  moveToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (builder) => HomePage()),
    );
  }
}

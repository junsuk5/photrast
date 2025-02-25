import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project/repository/test_repository.dart';
import 'package:project/ui/diary_folder/diary_list.dart';
import 'package:project/ui/diary_maker/diary_maker.dart';
import 'package:project/ui/diary_maker/diary_timeLine.dart';
import 'package:project/ui/kakao_map/map_init.dart';
import 'package:project/ui/phot_appbar.dart';
import 'package:project/ui/main_ui.dart';
import 'package:project/util/camera_app.dart';
import 'package:project/viewmodel/map_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<TestRepository>(
      create: (context) => TestRepository(),
    ),
    ChangeNotifierProvider<MapViewModel>(
      create: (context) => MapViewModel(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF63C0C2),
        accentColor: Color(0xFF48AAAC),
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline2: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline4:
              TextStyle(fontSize: 18.0, color: Color.fromRGBO(82, 82, 82, 1)),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Photrast(),
    );
  }
}

class Photrast extends StatelessWidget {
  const Photrast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PhotAppBar(),
      // 백그라운드 이미지 Container
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/first_bg.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // 흰 테두리
                  Positioned(
                    top: mediaSize.height / 4,
                    left: (mediaSize.width - 300) / 3,
                    child: Container(
                      height: 300,
                      width: 300,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        color: Colors.transparent,
                      ),
                      child: Material(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    top: mediaSize.height / 4 + 50,
                    left: (mediaSize.width - 300) / 3 + 50,
                    child: Text(
                      ' 당신의\n 여행을\n 시작하시겠습니까?',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  // 로고 이미지
                  Positioned(
                    top: mediaSize.height / 4 + 200,
                    left: mediaSize.width / 2 - 20,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainUi()),
                      ),
                      child: Image.asset(
                        'assets/logo_img.png',
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

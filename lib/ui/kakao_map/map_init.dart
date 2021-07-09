import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/viewmodel/test_result.dart';
import 'package:project/viewmodel/map_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MapInit extends StatefulWidget {
  const MapInit({Key? key}) : super(key: key);

  @override
  _MapInitState createState() => _MapInitState();
}

class _MapInitState extends State<MapInit> {
  late WebViewController _webViewController;

  TestResult? result;

  Future<TestResult> fetchData() async {
    int rad = 1000;
    var response = await http.get(Uri.parse(
        'http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=l32ogI8HTVFiWOJB%2BmMSPbD%2BAExpCboabtx1ke0l0oLAJn0G5PlDB7SVXps5BGU8h7HU2woXDP5t69rN7mFytw%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&arrange=A&contentTypeId=39&mapX=126.981611&mapY=37.568477&radius=$rad&listYN=Y&_type=json'));
    TestResult result = TestResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        result = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();

    if(mapViewModel.isLoading == false) {
      final lng = mapViewModel.position.longitude;
      final lat = mapViewModel.position.latitude;
      print('https://michellehwang001.github.io/web/index.html?lat=$lat&lng=$lng');
    }

    return Scaffold(
      // appBar: AppBar(
      //     title: Text('카카오맵 - 관광지'),
      // ),
      body: mapViewModel.isLoading == true ? Center(child: CircularProgressIndicator()): _loadingWebView(mapViewModel.position.longitude, mapViewModel.position.latitude),
    );
  }

  Widget _loadingWebView(double lng, double lat) {
    return Column(
      children: [
        Flexible(
          // flex: 1,
          child: WebView(
            initialUrl:
            'https://michellehwang001.github.io/web/index.html',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated:
                (WebViewController webViewController) {
              // late 초기화
              _webViewController = webViewController;
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // int rad = 500;
                  // fetchData();
                });
              },
              child: Text('관광지'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('식당'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('숙박'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('쇼핑'),
            ),
          ],
        ),
        Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) => buildItem(index),
            itemCount: result!.response!.body!.items!.item!.length,
          ),
        ),
      ],
    );
  }

  Widget buildItem(index) {
    return Column(
      children: [
        Image.network(
            '${result!.response!.body!.items!.item![index].firstimage}'),
        Text('${result!.response!.body!.items!.item![index].title}'),
        Text('${result!.response!.body!.items!.item![index].addr1}'),
      ],
    );
  }
}

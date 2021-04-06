import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:location_picker/location_picker/location_picker_page.dart';
import 'package:location_picker/location_picker/models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _latitude;
  double _longitude;

  @override
  void initState() {
    super.initState();

    _initAMap();
  }

  _initAMap() async {
    await AmapCore.init('127f924976174ebb694cbf3f34b641ce');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: OutlinedButton(
          child: Text('选择位置'),
          onPressed: () async {
            PoiInfo result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return LocationPickerPage(
                  latitude: _latitude,
                  longitude: _longitude,
                );
              }),
            );

            if (result != null) {
              setState(() {
                _latitude = result.poi.latLng.latitude;
                _longitude = result.poi.latLng.longitude;
              });
            }

            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('提示'),
                    content: Text('选择了：' + result.toString()),
                    actions: [],
                  );
                });
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:region_selector/region_selector/models.dart';
import 'package:region_selector/region_selector/region_selector_widget.dart';

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
  List<Region> regions = [];
  List<String> selectedCodes = [];

  @override
  initState() {
    super.initState();
    _getRegion().then((value) {
      setState(() {
        regions = value;
      });
    });
  }

  Future<List<Region>> _getRegion() async {
    return await rootBundle
        .loadStructuredData<List<Region>>('assets/region.json', (value) {
      List<dynamic> list = json.decode(value);
      return Future.value((list.map((e) => Region.fromJson(e)).toList()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: OutlinedButton(
          child: Text("选择地区"),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return RegionSelector(
                    regions,
                    selected: selectedCodes,
                    onSelected: (regions) {
                      setState(() {
                        selectedCodes = regions.map((e) => e.code).toList();
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('提示'),
                              content: Text('选择了：' +
                                  regions
                                      .map((e) => e.name)
                                      .toList()
                                      .toString()),
                              actions: [],
                            );
                          });
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}

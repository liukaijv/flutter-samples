import 'package:flutter/material.dart';
import 'package:location_picker/location_picker/models.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_picker_widget.dart';

class LocationPickerPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  LocationPickerPage({this.longitude, this.latitude});

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LocationPicker(
        requestPermission: () {
          return Permission.location.request().then((it) => it.isGranted);
        },
        poiItemBuilder: (poi, selected) {
          return ListTile(
            title: Text(poi.title),
            subtitle: Text(poi.address),
            trailing: selected ? Icon(Icons.check) : SizedBox.shrink(),
          );
        },
        onItemSelected: (PoiInfo info) {
          Navigator.pop(context, info);
        },
        longitude: widget.longitude,
        latitude: widget.latitude,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:region_selector/multi_picker/models.dart';

class MultiPickerItem extends StatefulWidget {
  final PickerItemData data;

  const MultiPickerItem(this.data, {Key key}) : super(key: key);

  @override
  MultiPickerItemState createState() => MultiPickerItemState(data);
}

class MultiPickerItemState extends State<MultiPickerItem> {
  PickerItemData _pickerItemData;
  FixedExtentScrollController _scrollController;

  MultiPickerItemState(this._pickerItemData);

  @override
  void initState() {
    super.initState();
    _scrollController =
        FixedExtentScrollController(initialItem: _pickerItemData.index);
  }

  void setItemData(PickerItemData data) {
    _pickerItemData = data;
    _scrollController.jumpToItem(0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemExtent: 38,
      onSelectedItemChanged: _pickerItemData.onItemSelected,
      itemBuilder: _pickerItemData.builder,
      backgroundColor: Colors.white,
      scrollController: _scrollController,
      childCount: _pickerItemData.itemCount,
    );
  }
}

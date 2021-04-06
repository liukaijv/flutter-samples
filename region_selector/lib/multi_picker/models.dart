import 'package:flutter/cupertino.dart';

class PickerItemData<T> {
  int itemCount;
  int selectedIndex;
  void Function(int index) onItemSelected;
  IndexedWidgetBuilder builder;
  List<T> data;

  PickerItemData(
      {this.itemCount,
      this.onItemSelected,
      this.builder,
      this.data,
      this.selectedIndex = 0});
}

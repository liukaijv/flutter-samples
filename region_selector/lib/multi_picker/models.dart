import 'package:flutter/cupertino.dart';

class PickerItemData<T> {
  int itemCount;
  int index;
  void Function(int index) onItemSelected;
  IndexedWidgetBuilder builder;
  T data;

  PickerItemData(
      {this.itemCount,
      this.onItemSelected,
      this.builder,
      this.data,
      this.index = 0});
}

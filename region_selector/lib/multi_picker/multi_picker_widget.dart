import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:region_selector/multi_picker/models.dart';
import 'package:region_selector/multi_picker/multi_picker_item_widget.dart';

class MultiPicker extends StatefulWidget {
  final List<PickerItemData> _list;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String title;

  const MultiPicker(this._list,
      {this.onConfirm, this.onCancel, this.title, Key key})
      : super(key: key);

  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> {
  List<GlobalKey<MultiPickerItemState>> _states = [];

  void setItemData(int index, PickerItemData data) {
    if (index >= 0 && index < _states.length) {
      _states[index].currentState.setItemData(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    _states.clear();
    return new Container(
      height: 300.0,
      color: Colors.white,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new InkWell(
                onTap: () {
                  widget.onCancel == null
                      ? Navigator.of(context).pop()
                      : widget.onCancel();
                },
                child: new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Text(
                    '取消',
                    style: TextStyle(color: Color(0xFF808080), fontSize: 16.0),
                  ),
                ),
              ),
              widget.title != null
                  ? Text(
                      widget.title,
                      style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                    )
                  : Container(),
              new InkWell(
                onTap: () {
                  widget.onConfirm != null
                      ? Navigator.of(context).pop()
                      : widget.onConfirm();
                },
                child: new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Text(
                    '确定',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
          new Container(
            height: 1.0,
            color: Colors.white70,
          ),
          new Expanded(
            child: new Row(
              children: widget._list.map((element) {
                GlobalKey<MultiPickerItemState> state = new GlobalKey();
                _states.add(state);
                return new Expanded(
                  child: new MultiPickerItem(
                    element,
                    key: state,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

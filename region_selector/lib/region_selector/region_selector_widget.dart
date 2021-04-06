import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:region_selector/multi_picker/models.dart';
import 'package:region_selector/multi_picker/multi_picker_widget.dart';
import 'package:region_selector/region_selector/models.dart';

class RegionSelector extends StatefulWidget {
  final List<String> selected;
  final void Function(List<Region> list) onSelected;

  final List<Region> regions;

  const RegionSelector(this.regions, {this.selected, this.onSelected, Key key})
      : assert(regions != null),
        assert(regions.length > 0),
        super(key: key);

  @override
  State<RegionSelector> createState() {
    return _RegionSelectorState();
  }
}

class _RegionSelectorState extends State<RegionSelector> {
  GlobalKey<MultiPickerState> _pickerState = new GlobalKey();
  PickerItemData _itemDataProvince;
  PickerItemData _itemDataCity;
  PickerItemData _itemDataDistrict;

  @override
  void initState() {
    super.initState();
    _initData();
    setState(() {});
  }

  PickerItemData<Region> _buildPickerItem(
      List<Region> list, int selectedIndex) {
    return PickerItemData(
      data: list,
      selectedIndex: selectedIndex,
      itemCount: list.length,
      builder: (context, index) {
        String text = list[index].name;
        return Center(
          child: Text(
            text,
            style: TextStyle(fontSize: text.length > 6 ? 12 : 18),
          ),
        );
      },
    );
  }

  void _initData() {
    int provinceIndex = 0;
    int cityIndex = 0;
    int districtIndex = 0;
    List<Region> provinceData = List.of(widget.regions ?? []);
    if (widget.selected != null && widget.selected.length > 0) {
      provinceIndex = _getIndexByCode(provinceData, widget.selected[0]);
    }

    List<Region> cityData = provinceData[provinceIndex].children ?? [];
    if (widget.selected != null && widget.selected.length > 1) {
      cityIndex = _getIndexByCode(cityData, widget.selected[1]);
    }
    List<Region> districtData = cityData[cityIndex].children ?? [];
    if (widget.selected != null && widget.selected.length > 2) {
      districtIndex = _getIndexByCode(districtData, widget.selected[2]);
    }
    _itemDataProvince = _buildPickerItem(provinceData, provinceIndex);
    _itemDataProvince.onItemSelected = _onProvinceChange;
    _itemDataCity = _buildPickerItem(cityData, cityIndex);
    _itemDataCity.onItemSelected = _onCityChange;
    _itemDataDistrict = _buildPickerItem(districtData, districtIndex);
    _itemDataDistrict.onItemSelected = _onDistrictChange;
  }

  void _onProvinceChange(int index) {
    List<Region> provinceData = _itemDataProvince.data ?? [];
    _itemDataProvince.selectedIndex = index;
    List<Region> cityData = provinceData[index]?.children ?? [];
    _itemDataCity = _buildPickerItem(cityData, 0);
    _itemDataCity.onItemSelected = _onCityChange;
    _pickerState.currentState.setItemData(1, _itemDataCity);
    _onCityChange(0);
  }

  void _onCityChange(int index) {
    _itemDataCity.selectedIndex = index;
    List<Region> districtData = _itemDataCity.data[index]?.children ?? [];
    _itemDataDistrict = _buildPickerItem(districtData, 0);
    _itemDataDistrict.onItemSelected = _onDistrictChange;
    _pickerState.currentState.setItemData(2, _itemDataDistrict);
    _onDistrictChange(0);
  }

  void _onDistrictChange(int index) {
    _itemDataDistrict.selectedIndex = index;
  }

  int _getIndexByCode(List<Region> list, String code) {
    if (list == null || code == null) {
      return 0;
    }
    var index = list.indexWhere((element) => element.code == code);
    return index = index == -1 ? 0 : index;
  }

  List<Region> _getSelected() {
    List<Region> regions = [];
    regions.add(_itemDataProvince.data[_itemDataProvince.selectedIndex]);
    regions.add(_itemDataCity.data[_itemDataCity.selectedIndex]);
    regions.add(_itemDataDistrict.data[_itemDataDistrict.selectedIndex]);
    return regions;
  }

  @override
  Widget build(BuildContext context) {
    return MultiPicker(
      [_itemDataProvince, _itemDataCity, _itemDataDistrict],
      onConfirm: () {
        if (widget.onSelected != null) {
          widget.onSelected(_getSelected());
        }
      },
      key: _pickerState,
    );
  }
}

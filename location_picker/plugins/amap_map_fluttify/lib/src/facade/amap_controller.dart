// ignore_for_file: non_constant_identifier_names
part of 'amap_view.widget.dart';

/// marker点击事件回调签名 输入[Marker]对象
typedef OnMarkerClicked = Future<void> Function(Marker marker);

/// 地图点击事件回调签名
typedef OnMapClicked = Future<void> Function(LatLng latLng);

/// 地图移动事件回调签名
typedef OnMapMove = Future<void> Function(MapMove move);

/// 位置移动事件回调签名
typedef OnLocationChange = Future<void> Function(MapLocation move);

/// Marker拖动回调签名
typedef OnMarkerDrag = Future<void> Function(Marker marker);

/// ios请求权限回调签名
typedef _OnRequireAlwaysAuth = Future<void> Function(CLLocationManager manager);

/// 海量点点击回调签名
typedef OnMultiPointClicked = Future<void> Function(
  String id,
  String title,
  String snippet,
  String object,
);

/// 地图控制类
class AmapController extends _Holder
    with WidgetsBindingObserver, _Community, _Pro {
  /// Android构造器
  AmapController.android(com_amap_api_maps_TextureMapView _androidController,
      _AmapViewState _state) {
    WidgetsBinding.instance.addObserver(this);
    androidController = _androidController;
    state = _state;
  }

  /// iOS构造器
  AmapController.ios(MAMapView _iosController, _AmapViewState _state) {
    WidgetsBinding.instance.addObserver(this);
    iosController = _iosController;
    state = _state;
  }

  Future<void> dispose() async {
    await _locateSubscription?.cancel();

    await androidController?.onPause();
    await androidController?.onDestroy();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('didChangeAppLifecycleState: $state');
    // 因为这里的生命周期其实已经是App的生命周期了, 所以除了这里还需要在dispose里释放资源
    switch (state) {
      case AppLifecycleState.resumed:
        androidController?.onResume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        androidController?.onPause();
        break;
      case AppLifecycleState.detached:
        androidController?.onDestroy();
        break;
    }
  }
}

mixin _Community on _Holder {
  /// 获取当前位置
  ///
  /// 由于定位需要时间, 如果进入地图后马上获取位置信息, 获取到的会是null, [getLocation]会默认
  /// 以[interval]500毫秒为间隔循环获取定位信息, 直到获取到的定位不为空. 你可以设置超时时间[timeout], 防止
  /// 一直获取不到定位的情况(比如没有设置[showMyLocation]为true, 或者没有同意权限申请).
  Future<LatLng> getLocation({
    Duration interval = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        return Stream.periodic(interval, (_) => _)
            .asyncMap(
              (count) async {
                final coord = await androidMap.getMyLocation();

                if (coord == null) {
                  return null;
                } else {
                  return LatLng(await coord.latitude, await coord.longitude);
                }
              },
            )
            .take(timeout.inMilliseconds ~/ interval.inMilliseconds)
            .firstWhere((location) => location != null)
            .timeout(timeout, onTimeout: () => null);
      },
      ios: (pool) {
        return Stream.periodic(interval, (_) => _)
            .asyncMap(
              (count) async {
                final location = await iosController.get_userLocation();
                final coord = await location.get_coordinate();

                if (coord == null) {
                  return null;
                } else {
                  return LatLng(await coord.latitude, await coord.longitude);
                }
              },
            )
            .take(timeout.inMilliseconds ~/ interval.inMilliseconds)
            .firstWhere((location) => location != null)
            .timeout(timeout, onTimeout: () => null);
      },
    );
  }

  /// 显示我的位置
  ///
  /// 可配置的参数详见[MyLocationOption]
  Future<void> showMyLocation(MyLocationOption option) async {
    assert(option != null);
    assert(state.context != null, '当前context为null!');

    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final locationStyle =
            await com_amap_api_maps_model_MyLocationStyle.create__();
        await locationStyle.showMyLocation(option.show);
        await androidMap.setMyLocationEnabled(option.show);

        if (option.show) {
          switch (option.myLocationType) {
            case MyLocationType.Show:
              await locationStyle.myLocationType(
                com_amap_api_maps_model_MyLocationStyle.LOCATION_TYPE_SHOW,
              );
              break;
            case MyLocationType.Locate:
              await locationStyle.myLocationType(
                com_amap_api_maps_model_MyLocationStyle.LOCATION_TYPE_LOCATE,
              );
              break;
            case MyLocationType.Follow:
              await locationStyle.myLocationType(
                com_amap_api_maps_model_MyLocationStyle.LOCATION_TYPE_FOLLOW,
              );
              break;
            case MyLocationType.Rotate:
              await locationStyle.myLocationType(
                com_amap_api_maps_model_MyLocationStyle
                    .LOCATION_TYPE_MAP_ROTATE,
              );
              break;
          }
          // 定位间隔
          await locationStyle.interval(option.interval.inMilliseconds);

          // 定位图标
          if (option.iconProvider != null) {
            final imageData = await option.iconProvider
                .toImageData(createLocalImageConfiguration(state.context));
            final bitmap = await android_graphics_Bitmap.create(imageData);
            final bitmapDescriptor =
                await com_amap_api_maps_model_BitmapDescriptorFactory
                    .fromBitmap(bitmap);
            await locationStyle.myLocationIcon(bitmapDescriptor);
          }
          // 边框颜色
          if (option.strokeColor != null) {
            await locationStyle
                .strokeColor(Int32List.fromList([option.strokeColor.value])[0]);
          }
          // 填充颜色
          if (option.fillColor != null) {
            await locationStyle.radiusFillColor(
                Int32List.fromList([option.fillColor.value])[0]);
          }
          // 边框宽度
          if (option.strokeWidth != null) {
            await locationStyle.strokeWidth(option.strokeWidth);
          }
          // 锚点
          if (option.anchorU != null && option.anchorV != null) {
            await locationStyle.anchor(option.anchorU, option.anchorV);
          }

          // 设置样式
          await androidMap.setMyLocationStyle(locationStyle);
        }

        pool..add(locationStyle);
      },
      ios: (pool) async {
        await iosController.set_showsUserLocation(option.show);

        if (option.show) {
          if (option.interval != Duration.zero) {
            await _locateSubscription?.cancel();
            _locateSubscription = Stream.periodic(option.interval, (_) => _)
                .listen((_) async =>
                    await iosController.setUserTrackingMode_animated(
                      MAUserTrackingMode.MAUserTrackingModeFollow,
                      true,
                    ));
          }

          switch (option.myLocationType) {
            case MyLocationType.Show:
              await iosController.setUserTrackingMode_animated(
                MAUserTrackingMode.MAUserTrackingModeNone,
                true,
              );
              break;
            // ios端没有只定位一次的选项, 所以这里要模拟一下这个效果
            // 1. 先设置不跟踪位置, 防止定位marker来回跳
            // 2. 获取当前用户位置
            // 3. 把当前地图中心点设置为用户位置
            case MyLocationType.Locate:
              await iosController.setUserTrackingMode_animated(
                MAUserTrackingMode.MAUserTrackingModeNone,
                true,
              );
              final myLocation = await iosController.get_userLocation();
              await iosController.setCenterCoordinate_animated(
                await myLocation.get_coordinate(),
                false,
              );
              break;
            case MyLocationType.Follow:
              await iosController.setUserTrackingMode_animated(
                MAUserTrackingMode.MAUserTrackingModeFollow,
                true,
              );
              break;
            case MyLocationType.Rotate:
              await iosController.setUserTrackingMode_animated(
                MAUserTrackingMode.MAUserTrackingModeFollowWithHeading,
                true,
              );
              break;
          }

          final style = await MAUserLocationRepresentation.create__();

          // 定位图标
          if (option.iconProvider != null) {
            final imageData = await option.iconProvider
                .toImageData(createLocalImageConfiguration(state.context));
            final bitmap = await UIImage.create(imageData);
            await style.set_image(bitmap);
          }
          // 边框颜色
          if (option.strokeColor != null) {
            final color = await UIColor.create(option.strokeColor);
            await style.set_strokeColor(color);
          }
          // 填充颜色
          if (option.fillColor != null) {
            final color = await UIColor.create(option.fillColor);
            await style.set_fillColor(color);
          }
          // 边框宽度
          if (option.strokeWidth != null) {
            await style.set_lineWidth(option.strokeWidth);
          }

          await iosController.updateUserLocationRepresentation(style);
        } else {
          await _locateSubscription?.cancel();
        }
      },
    );
  }

  /// 设置我的位置图标旋转角度
  Future<void> setMyLocationRotateAngle(double angle) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        await androidMap.setMyLocationRotateAngle((360 - angle).abs());
      },
      ios: (pool) async {
        // todo 暂时没有找到比较直接的方式实现
        print('ios端暂时未实现');
//        final annotations = await _iosController.get_annotations();
//        for (final MAAnnotation annotation in annotations) {
//          if (await annotation.isMAUserLocation()) {
//            final userLocation = await annotation.asMAUserLocation();
//            userLocation.set_movingDirection(movingDirection)
//            break;
//          }
//        }
      },
    );
  }

  /// 是否显示室内地图
  Future<void> showIndoorMap(bool show) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        await androidMap.showIndoorMap(show);
      },
      ios: (pool) async {
        await iosController.set_showsIndoorMap(show);
      },
    );
  }

  /// 选择显示图层
  Future<void> setMapType(MapType mapType) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        switch (mapType) {
          case MapType.Standard:
            await androidMap.setMapType(1);
            break;
          case MapType.Satellite:
            await androidMap.setMapType(2);
            break;
          case MapType.Night:
            await androidMap.setMapType(3);
            break;
          case MapType.Navi:
            await androidMap.setMapType(4);
            break;
          case MapType.Bus:
            await androidMap.setMapType(5);
            break;
        }
      },
      ios: (pool) async {
        switch (mapType) {
          case MapType.Standard:
            await iosController.set_mapType(MAMapType.MAMapTypeStandard);
            break;
          case MapType.Satellite:
            await iosController.set_mapType(MAMapType.MAMapTypeSatellite);
            break;
          case MapType.Night:
            await iosController.set_mapType(MAMapType.MAMapTypeStandardNight);
            break;
          case MapType.Navi:
            await iosController.set_mapType(MAMapType.MAMapTypeNavi);
            break;
          case MapType.Bus:
            await iosController.set_mapType(MAMapType.MAMapTypeBus);
            break;
        }
      },
    );
  }

  /// 选择地图语言
  Future<void> setMapLanguage(Language language) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        switch (language) {
          case Language.Chinese:
            await androidMap.setMapLanguage(com_amap_api_maps_AMap.CHINESE);
            break;
          case Language.English:
            await androidMap.setMapLanguage(com_amap_api_maps_AMap.ENGLISH);
            break;
        }
      },
      ios: (pool) async {
        switch (language) {
          case Language.Chinese:
            await iosController.performSelectorWithObject__(
                'setMapLanguage:', 0);
            break;
          case Language.English:
            await iosController.performSelectorWithObject__(
                'setMapLanguage:', 1);
            break;
        }
      },
    );
  }

  /// 显示路况信息
  Future<void> showTraffic(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        await androidMap.setTrafficEnabled(enable);
      },
      ios: (pool) async {
        await iosController.set_showTraffic(enable);
      },
    );
  }

  /// 显示缩放控件
  Future<void> showZoomControl(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setZoomControlsEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        print('ios端不支持显示缩放控件');
      },
    );
  }

  /// 显示指南针
  Future<void> showCompass(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setCompassEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_showsCompass(enable);
      },
    );
  }

  /// 显示定位按钮
  Future<void> showLocateControl(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setMyLocationButtonEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        print('ios端不支持显示定位按钮');
      },
    );
  }

  /// 显示比例尺控件
  Future<void> showScaleControl(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setScaleControlsEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_showsScale(enable);
      },
    );
  }

  /// 缩放手势使能
  Future<void> setZoomGesturesEnabled(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setZoomGesturesEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_zoomEnabled(enable);
      },
    );
  }

  /// 滑动手势使能
  Future<void> setScrollGesturesEnabled(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setScrollGesturesEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_scrollEnabled(enable);
      },
    );
  }

  /// 旋转手势使能
  Future<void> setRotateGesturesEnabled(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setRotateGesturesEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_rotateEnabled(enable);
      },
    );
  }

  /// 旋转手势使能
  Future<void> setTiltGesturesEnabled(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setTiltGesturesEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_rotateCameraEnabled(enable);
      },
    );
  }

  /// 所有手势使能
  Future<void> setAllGesturesEnabled(bool enable) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setAllGesturesEnabled(enable);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_zoomEnabled(enable);
        await iosController.set_scrollEnabled(enable);
        await iosController.set_rotateEnabled(enable);
        await iosController.set_rotateCameraEnabled(enable);
      },
    );
  }

  /// 设置缩放大小
  ///
  /// 地图的缩放级别一共分为 17 级，从 3 到 19. 数字越大，展示的图面信息越精细
  Future<void> setZoomLevel(double level, {bool animated = true}) async {
    assert(level >= 3 && level <= 19, '缩放范围为3-19');
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final cameraUpdate =
            await com_amap_api_maps_CameraUpdateFactory.zoomTo(level);
        if (animated) {
          await androidMap
              .animateCamera__com_amap_api_maps_CameraUpdate(cameraUpdate);
        } else {
          await androidMap.moveCamera(cameraUpdate);
        }

        pool..add(cameraUpdate);
      },
      ios: (pool) async {
        await iosController.setZoomLevel_animated(level, animated);
      },
    );
  }

  /// 获取当前缩放大小
  Future<double> getZoomLevel() async {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final camera = await androidMap.getCameraPosition();

        pool..add(camera);
        return camera.get_zoom();
      },
      ios: (pool) async {
        return iosController.get_zoomLevel();
      },
    );
  }

  /// 设置缩放是否以中心点为锚点
  Future<void> setZoomByCenter(bool byCenter) async {
    assert(byCenter != null);
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final uiSetting = await androidMap.getUiSettings();
        await uiSetting.setZoomInByScreenCenter(byCenter);

        pool..add(uiSetting);
      },
      ios: (pool) async {
        await iosController.set_zoomingInPivotsAroundAnchorPoint(!byCenter);
      },
    );
  }

  /// 放大一个等级
  Future<void> zoomIn({bool animated = true}) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final cameraUpdate =
            await com_amap_api_maps_CameraUpdateFactory.zoomIn();
        if (animated) {
          await androidMap
              .animateCamera__com_amap_api_maps_CameraUpdate(cameraUpdate);
        } else {
          await androidMap.moveCamera(cameraUpdate);
        }

        pool..add(cameraUpdate);
      },
      ios: (pool) async {
        final currentLevel = await iosController.get_zoomLevel();
        await iosController.setZoomLevel_animated(currentLevel + 1, animated);
      },
    );
  }

  /// 放大一个等级
  Future<void> zoomOut({bool animated = true}) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final cameraUpdate =
            await com_amap_api_maps_CameraUpdateFactory.zoomOut();
        if (animated) {
          await androidMap
              .animateCamera__com_amap_api_maps_CameraUpdate(cameraUpdate);
        } else {
          await androidMap.moveCamera(cameraUpdate);
        }

        pool..add(cameraUpdate);
      },
      ios: (pool) async {
        final currentLevel = await iosController.get_zoomLevel();
        await iosController.setZoomLevel_animated(currentLevel - 1, animated);
      },
    );
  }

  /// 设置地图中心点
  ///
  /// [lat]纬度, [lng]经度, [zoomLevel]缩放等级, [bearing]地图选择角度, [tilt]倾斜角
  Future<void> setCenterCoordinate(
    LatLng coordinate, {
    double zoomLevel,
    double bearing,
    double tilt,
    bool animated = true,
  }) async {
    assert(
      zoomLevel == null || (zoomLevel >= 3 && zoomLevel <= 19),
      '缩放范围为3-19',
    );
    final lat = coordinate.latitude;
    final lng = coordinate.longitude;
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        final latLng = await com_amap_api_maps_model_LatLng
            .create__double__double(lat, lng);

        final camera = await androidMap.getCameraPosition();
        final finalZoomLevel = zoomLevel ?? await camera.get_zoom();
        final finalBearing = bearing ?? await camera.get_bearing();
        final finalTilt = tilt ?? await camera.get_tilt();
        final cameraPosition = await com_amap_api_maps_model_CameraPosition
            .create__com_amap_api_maps_model_LatLng__float__float__float(
                latLng, finalZoomLevel, finalTilt, finalBearing);

        final cameraUpdate = await com_amap_api_maps_CameraUpdateFactory
            .newCameraPosition(cameraPosition);

        if (animated) {
          await androidMap
              .animateCamera__com_amap_api_maps_CameraUpdate(cameraUpdate);
        } else {
          await androidMap.moveCamera(cameraUpdate);
        }

        pool..add(latLng)..add(cameraUpdate);
      },
      ios: (pool) async {
        final latLng = await CLLocationCoordinate2D.create(lat, lng);
        if (zoomLevel != null) {
          await iosController.setZoomLevel_animated(zoomLevel, animated);
        }
        if (bearing != null) {
          await iosController.set_rotationDegree(bearing);
        }
        if (tilt != null) {
          await iosController.set_cameraDegree(tilt);
        }
        await iosController.setCenterCoordinate_animated(latLng, animated);

        pool..add(latLng);
      },
    );
  }

  /// 获取地图中心点
  Future<LatLng> getCenterCoordinate() {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        final position = await androidMap.getCameraPosition();
        final target = await position.get_target();

        // target不能马上释放, 因为跟返回对象有联系
        pool..add(position);

        return LatLng(
          await target.get_latitude(),
          await target.get_longitude(),
        );
      },
      ios: (pool) async {
        final target = await iosController.get_centerCoordinate();
        // target不能马上释放, 因为跟返回对象有联系
        return LatLng(await target.latitude, await target.longitude);
      },
    );
  }

  /// 添加marker
  ///
  /// 在纬度[lat], 经度[lng]的位置添加marker, 并设置标题[title]和副标题[snippet], [iconUri]
  /// 可以是图片url, asset路径或者文件路径.
  /// 其中图片参数[imageConfig]如果不知道怎么创建, 那么就直接调用flutter sdk内提供的[createLocalImageConfiguration]方法创建
  Future<Marker> addMarker(MarkerOption option) {
    assert(option != null);
    assert(state.context != null, '当前context为null!');

    final lat = option.latLng.latitude;
    final lng = option.latLng.longitude;
    return platform(
      android: (pool) async {
        // 获取地图
        androidMap ??= await androidController.getMap();

        // marker经纬度
        final latLng = await com_amap_api_maps_model_LatLng
            .create__double__double(lat, lng);

        // marker配置
        final markerOption =
            await com_amap_api_maps_model_MarkerOptions.create__();

        // 设置marker经纬度
        await markerOption.position(latLng);
        // 设置marker标题
        if (option.title != null) {
          await markerOption.title(option.title);
        }
        // 设置marker副标题
        if (option.snippet != null) {
          await markerOption.snippet(option.snippet);
        }
        // 设置marker图标
        // 普通图片
        if (option.iconProvider != null) {
          Uint8List iconData = await option.iconProvider
              .toImageData(createLocalImageConfiguration(state.context));

          final bitmap = await android_graphics_Bitmap.create(iconData);
          final icon = await com_amap_api_maps_model_BitmapDescriptorFactory
              .fromBitmap(bitmap);
          await markerOption.icon(icon);

          pool..add(bitmap)..add(icon);
        }
        // widget as marker
        else if (option.widget != null) {
          List<Uint8List> iconData =
              await state.widgetToImageData([option.widget]);

          final bitmap = await android_graphics_Bitmap.create(iconData[0]);
          final icon = await com_amap_api_maps_model_BitmapDescriptorFactory
              .fromBitmap(bitmap);
          await markerOption.icon(icon);

          pool..add(bitmap)..add(icon);
        }
        // 是否可拖拽
        if (option.draggable != null) {
          await markerOption.draggable(option.draggable);
        }
        // 旋转角度
        if (option.rotateAngle != null) {
          await markerOption.rotateAngle(option.rotateAngle);
        }
        // 锚点 默认在中间底部是最合理的
        await markerOption.anchor(option.anchorU ?? 0.5, option.anchorV ?? 0);
        // 是否可见
        await markerOption.visible(option.visible);

        final marker = await androidMap.addMarker(markerOption);
        // 是否允许弹窗
        if (option.infoWindowEnabled != null) {
          await marker.setInfoWindowEnable(option.infoWindowEnabled);
        }

        // 自定义数据
        if (option.object != null) {
          await marker.setObject(option.object);
        }

        // marker不释放, 还有用
        pool..add(latLng)..add(markerOption);

        return Marker.android(marker);
      },
      ios: (pool) async {
        await iosController
            .set_delegate(iosMapDelegate..iosController = iosController);

        // 创建marker
        final annotation = await MAPointAnnotation.create__();

        final coordinate = await CLLocationCoordinate2D.create(lat, lng);

        // 设置经纬度
        await annotation.set_coordinate(coordinate);

        // 设置标题
        if (option.title != null) {
          await annotation.set_title(option.title);
        }
        // 设置副标题
        if (option.snippet != null) {
          await annotation.set_subtitle(option.snippet);
        }
        // 设置图片
        // 普通图片
        if (option.iconProvider != null) {
          Uint8List iconData = await option.iconProvider
              .toImageData(createLocalImageConfiguration(state.context));

          final icon = await UIImage.create(iconData);

          // 由于ios端的icon参数在回调中设置, 需要添加属性来实现
          await annotation.setIcon(icon);

          pool..add(icon);
        }
        // widget as marker
        else if (option.widget != null) {
          List<Uint8List> iconData =
              await state.widgetToImageData([option.widget]);

          if (iconData != null) {
            final icon = await UIImage.create(iconData[0]);

            // 由于ios端的icon参数在回调中设置, 需要添加属性来实现
            await annotation.setIcon(icon);

            pool..add(icon);
          }
        }
        // 是否可拖拽
        if (option.draggable != null) {
          await annotation.setDraggable(option.draggable);
        }
        // 旋转角度
        if (option.rotateAngle != null) {
          await annotation.setRotateAngle(option.rotateAngle);
        }
        // 是否允许弹窗
        if (option.infoWindowEnabled != null) {
          await annotation.setInfoWindowEnabled(option.infoWindowEnabled);
        }
        // 锚点
        if (option.anchorU != null || option.anchorV != null) {
          await annotation.setAnchor(option.anchorU, option.anchorV);
        }
        // 自定义数据
        if (option.object != null) {
          await annotation.setObject(option.object);
        }
        // 是否可见
        await annotation.setVisible(option.visible);

        // 添加marker
        await iosController.addAnnotation(annotation);

        pool.add(coordinate);

        return Marker.ios(annotation, iosController);
      },
    );
  }

  /// 批量添加marker
  ///
  /// 根据[options]批量创建Marker
  Future<List<Marker>> addMarkers(List<MarkerOption> options) async {
    assert(options != null);
    assert(state.context != null, '当前context为null!');

    if (options.isEmpty) return Future.value([]);

    final latBatch = options.map((it) => it.latLng.latitude).toList();
    final lngBatch = options.map((it) => it.latLng.longitude).toList();
    final titleBatch = options.map((it) => it.title).toList();
    final snippetBatch = options.map((it) => it.snippet).toList();
    final draggableBatch = options.map((it) => it.draggable).toList();
    final rotateAngleBatch = options.map((it) => it.rotateAngle).toList();
    final anchorUBatch = options.map((it) => it.anchorU).toList();
    final anchorVBatch = options.map((it) => it.anchorV).toList();
    final visibleBatch = options.map((it) => it.visible).toList();
    final infoWindowEnabledBatch =
        options.map((it) => it.infoWindowEnabled).toList();
    final objectBatch = options.map((it) => it.object).toList();
    final iconDataBatch = <Uint8List>[
      ...await Future.wait([
        for (final option in options)
          if (option.iconProvider != null)
            option.iconProvider
                .toImageData(createLocalImageConfiguration(state.context))
      ]),
      ...await state.widgetToImageData(options
          .where((element) => element.widget != null)
          .map((e) => e.widget)
          .toList()),
    ];

    return platform(
      android: (pool) async {
        // 获取地图
        androidMap ??= await androidController.getMap();
        final latLngBatch = await com_amap_api_maps_model_LatLng
            .create_batch__double__double(latBatch, lngBatch);
        // marker配置
        final markerOptionBatch = await com_amap_api_maps_model_MarkerOptions
            .create_batch__(options.length);
        // 添加经纬度
        await markerOptionBatch.position_batch(latLngBatch);
        // 添加标题
        await markerOptionBatch.title_batch(titleBatch);
        // 添加副标题
        await markerOptionBatch.snippet_batch(snippetBatch);
        // 是否可拖动
        await markerOptionBatch.draggable_batch(draggableBatch);
        // 旋转角度
        await markerOptionBatch.rotateAngle_batch(rotateAngleBatch);
        // 锚点
        await markerOptionBatch.anchor_batch(anchorUBatch, anchorVBatch);
        // 是否可见
        await markerOptionBatch.visible_batch(visibleBatch);
        // 图片
        if (iconDataBatch.isNotEmpty) {
          final bitmapBatch =
              await android_graphics_Bitmap.create_batch(iconDataBatch);
          final iconBatch =
              await com_amap_api_maps_model_BitmapDescriptorFactory_Batch
                  .fromBitmap_batch(bitmapBatch);
          await markerOptionBatch.icon_batch(iconBatch);
          pool..addAll(bitmapBatch)..addAll(iconBatch);
        }

        // 添加marker
        final markers = await androidMap.addMarkers(markerOptionBatch, false);

        // 弹窗使能
        await markers.setInfoWindowEnable_batch(infoWindowEnabledBatch);
        // 自定义数据
        await markers.setObject_batch(objectBatch);

        // marker不释放, 还有用
        pool..addAll(latLngBatch)..addAll(markerOptionBatch);
        return markers.map((it) => Marker.android(it)).toList();
      },
      ios: (pool) async {
        await iosController
            .set_delegate(iosMapDelegate..iosController = iosController);

        // 创建marker
        final annotationBatch =
            await MAPointAnnotation.create_batch__(options.length);

        // 经纬度列表
        final coordinateBatch =
            await CLLocationCoordinate2D.create_batch(latBatch, lngBatch);
        // 设置经纬度
        await annotationBatch.set_coordinate_batch(coordinateBatch);
        // 设置标题
        await annotationBatch.set_title_batch(titleBatch);
        // 设置副标题
        await annotationBatch.set_subtitle_batch(snippetBatch);
        // 设置图片
        if (iconDataBatch.isNotEmpty) {
          final iconBatch = await UIImage.create_batch(iconDataBatch);
          await annotationBatch.setIcon(iconBatch);
          pool.addAll(iconBatch);
        }
        // 是否可拖拽
        await annotationBatch.setDraggable(draggableBatch);
        // 旋转角度
        await annotationBatch.setRotateAngle(rotateAngleBatch);
        // 是否允许弹窗
        await annotationBatch.setInfoWindowEnabled(infoWindowEnabledBatch);
        // 锚点
        await annotationBatch.setAnchor(anchorUBatch, anchorVBatch);
        // 自定义数据
        await annotationBatch.setObject(objectBatch);
        // 是否可见
        await annotationBatch.setVisible(visibleBatch);

        // 添加marker
        await iosController.addAnnotations(annotationBatch);

        pool.addAll(coordinateBatch);
        return [
          for (int i = 0; i < options.length; i++)
            Marker.ios(annotationBatch[i], iosController)
        ];
      },
    );
  }

  /// 把marker列表从地图上移除
  Future<void> clearMarkers(List<Marker> markers) async {
    await platform(
      android: (pool) async {
        final markerBatch = markers.map((it) => it.androidModel).toList();
        await markerBatch.remove_batch();
      },
      ios: (pool) async {
        final markerBatch = markers.map((it) => it.iosModel).toList();
        await iosController.removeAnnotations(markerBatch);
      },
    );
  }

  /// 清除地图上所有覆盖物
  ///
  /// 根据[keepMyLocation]区分是否保留我的位置的marker
  Future<void> clear({bool keepMyLocation = true}) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        await androidMap.clear__bool(keepMyLocation);
      },
      ios: (pool) async {
        final markers = await iosController.get_annotations();
        final overlays = await iosController.get_overlays();
        await iosController.removeAnnotations(markers);
        await iosController.removeOverlays(overlays);

        pool..addAll(markers.cast<Ref>())..addAll(overlays.cast<Ref>());
      },
    );
  }

  /// 屏幕坐标转经纬度坐标
  Future<LatLng> fromScreenLocation(Point point) async {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final projection = await androidMap.getProjection();

        final androidPoint = await android_graphics_Point.create(
            point.x.toInt(), point.y.toInt());

        final latLng = await projection.fromScreenLocation(androidPoint);

        pool..add(projection)..add(androidPoint)..add(latLng);
        return LatLng(
          await latLng.get_latitude(),
          await latLng.get_longitude(),
        );
      },
      ios: (pool) async {
        final cgPoint = await CGPoint.create(point.x, point.y);
        final coord2d = await iosController.convertPoint_toCoordinateFromView(
            cgPoint, iosController);

        pool..add(cgPoint)..add(coord2d);
        return LatLng(await coord2d.latitude, await coord2d.longitude);
      },
    );
  }

  /// 经纬度坐标转屏幕坐标
  Future<Point> toScreenLocation(LatLng coord) async {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();
        final projection = await androidMap.getProjection();

        final latLng = await com_amap_api_maps_model_LatLng
            .create__double__double(coord.latitude, coord.longitude);

        final point = await projection.toScreenLocation(latLng);

        pool..add(projection)..add(latLng)..add(point);
        return Point((await point.x).toDouble(), (await point.y).toDouble());
      },
      ios: (pool) async {
        final latLng = await CLLocationCoordinate2D.create(
            coord.latitude, coord.longitude);
        final point = await iosController.convertCoordinate_toPointToView(
            latLng, iosController);

        pool..add(latLng)..add(point);
        return Point((await point.x).toDouble(), (await point.y).toDouble());
      },
    );
  }

  /// 添加折线
  ///
  /// 可配置参数详见[PolylineOption]
  Future<Polyline> addPolyline(PolylineOption option) async {
    assert(option != null);
    assert(state.context != null, '当前context为null!');

    final latitudeBatch = option.latLngList.map((e) => e.latitude).toList();
    final longitudeBatch = option.latLngList.map((e) => e.longitude).toList();
    final textureData = await option.textureProvider
        ?.toImageData(createLocalImageConfiguration(state.context));
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        // 构造折线点
        List<com_amap_api_maps_model_LatLng> latLngList =
            await com_amap_api_maps_model_LatLng.create_batch__double__double(
          latitudeBatch,
          longitudeBatch,
        );

        // 构造折线参数
        final polylineOptions =
            await com_amap_api_maps_model_PolylineOptions.create__();

        // 添加经纬度列表
        await polylineOptions.addAll(latLngList);
        if (option.width != null) {
          await polylineOptions.width(option.width);
        }
        // 颜色
        if (option.strokeColor != null) {
          await polylineOptions
              .color(Int32List.fromList([option.strokeColor.value])[0]);
        }
        // 自定义贴图
        if (textureData != null) {
          final bitmap = await android_graphics_Bitmap.create(textureData);
          final texture = await com_amap_api_maps_model_BitmapDescriptorFactory
              .fromBitmap(bitmap);
          await polylineOptions.setCustomTexture(texture);
          await polylineOptions.setUseTexture(true);

          pool..add(bitmap)..add(texture);
        }
        // 线段始末端样式, 由于两端的枚举顺序是一样的, 所以这里直接从索引获取枚举
        if (option.lineCapType != null) {
          await polylineOptions.lineCapType(
            com_amap_api_maps_model_PolylineOptions_LineCapType
                .values[option.lineCapType.index],
          );
        }
        // 线段连接处样式, 由于两端的枚举顺序是一样的, 所以这里直接从索引获取枚举
        if (option.lineJoinType != null) {
          await polylineOptions.lineJoinType(
              com_amap_api_maps_model_PolylineOptions_LineJoinType
                  .values[option.lineJoinType.index]);
        }
        // 是否虚线
        if (option.dashType != null) {
          await polylineOptions.setDottedLine(true);
          switch (option.dashType) {
            case DashType.Square:
              await polylineOptions.setDottedLineType(
                  com_amap_api_maps_model_PolylineOptions
                      .DOTTEDLINE_TYPE_SQUARE);
              break;
            case DashType.Circle:
              await polylineOptions.setDottedLineType(
                  com_amap_api_maps_model_PolylineOptions
                      .DOTTEDLINE_TYPE_CIRCLE);
              break;
          }
        }
        // 设置参数
        final polyline = await androidMap.addPolyline(polylineOptions);

        pool
          ..add(polylineOptions)
          ..addAll(latLngList);

        return Polyline.android(polyline);
      },
      ios: (pool) async {
        await iosController.set_delegate(iosMapDelegate);

        // 构造折线点
        List<CLLocationCoordinate2D> latLngList =
            await CLLocationCoordinate2D.create_batch(
                latitudeBatch, longitudeBatch);

        // 构造折线参数
        final polyline = await MAPolyline.polylineWithCoordinates_count(
            latLngList, latLngList.length);

        // 宽度和颜色需要设置到STACK里去
        if (option.width != null) {
          final pixelRatio = MediaQuery.of(state.context).devicePixelRatio;
          await polyline.addJsonableProperty__(1, option.width / pixelRatio);
        }
        // 颜色
        if (option.strokeColor != null) {
          await polyline.addJsonableProperty__(2, option.strokeColor.value);
        }
        // 设置图片
        if (textureData != null) {
          final texture = await UIImage.create(textureData);

          await polyline.addProperty__(3, texture);

          pool..add(texture);
        }
        // 线段始末端样式, 由于两端的枚举顺序是一样的, 所以这里直接从索引获取枚举
        if (option.lineCapType != null) {
          await polyline.addJsonableProperty__(4, option.lineCapType.index);
        }
        // 线段连接处样式, 由于两端的枚举顺序是一样的, 所以这里直接从索引获取枚举
        if (option.lineJoinType != null) {
          await polyline.addJsonableProperty__(5, option.lineJoinType.index);
        }
        // 是否虚线
        if (option.dashType != null) {
          await polyline.addJsonableProperty__(6, option.dashType.index + 1);
        }

        // 设置参数
        await iosController.addOverlay(polyline);

        pool..addAll(latLngList);

        return Polyline.ios(polyline, iosController);
      },
    );
  }

  /// 添加多边形
  ///
  /// 在点[points]的位置添加线, 可以设置宽度[width]和颜色[strokeColor]
  Future<Polygon> addPolygon(PolygonOption option) {
    assert(option != null, 'option不能为null');

    final latitudeBatch = option.latLngList.map((e) => e.latitude).toList();
    final longitudeBatch = option.latLngList.map((e) => e.longitude).toList();

    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        // 构造折线点
        List<com_amap_api_maps_model_LatLng> latLngList =
            await com_amap_api_maps_model_LatLng.create_batch__double__double(
          latitudeBatch,
          longitudeBatch,
        );

        // 构造参数
        final polygonOptions =
            await com_amap_api_maps_model_PolygonOptions.create__();

        // 添加参数
        await polygonOptions.addAll(latLngList);
        // 宽度
        if (option.width != null) {
          await polygonOptions.strokeWidth(option.width);
        }
        // 边框颜色
        if (option.strokeColor != null) {
          await polygonOptions
              .strokeColor(Int32List.fromList([option.strokeColor.value])[0]);
        }
        // 填充颜色
        if (option.fillColor != null) {
          await polygonOptions
              .fillColor(Int32List.fromList([option.fillColor.value])[0]);
        }

        // 设置参数
        final polygon = await androidMap.addPolygon(polygonOptions);

        pool
          ..add(polygonOptions)
          ..addAll(latLngList);

        return Polygon.android(polygon);
      },
      ios: (pool) async {
        await iosController.set_delegate(iosMapDelegate);

        // 构造折线点
        List<CLLocationCoordinate2D> latLngList =
            await CLLocationCoordinate2D.create_batch(
                latitudeBatch, longitudeBatch);

        // 构造折线参数
        final polygon = await MAPolygon.polygonWithCoordinates_count(
            latLngList, latLngList.length);

        if (option.width != null) {
          final pixelRatio = MediaQuery.of(state.context).devicePixelRatio;
          await polygon.addJsonableProperty__(1, option.width / pixelRatio);
        }
        if (option.strokeColor != null) {
          await polygon.addJsonableProperty__(2, option.strokeColor.value);
        }
        if (option.fillColor != null) {
          await polygon.addJsonableProperty__(3, option.fillColor.value);
        }

        // 设置参数
        await iosController.addOverlay(polygon);

        pool.addAll(latLngList);

        return Polygon.ios(polygon, iosController);
      },
    );
  }

  /// 添加圆
  ///
  /// 在点[points]的位置添加线, 可以设置宽度[width]和颜色[strokeColor]
  Future<Circle> addCircle(CircleOption option) {
    return platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        // 构造点
        final latLng =
            await com_amap_api_maps_model_LatLng.create__double__double(
          option.center.latitude,
          option.center.longitude,
        );

        // 构造参数
        final circleOptions =
            await com_amap_api_maps_model_CircleOptions.create__();

        // 中心点
        await circleOptions.center(latLng);
        // 半径
        await circleOptions.radius(option.radius);
        // 宽度
        if (option.width != null) {
          await circleOptions.strokeWidth(option.width);
        }
        // 边框颜色
        if (option.strokeColor != null) {
          await circleOptions
              .strokeColor(Int32List.fromList([option.strokeColor.value])[0]);
        }
        // 填充颜色
        if (option.fillColor != null) {
          await circleOptions
              .fillColor(Int32List.fromList([option.fillColor.value])[0]);
        }

        // 设置参数
        final circle = await androidMap.addCircle(circleOptions);

        pool..add(circleOptions)..add(latLng);

        return Circle.android(circle);
      },
      ios: (pool) async {
        await iosController.set_delegate(iosMapDelegate);

        final latLng = await CLLocationCoordinate2D.create(
          option.center.latitude,
          option.center.longitude,
        );

        // 参数
        final circle = await MACircle.circleWithCenterCoordinate_radius(
          latLng,
          option.radius,
        );

        if (option.width != null) {
          final pixelRatio = MediaQuery.of(state.context).devicePixelRatio;
          await circle.addJsonableProperty__(1, option.width / pixelRatio);
        }
        if (option.strokeColor != null) {
          await circle.addJsonableProperty__(2, option.strokeColor.value);
        }
        if (option.fillColor != null) {
          await circle.addJsonableProperty__(3, option.fillColor.value);
        }

        // 设置参数
        await iosController.addOverlay(circle);

        return Circle.ios(circle, iosController);
      },
    );
  }

  /// 设置marker点击监听事件
  Future<void> setMarkerClickedListener(OnMarkerClicked onMarkerClicked) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnMarkerClickListener(
            androidMapDelegate..onMarkerClicked = onMarkerClicked);
      },
      ios: (pool) async {
        await iosController
            .set_delegate(iosMapDelegate..onMarkerClicked = onMarkerClicked);
      },
    );
  }

  /// 设置marker拖动监听事件
  Future<void> setMarkerDragListener({
    OnMarkerDrag onMarkerDragStart,
    OnMarkerDrag onMarkerDragging,
    OnMarkerDrag onMarkerDragEnd,
  }) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnMarkerDragListener(
          androidMapDelegate
            ..onMarkerDragStarted = onMarkerDragStart
            ..onMarkerDragging = onMarkerDragging
            ..onMarkerDragEnded = onMarkerDragEnd,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate
            ..onMarkerDragStarted = onMarkerDragStart
            ..onMarkerDragging = onMarkerDragging
            ..onMarkerDragEnded = onMarkerDragEnd,
        );
      },
    );
  }

  /// 设置地图点击监听事件
  Future<void> setMapClickedListener(OnMapClicked onMapClick) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnMapClickListener(
          androidMapDelegate..onMapClicked = onMapClick,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate..onMapClicked = onMapClick,
        );
      },
    );
  }

  /// 设置地图长按监听事件
  Future<void> setMapLongPressedListener(OnMapClicked onMapLongPress) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnMapLongClickListener(
          androidMapDelegate..onMapLongClicked = onMapLongPress,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate..onMapLongClicked = onMapLongPress,
        );
      },
    );
  }

  /// 设置地图移动监听事件
  Future<void> setMapMoveListener({
    OnMapMove onMapMoveStart,
    OnMapMove onMapMoving,
    OnMapMove onMapMoveEnd,
  }) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnCameraChangeListener(
          androidMapDelegate
            ..onMapMoveStart = onMapMoveStart
            ..onMapMoving = onMapMoving
            ..onMapMoveEnd = onMapMoveEnd,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate
            ..onMapMoveStart = onMapMoveStart
            ..onMapMoving = onMapMoving
            ..onMapMoveEnd = onMapMoveEnd,
        );
      },
    );
  }

  /// 设置地图移动监听事件
  ///
  /// !还有bug, 建议先使用*amap_location_fluttify*代替
  Future<void> setMyLocationChangeListener(
    OnLocationChange onLocationChange,
  ) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnMyLocationChangeListener(
          androidMapDelegate..onLocationChange = onLocationChange,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate..onLocationChange = onLocationChange,
        );
      },
    );
  }

  /// 请求后台定位 *仅iOS
  Future<void> requireAlwaysAuth() async {
    await platform(
      android: (pool) async {},
      ios: (pool) async {
        final onRequireAuth = (CLLocationManager manager) async {
          await manager?.requestAlwaysAuthorization();
        };
        await iosController.set_delegate(
          iosMapDelegate..onRequireAlwaysAuth = onRequireAuth,
        );
      },
    );
  }

  /// 截图
  Future<Uint8List> screenShot() async {
    return platform(
      android: (pool) async {
        final completer = Completer<Uint8List>();

        androidMap ??= await androidController.getMap();
        await androidMap.getMapScreenShot(
          androidMapDelegate..onSnapshot = completer.complete,
        );

        return completer.future;
      },
      ios: (pool) async {
        final completer = Completer<Uint8List>();

        final rect = await iosController.frame;
        await iosController.takeSnapshotInRect_withCompletionBlock(
          rect,
          (image, state) async {
            completer.complete(await image.data);
            pool.add(image);
          },
        );

        pool.add(rect);
        return completer.future;
      },
    );
  }

  /// 限制地图的显示范围
  ///
  /// [southWest]西南角, [northEast]东北角
  Future<void> setMapRegionLimits(LatLng southWest, LatLng northEast) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        final southWestPoint = await com_amap_api_maps_model_LatLng
            .create__double__double(southWest.latitude, southWest.longitude);
        final northEastPoint = await com_amap_api_maps_model_LatLng
            .create__double__double(northEast.latitude, northEast.longitude);

        final latLngBounds = await com_amap_api_maps_model_LatLngBounds
            .create__com_amap_api_maps_model_LatLng__com_amap_api_maps_model_LatLng(
                southWestPoint, northEastPoint);

        await androidMap.setMapStatusLimits(latLngBounds);

        pool..add(southWestPoint)..add(northEastPoint)..add(latLngBounds);
      },
      ios: (pool) async {
        final center = await CLLocationCoordinate2D.create(
          (southWest.latitude + northEast.latitude) / 2,
          (southWest.longitude + northEast.longitude) / 2,
        );
        final span = await MACoordinateSpanMake(
          northEast.latitude - southWest.latitude,
          northEast.longitude - southWest.longitude,
        );
        final region = await MACoordinateRegionMake(center, span);
        await iosController.set_limitRegion(region);

        pool..add(center)..add(span)..add(region);
      },
    );
  }

  /// Marker弹窗点击事件监听
  Future<void> setInfoWindowClickListener(
    OnMarkerClicked onInfoWindowClicked,
  ) async {
    await platform(
      android: (pool) async {
        androidMap ??= await androidController.getMap();

        await androidMap.setOnInfoWindowClickListener(
          androidMapDelegate..onInfoWindowClicked = onInfoWindowClicked,
        );
      },
      ios: (pool) async {
        await iosController.set_delegate(
          iosMapDelegate..onInfoWindowClicked = onInfoWindowClicked,
        );
      },
    );
  }
}

/// 无法直接扩展的部分, 需要原生代码
mixin _Pro on _Holder, _Community {}

class _Holder {
  com_amap_api_maps_TextureMapView androidController;
  MAMapView iosController;

  _AmapViewState state;

  // iOS端的回调处理类
  final iosMapDelegate = _IOSMapDelegate();

  // Android端的回调处理类
  final androidMapDelegate = _AndroidMapDelegate();

  // 定位间隔订阅事件
  StreamSubscription _locateSubscription;

  com_amap_api_maps_AMap androidMap;
}

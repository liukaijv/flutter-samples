import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:core_location_fluttify/core_location_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../android/android.export.g.dart';
import '../ios/ios.export.g.dart';
import 'enums.dart';
import 'extensions.dart';

/// 我的位置选项
@immutable
class MyLocationOption {
  MyLocationOption({
    this.show = true,
    this.myLocationType = MyLocationType.Locate,
    this.interval = Duration.zero,
    this.strokeColor = Colors.transparent,
    this.strokeWidth = 0,
    this.fillColor = Colors.transparent,
    this.iconProvider,
    this.anchorU,
    this.anchorV,
  });

  /// 是否显示
  final bool show;

  /// 定位类型
  final MyLocationType myLocationType;

  /// 定位间隔
  final Duration interval;

  /// 边框颜色
  final Color strokeColor;

  /// 边框宽度
  final double strokeWidth;

  /// 填充颜色
  final Color fillColor;

  /// 图标
  ///
  /// 资源图片则使用[AssetImage], 网络图片则使用[NetworkImage], 文件图片则使用[FileImage]
  final ImageProvider iconProvider;

  /// 锚点
  final double anchorU, anchorV;

  @override
  String toString() {
    return 'MyLocationOption{show: $show, myLocationType: $myLocationType, interval: $interval, strokeColor: $strokeColor, strokeWidth: $strokeWidth, fillColor: $fillColor, iconProvider: $iconProvider, anchorU: $anchorU, anchorV: $anchorV}';
  }
}

/// Marker创建参数
@immutable
class MarkerOption {
  MarkerOption({
    @required this.latLng,
    this.title = '',
    this.snippet = '',
    this.widget,
    this.draggable = false,
    this.infoWindowEnabled = true,
    this.visible = true,
    this.rotateAngle = 0,
    this.anchorU = 0.5,
    this.anchorV = 0,
    this.object,
    this.iconProvider,
  }) : assert(!(widget != null && iconProvider != null),
            'widget和iconProvider不能同时设置! ');

  /// 经纬度
  final LatLng latLng;

  /// 标题
  final String title;

  /// 副标题
  final String snippet;

  /// Widget形式的Marker
  ///
  /// 不能和[iconProvider]一起用.
  /// 注意控制Widget的大小, 比如Column默认是max, 会使用地图的高度, 那么此时需要设置成min.
  final Widget widget;

  /// 是否可拖动
  final bool draggable;

  /// 是否允许弹窗
  final bool infoWindowEnabled;

  /// 是否可见
  final bool visible;

  /// 旋转角度 单位为度(°)
  final double rotateAngle;

  /// 横轴锚点
  final double anchorU;

  /// 纵轴锚点
  final double anchorV;

  /// 自定义数据 理论上可以使用任何类型的数据, 但是为了减少意外情况, 这里一律转换成String来保存
  final String object;

  /// 图标
  final ImageProvider iconProvider;

  @override
  String toString() {
    return 'MarkerOption{latLng: $latLng, title: $title, snippet: $snippet, widget: $widget, draggable: $draggable, infoWindowEnabled: $infoWindowEnabled, visible: $visible, rotateAngle: $rotateAngle, anchorU: $anchorU, anchorV: $anchorV, object: $object, iconProvider: $iconProvider}';
  }
}

/// 平滑移动Marker创建参数
@immutable
class SmoothMoveMarkerOption {
  /// 轨迹经纬度列表
  final List<LatLng> path;

  /// 图标
  final ImageProvider iconProvider;

  /// 动画时长
  final Duration duration;

  SmoothMoveMarkerOption({
    @required this.path,
    @required this.duration,
    @required this.iconProvider,
  });

  @override
  String toString() {
    return 'SmoothMoveMarkerOption{path: $path, iconProvider: $iconProvider, duration: $duration}';
  }
}

/// Polyline创建参数
@immutable
class PolylineOption {
  /// 经纬度列表
  final List<LatLng> latLngList;

  /// 宽度
  final double width;

  /// 颜色
  final Color strokeColor;

  /// 自定义纹理
  final ImageProvider textureProvider;

  /// 线段末端样式
  final LineCapType lineCapType;

  /// 线段连接处样式
  final LineJoinType lineJoinType;

  /// 是否虚线
  final DashType dashType;

  PolylineOption({
    @required this.latLngList,
    this.width = 5,
    this.strokeColor = Colors.green,
    this.textureProvider,
    this.lineCapType,
    this.lineJoinType,
    this.dashType,
  });

  @override
  String toString() {
    return 'PolylineOption{latLngList: $latLngList, width: $width, strokeColor: $strokeColor, textureProvider: $textureProvider, lineCapType: $lineCapType, lineJoinType: $lineJoinType, dashType: $dashType}';
  }
}

/// Polygon创建参数
@immutable
class PolygonOption {
  /// 经纬度列表
  final List<LatLng> latLngList;

  /// 宽度
  final double width;

  /// 边框颜色
  final Color strokeColor;

  /// 填充颜色
  final Color fillColor;

  PolygonOption({
    @required this.latLngList,
    this.width = 5,
    this.strokeColor = Colors.green,
    this.fillColor = Colors.transparent,
  });

  @override
  String toString() {
    return 'PolygonOption{latLngList: $latLngList, width: $width, strokeColor: $strokeColor, fillColor: $fillColor}';
  }
}

/// Circle创建参数
@immutable
class CircleOption {
  /// 中心点经纬度
  final LatLng center;

  /// 宽度
  final double radius;

  /// 宽度
  final double width;

  /// 边框颜色
  final Color strokeColor;

  /// 填充颜色
  final Color fillColor;

  CircleOption({
    @required this.center,
    @required this.radius,
    this.width = 5,
    this.strokeColor = Colors.green,
    this.fillColor = Colors.transparent,
  })  : assert(center != null),
        assert(radius != null);

  @override
  String toString() {
    return 'CircleOption{center: $center, radius: $radius, width: $width, strokeColor: $strokeColor, fillColor: $fillColor}';
  }
}

/// TileOverlay创建参数
@immutable
class HeatmapTileOption {
  /// 中心点经纬度
  final List<LatLng> latLngList;

  HeatmapTileOption({
    @required this.latLngList,
  });

  @override
  String toString() {
    return 'HeatmapTileOption{latLngList: $latLngList}';
  }
}

/// 图片覆盖物创建参数
@immutable
class GroundOverlayOption {
  final LatLng southWest;
  final LatLng northEast;
  final ImageProvider imageProvider;

  GroundOverlayOption({
    @required this.southWest,
    @required this.northEast,
    @required this.imageProvider,
  });

  @override
  String toString() {
    return 'GroundOverlayOption{southWest: $southWest, northEast: $northEast, imageProvider: $imageProvider}';
  }
}

/// 瓦片图创建参数
@immutable
class UrlTileOption {
  /// 单位瓦片图宽度
  final int width;

  /// 单位瓦片图高度
  final int height;

  /// 瓦片图地址模板
  ///
  /// 瓦片图地址模板是一个包含"{x}","{y}","{z}","{scale}"的字符串,"{x}","{y}","{z}","{scale}"会被tile path的值所替换，
  /// 并生成用来加载tile图片数据的URL 。例如 http://server/path?x={x}&y={y}&z={z}&scale={scale}
  final String urlTemplate;

  UrlTileOption({
    @required this.width,
    @required this.height,
    @required this.urlTemplate,
  });

  @override
  String toString() {
    return 'UrlTileOption{width: $width, height: $height, urlTemplate: $urlTemplate}';
  }
}

/// 海量点创建参数
@immutable
class MultiPointOption {
  /// 点列表
  final List<PointOption> pointList;

  /// 图标
  final ImageProvider iconProvider;

  MultiPointOption({
    @required this.pointList,
    this.iconProvider,
  });

  @override
  String toString() {
    return 'MultiPointOption{pointList: $pointList, iconProvider: $iconProvider}';
  }
}

/// 海量点中单个点的创建参数
@immutable
class PointOption {
  /// 经纬度
  final LatLng latLng;

  /// 点的id列表, 用来区分点
  final String id;

  /// 标题列表
  final String title;

  /// 副标题列表
  final String snippet;

  /// 自定义数据
  final String object;

  PointOption({
    @required this.latLng,
    this.id,
    this.title,
    this.snippet,
    this.object,
  });

  @override
  String toString() {
    return 'PointOption{latLng: $latLng, id: $id, title: $title, snippet: $snippet, object: $object}';
  }
}

/// 地图移动
@immutable
class MapMove {
  /// 经纬度
  final LatLng latLng;

  /// 缩放等级
  final double zoom;

  /// 倾斜度
  final double tilt;

  /// 朝向
  final double bearing;

  /// 是否是国外
  final bool isAbroad;

  MapMove({this.latLng, this.zoom, this.tilt, this.bearing, this.isAbroad});

  @override
  String toString() {
    return 'MapMove{latLng: $latLng, zoom: $zoom, tilt: $tilt, bearing: $bearing, isAbroad: $isAbroad}';
  }
}

/// 屏幕坐标
@immutable
class TraceLocation {
  final double latitude;
  final double longitude;
  final double speed;
  final double bearing;
  final int time;

  TraceLocation({
    @required this.latitude,
    @required this.longitude,
    @required this.speed,
    @required this.bearing,
    @required this.time,
  });

  @override
  String toString() {
    return 'TraceLocation{latitude: $latitude, longitude: $longitude, speed: $speed, bearing: $bearing, time: $time}';
  }
}

/// 交通配置
@immutable
class TrafficOption {
  /// 是否显示
  final bool show;

  /// 通畅路段颜色
  final Color goodColor;

  /// 缓行路段颜色
  final Color badColor;

  /// 拥堵路段颜色
  final Color terribleColor;

  /// 未知路段颜色
  final Color unknownColor;

  TrafficOption({
    @required this.show,
    this.goodColor = Colors.green,
    this.badColor = Colors.yellow,
    this.terribleColor = Colors.red,
    this.unknownColor = Colors.blue,
  }) : assert(show != null);

  @override
  String toString() {
    return 'TrafficOption{show: $show, goodColor: $goodColor, badColor: $badColor, terribleColor: $terribleColor, unknownColor: $unknownColor}';
  }
}

/// 地图定位信息 区分于定位插件的定位信息
class MapLocation {
  MapLocation.android(this.androidModel);

  MapLocation.ios(this.iosModel);

  android_location_Location androidModel;
  MAUserLocation iosModel;

  Future<LatLng> get coord {
    return platform(
      android: (pool) async {
        return LatLng(
          await androidModel.latitude,
          await androidModel.longitude,
        );
      },
      ios: (pool) async {
        final location = await iosModel.get_coordinate();
        return LatLng(await location.latitude, await location.longitude);
      },
    );
  }

  Future<double> get bearing {
    return platform(
      android: (pool) => androidModel.bearing,
      ios: (pool) async {
        final heading = await iosModel.get_heading();
        return heading.magneticHeading;
      },
    );
  }

  Future<double> get altitude {
    return platform(
      android: (pool) => androidModel.altitude,
      ios: (pool) async {
        final location = await iosModel.get_location();
        return location.altitude;
      },
    );
  }

  Future<double> get speed {
    return platform(
      android: (pool) => androidModel.speed,
      ios: (pool) async {
        final location = await iosModel.get_location();
        return location.speed;
      },
    );
  }
}

/// 地图标记
class Marker {
  Marker.android(this.androidModel);

  Marker.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_Marker androidModel;

  MAPointAnnotation iosModel;
  MAMapView iosController;

  /// 获取标题
  Future<String> get title {
    return platform(
      android: (_) => androidModel.getTitle(),
      ios: (_) => iosModel.get_title(),
    );
  }

  /// 获取副标题
  Future<String> get snippet {
    return platform(
      android: (_) => androidModel.getSnippet(),
      ios: (_) => iosModel.get_subtitle(),
    );
  }

  /// 获取定位信息
  Future<LatLng> get location {
    return platform(
      android: (_) async {
        final _location = await androidModel.getPosition();
        return LatLng(
          await _location.get_latitude(),
          await _location.get_longitude(),
        );
      },
      ios: (_) async {
        final location = await iosModel.get_coordinate();
        return LatLng(await location.latitude, await location.longitude);
      },
    );
  }

  /// 获取自定义信息
  Future<String> get object {
    return platform(
      android: (_) {
        return androidModel.getObject().then((object) => object as String);
      },
      ios: (_) {
        return iosModel
            .getJsonableProperty__(7)
            .then((object) => object as String);
      },
    );
  }

  /// 删除marker
  Future<void> remove() async {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController.removeAnnotation(iosModel),
    );
  }

  /// 设置坐标
  Future<void> setCoordinate(LatLng coord) async {
    assert(coord != null);
    return platform(
      android: (_) async => androidModel.setPosition(
        await com_amap_api_maps_model_LatLng.create__double__double(
          coord.latitude,
          coord.longitude,
        ),
      ),
      ios: (_) async {
        final annotationView = await iosController.viewForAnnotation(iosModel);
        if (annotationView != null) {
          final coordinate = await CLLocationCoordinate2D.create(
            coord.latitude,
            coord.longitude,
          );
          await iosModel.set_coordinate(coordinate);
          await annotationView.set_annotation(iosModel, viewChannel: false);
        } else {
          debugPrint('当前_annotationView为null, 无法设置经纬度!');
        }
      },
    );
  }

  /// 设置可见性
  Future<void> setVisible(bool visible) async {
    assert(visible != null);
    return platform(
      android: (_) => androidModel.setVisible(visible),
      ios: (_) async {
        await iosModel.setVisible(visible);

        final annotationView = await iosController.viewForAnnotation(iosModel);
        await annotationView?.setHidden(!visible);
      },
    );
  }

  /// 显示弹窗
  Future<void> showInfoWindow() async {
    return platform(
      android: (_) => androidModel.showInfoWindow(),
      ios: (_) => iosController.selectAnnotation_animated(iosModel, true),
    );
  }

  /// 关闭弹窗
  Future<void> hideInfoWindow() async {
    return platform(
      android: (_) => androidModel.hideInfoWindow(),
      ios: (_) => iosController?.deselectAnnotation_animated(iosModel, true),
    );
  }

  /// 设置图标
  Future<void> setIcon(
    ImageProvider iconProvider,
    ImageConfiguration configuration,
  ) async {
    final iconData = await iconProvider.toImageData(configuration);
    return platform(
      android: (pool) async {
        final bitmap = await android_graphics_Bitmap.create(iconData);
        final icon = await com_amap_api_maps_model_BitmapDescriptorFactory
            .fromBitmap(bitmap);
        await androidModel.setIcon(icon);
      },
      ios: (pool) async {
        final icon = await UIImage.create(iconData);

        // 这里和annotationView?.set_image看上去是做同一件事情, 但其实是针对两种不同情况
        // 如果marker是屏幕内, 那会直接走annotationView?.set_image;
        // 如果不在屏幕内, 那么annotationView?.set_image不会被执行, 如果此marker后来
        // 进入到屏幕内后, 此时需要同步annotation的数据, 如果不给annotation设置值, 那么
        // 渲染的时候还是上次的图片
        await iosModel.setIcon(icon);
        final annotationView = await iosController.viewForAnnotation(iosModel);
        await annotationView?.set_image(icon, viewChannel: false);
      },
    );
  }
}

/// 平滑移动点
class SmoothMoveMarker {
  SmoothMoveMarker.android(this.androidModel);

  SmoothMoveMarker.ios(this.iosController, this.iosAnimation, this.annotation);

  com_amap_api_maps_utils_overlay_SmoothMoveMarker androidModel;

  MAMapView iosController;
  MAAnnotationMoveAnimation iosAnimation;
  MAAnimatedAnnotation annotation;

  Future<void> remove() async {
    return platform(
      android: (pool) => androidModel.removeMarker(),
      ios: (pool) => iosController.removeAnnotation(annotation),
    );
  }

  Future<void> stop() async {
    return platform(
      android: (pool) => androidModel.stopMove(),
      ios: (pool) => iosAnimation.cancel(),
    );
  }
}

/// 折线
class Polyline {
  Polyline.android(this.androidModel);

  Polyline.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_Polyline androidModel;
  MAPolyline iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 多边形
class Polygon {
  Polygon.android(this.androidModel);

  Polygon.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_Polygon androidModel;
  MAPolygon iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }

  Future<bool> contains(LatLng target) {
    return platform(
      android: (_) async {
        final latLng = await com_amap_api_maps_model_LatLng
            .create__double__double(target.latitude, target.longitude);
        return androidModel.contains(latLng);
      },
      ios: (_) async {
        final latLng = await CLLocationCoordinate2D.create(
            target.latitude, target.longitude);
        final point = await MAMapPointForCoordinate(latLng);
        final bounds = await iosModel.get_points();
        return MAPolygonContainsPoint(point, bounds, bounds.length);
      },
    );
  }
}

/// 圆形
class Circle {
  Circle.android(this.androidModel);

  Circle.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_Circle androidModel;
  MACircle iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 热力图
class HeatmapOverlay {
  HeatmapOverlay.android(this.androidModel);

  HeatmapOverlay.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_TileOverlay androidModel;
  MAHeatMapTileOverlay iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 热力图
class UrlTileOverlay {
  UrlTileOverlay.android(this.androidModel);

  UrlTileOverlay.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_TileOverlay androidModel;
  MAHeatMapTileOverlay iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 图片覆盖物
class GroundOverlay {
  GroundOverlay.android(this.androidModel);

  GroundOverlay.ios(this.iosModel, this.iosController);

  com_amap_api_maps_model_GroundOverlay androidModel;
  MAGroundOverlay iosModel;
  MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 海量点
class MultiPointOverlay {
  MultiPointOverlay.android(this.androidModel)
      : iosModel = null,
        iosController = null;

  MultiPointOverlay.ios(this.iosModel, this.iosController)
      : androidModel = null;

  final com_amap_api_maps_model_MultiPointOverlay androidModel;

  final MAMultiPointOverlay iosModel;
  final MAMapView iosController;

  Future<void> remove() {
    return platform(
      android: (_) => androidModel.remove(),
      ios: (_) => iosController?.removeOverlay(iosModel),
    );
  }
}

/// 回放轨迹
class PlaybackTrace {
  PlaybackTrace(this.marker, this.polyline);

  final SmoothMoveMarker marker;
  final Polyline polyline;

  Future<void> remove() async {
    await marker.remove();
    await polyline.remove();
  }

  Future<void> stop() async {
    await marker.stop();
  }
}

// ignore_for_file: non_constant_identifier_names, camel_case_types, missing_return, unused_import, unused_local_variable, dead_code, unnecessary_cast
//////////////////////////////////////////////////////////
// GENERATED BY FLUTTIFY. DO NOT EDIT IT.
//////////////////////////////////////////////////////////

import 'dart:typed_data';

import 'package:amap_map_fluttify/src/ios/ios.export.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:foundation_fluttify/foundation_fluttify.dart';
import 'package:core_location_fluttify/core_location_fluttify.dart';

class MAOverlayRenderer extends NSObject  {
  //region constants
  static const String name__ = 'MAOverlayRenderer';

  @override
  final String tag__ = 'amap_map_fluttify';

  
  //endregion

  //region creators
  static Future<MAOverlayRenderer> create__({ bool init = true /* ios only */ }) async {
    final refId = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::createMAOverlayRenderer', {'init': init});
    final object = MAOverlayRenderer()..refId = refId;
    return object;
  }
  
  static Future<List<MAOverlayRenderer>> create_batch__(int length, { bool init = true /* ios only */ }) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
    final List resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::create_batchMAOverlayRenderer', {'length': length, 'init': init});
  
    final List<MAOverlayRenderer> typedResult = resultBatch.map((result) => MAOverlayRenderer()..refId = result).toList();
    return typedResult;
  }
  
  //endregion

  //region getters
  Future<MAOverlay> get_overlay() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_overlay", {'__this__': this});
    return __result__ == null ? null : (MAOverlay.subInstance()..refId = __result__);
  }
  
  Future<UIImage> get_strokeImage() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_strokeImage", {'__this__': this});
    return __result__ == null ? null : (UIImage()..refId = __result__);
  }
  
  Future<int> get_strokeTextureID() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_strokeTextureID", {'__this__': this});
    return __result__ == null ? null : (__result__);
  }
  
  Future<double> get_alpha() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_alpha", {'__this__': this});
    return __result__ == null ? null : (__result__);
  }
  
  Future<double> get_contentScale() async {
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_contentScale", {'__this__': this});
    return __result__ == null ? null : (__result__);
  }
  
  //endregion

  //region setters
  Future<void> set_strokeImage(UIImage strokeImage) async {
    await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::set_strokeImage', <String, dynamic>{'__this__': this, "strokeImage": strokeImage});
  
  
  }
  
  Future<void> set_alpha(double alpha) async {
    await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::set_alpha', <String, dynamic>{'__this__': this, "alpha": alpha});
  
  
  }
  
  //endregion

  //region methods
  
  Future<MAOverlayRenderer> initWithOverlay(MAOverlay overlay) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::initWithOverlay([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::initWithOverlay', {"overlay": overlay, "__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = MAOverlayRenderer()..refId = __result__;
      return __return__;
    }
  }
  
  
  Future<NSValue/* float* */> getViewMatrix() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::getViewMatrix([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getViewMatrix', {"__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = NSValue/* float* */()..refId = __result__;
      return __return__;
    }
  }
  
  
  Future<NSValue/* float* */> getProjectionMatrix() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::getProjectionMatrix([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getProjectionMatrix', {"__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = NSValue/* float* */()..refId = __result__;
      return __return__;
    }
  }
  
  
  Future<MAMapPoint> getOffsetPoint() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::getOffsetPoint([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getOffsetPoint', {"__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = MAMapPoint()..refId = __result__;
      return __return__;
    }
  }
  
  
  Future<double> getMapZoomLevel() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::getMapZoomLevel([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getMapZoomLevel', {"__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
      return __return__;
    }
  }
  
  
  Future<CGPoint> glPointForMapPoint(MAMapPoint mapPoint) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::glPointForMapPoint([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glPointForMapPoint', {"mapPoint": mapPoint, "__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = CGPoint()..refId = __result__;
      return __return__;
    }
  }
  
  
  Future<List<CGPoint>> glPointsForMapPoints_count(List<MAMapPoint> mapPoints, int count) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::glPointsForMapPoints([\'count\':$count])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glPointsForMapPoints_count', {"mapPoints": mapPoints, "count": count, "__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = (__result__ as List).cast<String>().map((__it__) => CGPoint()..refId = __it__).toList();
      return __return__;
    }
  }
  
  
  Future<double> glWidthForWindowWidth(double windowWidth) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::glWidthForWindowWidth([\'windowWidth\':$windowWidth])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glWidthForWindowWidth', {"windowWidth": windowWidth, "__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
      return __return__;
    }
  }
  
  @deprecated
  Future<void> renderLinesWithPoints_pointCount_strokeColor_lineWidth_looped(List<CGPoint> points, int pointCount, UIColor strokeColor, double lineWidth, bool looped) async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: MAOverlayRenderer@$refId::renderLinesWithPoints([\'pointCount\':$pointCount, \'lineWidth\':$lineWidth, \'looped\':$looped])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::renderLinesWithPoints_pointCount_strokeColor_lineWidth_looped', {"points": points, "pointCount": pointCount, "strokeColor": strokeColor, "lineWidth": lineWidth, "looped": looped, "__this__": this});
  
  
    // handle native call
  
  
    // convert native result to dart side object
    if (__result__ == null) {
      return null;
    } else {
      final __return__ = __result__;
      return __return__;
    }
  }
  
  //endregion

  @override
  String toString() {
    return 'MAOverlayRenderer{refId: $refId, runtimeType: $runtimeType, tag__: $tag__}';
  }
}

extension MAOverlayRenderer_Batch on List<MAOverlayRenderer> {
  //region getters
  Future<List<MAOverlay>> get_overlay_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_overlay_batch", [for (final __item__ in this) {'__this__': __item__}]);
  
    final typedResult = (resultBatch as List).cast<String>().map((__result__) => MAOverlay.subInstance()..refId = __result__).toList();
    return typedResult;
  }
  
  Future<List<UIImage>> get_strokeImage_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_strokeImage_batch", [for (final __item__ in this) {'__this__': __item__}]);
  
    final typedResult = (resultBatch as List).cast<String>().map((__result__) => UIImage()..refId = __result__).toList();
    return typedResult;
  }
  
  Future<List<int>> get_strokeTextureID_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_strokeTextureID_batch", [for (final __item__ in this) {'__this__': __item__}]);
  
    final typedResult = (resultBatch as List).cast<int>().map((__result__) => __result__).toList();
    return typedResult;
  }
  
  Future<List<double>> get_alpha_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_alpha_batch", [for (final __item__ in this) {'__this__': __item__}]);
  
    final typedResult = (resultBatch as List).cast<double>().map((__result__) => __result__).toList();
    return typedResult;
  }
  
  Future<List<double>> get_contentScale_batch() async {
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod("MAOverlayRenderer::get_contentScale_batch", [for (final __item__ in this) {'__this__': __item__}]);
  
    final typedResult = (resultBatch as List).cast<double>().map((__result__) => __result__).toList();
    return typedResult;
  }
  
  //endregion

  //region setters
  Future<void> set_strokeImage_batch(List<UIImage> strokeImage) async {
    await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec())).invokeMethod('MAOverlayRenderer::set_strokeImage_batch', [for (int __i__ = 0; __i__ < length; __i__++) {'__this__': this[__i__], "strokeImage": strokeImage[__i__]}]);
  
  
  }
  
  Future<void> set_alpha_batch(List<double> alpha) async {
    await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec())).invokeMethod('MAOverlayRenderer::set_alpha_batch', [for (int __i__ = 0; __i__ < length; __i__++) {'__this__': this[__i__], "alpha": alpha[__i__]}]);
  
  
  }
  
  //endregion

  //region methods
  
  Future<List<MAOverlayRenderer>> initWithOverlay_batch(List<MAOverlay> overlay) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::initWithOverlay_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"overlay": overlay[__i__], "__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => MAOverlayRenderer()..refId = __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<NSValue/* float* */>> getViewMatrix_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getViewMatrix_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => NSValue/* float* */()..refId = __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<NSValue/* float* */>> getProjectionMatrix_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getProjectionMatrix_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => NSValue/* float* */()..refId = __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<MAMapPoint>> getOffsetPoint_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getOffsetPoint_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => MAMapPoint()..refId = __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<double>> getMapZoomLevel_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::getMapZoomLevel_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<double>().map((__result__) => __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<CGPoint>> glPointForMapPoint_batch(List<MAMapPoint> mapPoint) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glPointForMapPoint_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"mapPoint": mapPoint[__i__], "__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => CGPoint()..refId = __result__).toList();
      return typedResult;
    }
  }
  
  
  Future<List<List<CGPoint>>> glPointsForMapPoints_count_batch(List<List<MAMapPoint>> mapPoints, List<int> count) async {
    if (mapPoints.length != count.length) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glPointsForMapPoints_count_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"mapPoints": mapPoints[__i__], "count": count[__i__], "__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => (__result__ as List).cast<String>().map((__it__) => CGPoint()..refId = __it__).toList()).toList();
      return typedResult;
    }
  }
  
  
  Future<List<double>> glWidthForWindowWidth_batch(List<double> windowWidth) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::glWidthForWindowWidth_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"windowWidth": windowWidth[__i__], "__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<double>().map((__result__) => __result__).toList();
      return typedResult;
    }
  }
  
  @deprecated
  Future<List<void>> renderLinesWithPoints_pointCount_strokeColor_lineWidth_looped_batch(List<List<CGPoint>> points, List<int> pointCount, List<UIColor> strokeColor, List<double> lineWidth, List<bool> looped) async {
    if (points.length != pointCount.length || pointCount.length != strokeColor.length || strokeColor.length != lineWidth.length || lineWidth.length != looped.length) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('MAOverlayRenderer::renderLinesWithPoints_pointCount_strokeColor_lineWidth_looped_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"points": points[__i__], "pointCount": pointCount[__i__], "strokeColor": strokeColor[__i__], "lineWidth": lineWidth[__i__], "looped": looped[__i__], "__this__": this[__i__]}]);
  
  
    // convert native result to dart side object
    if (resultBatch == null) {
      return null;
    } else {
      final typedResult = (resultBatch as List).cast<String>().map((__result__) => __result__).toList();
      return typedResult;
    }
  }
  
  //endregion
}
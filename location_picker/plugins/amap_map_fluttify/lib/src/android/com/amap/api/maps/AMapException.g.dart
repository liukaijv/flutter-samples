// ignore_for_file: non_constant_identifier_names, camel_case_types, missing_return, unused_import, unused_local_variable, dead_code, unnecessary_cast
//////////////////////////////////////////////////////////
// GENERATED BY FLUTTIFY. DO NOT EDIT IT.
//////////////////////////////////////////////////////////

import 'dart:typed_data';

import 'package:amap_map_fluttify/src/android/android.export.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:foundation_fluttify/foundation_fluttify.dart';
import 'package:core_location_fluttify/core_location_fluttify.dart';

class com_amap_api_maps_AMapException extends java_lang_Object  {
  //region constants
  static const String name__ = 'com.amap.api.maps.AMapException';

  @override
  final String tag__ = 'amap_map_fluttify';

  static final String ERROR_IO = "IO 操作异常 - IOException";
  static final String ERROR_SOCKET = "socket 连接异常 - SocketException";
  static final String ERROR_SOCKE_TIME_OUT = "socket 连接超时 - SocketTimeoutException";
  static final String ERROR_INVALID_PARAMETER = "无效的参数 - IllegalArgumentException";
  static final String ERROR_NULL_PARAMETER = "空指针异常 - NullPointException";
  static final String ERROR_URL = "url异常 - MalformedURLException";
  static final String ERROR_UNKNOW_HOST = "未知主机 - UnKnowHostException";
  static final String ERROR_UNKNOW_SERVICE = "服务器连接失败 - UnknownServiceException";
  static final String ERROR_PROTOCOL = "协议解析错误 - ProtocolException";
  static final String ERROR_CONNECTION = "http连接失败 - ConnectionException";
  static final String ERROR_UNKNOWN = "未知的错误";
  static final String ERROR_FAILURE_AUTH = "key鉴权失败";
  static final String ERROR_NOT_ENOUGH_SPACE = "空间不足";
  static final String ERROR_NOT_AVAILABLE = "不可写入异常";
  static final String ERROR_ILLEGAL_VALUE = "非法坐标值";
  static final String AMAP_NOT_SUPPORT = "移动设备上未安装高德地图或高德地图版本较旧";
  static final String ILLEGAL_AMAP_ARGUMENT = "非法参数";
  static final String ERROR_FAILURE_OVERSEA_AUTH = "海外鉴权失败";
  //endregion

  //region creators
  static Future<com_amap_api_maps_AMapException> create__String(String var1) async {
    final refId = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::createcom_amap_api_maps_AMapException__String', {"var1": var1});
    final object = com_amap_api_maps_AMapException()..refId = refId;
    return object;
  }
  
  static Future<com_amap_api_maps_AMapException> create__() async {
    final refId = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::createcom_amap_api_maps_AMapException__', );
    final object = com_amap_api_maps_AMapException()..refId = refId;
    return object;
  }
  
  static Future<List<com_amap_api_maps_AMapException>> create_batch__String(List<String> var1) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
    final List resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::create_batchcom_amap_api_maps_AMapException__String', [for (int __i__ = 0; __i__ < var1.length; __i__++) {"var1": var1[__i__]}]);
  
    final List<com_amap_api_maps_AMapException> typedResult = resultBatch.map((result) => com_amap_api_maps_AMapException()..refId = result).toList();
    return typedResult;
  }
  
  static Future<List<com_amap_api_maps_AMapException>> create_batch__(int length) async {
    if (false) {
      return Future.error('all args must have same length!');
    }
    final List resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('ObjectFactory::create_batchcom_amap_api_maps_AMapException__', {'length': length});
  
    final List<com_amap_api_maps_AMapException> typedResult = resultBatch.map((result) => com_amap_api_maps_AMapException()..refId = result).toList();
    return typedResult;
  }
  
  //endregion

  //region getters
  
  //endregion

  //region setters
  
  //endregion

  //region methods
  
  Future<String> getErrorMessage() async {
    // print log
    if (fluttifyLogEnabled) {
      debugPrint('fluttify-dart: com.amap.api.maps.AMapException@$refId::getErrorMessage([])');
    }
  
    // invoke native method
    final __result__ = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('com.amap.api.maps.AMapException::getErrorMessage', {"__this__": this});
  
  
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
    return 'com_amap_api_maps_AMapException{refId: $refId, runtimeType: $runtimeType, tag__: $tag__}';
  }
}

extension com_amap_api_maps_AMapException_Batch on List<com_amap_api_maps_AMapException> {
  //region getters
  
  //endregion

  //region setters
  
  //endregion

  //region methods
  
  Future<List<String>> getErrorMessage_batch() async {
    if (false) {
      return Future.error('all args must have same length!');
    }
  
    // invoke native method
    final resultBatch = await MethodChannel('me.yohom/amap_map_fluttify', StandardMethodCodec(FluttifyMessageCodec('amap_map_fluttify'))).invokeMethod('com.amap.api.maps.AMapException::getErrorMessage_batch', [for (int __i__ = 0; __i__ < length; __i__++) {"__this__": this[__i__]}]);
  
  
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
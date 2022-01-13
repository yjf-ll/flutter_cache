import 'package:flutter_cache/cache/cache_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  final SharedPreferences sharedPreferences;

  AppCache._({required this.sharedPreferences});

  factory AppCache.create({
    required SharedPreferences sharedPreferences,
  }) =>
      AppCache._(
        sharedPreferences: sharedPreferences,
      );

  //  缓存类采取单例模式
  static AppCache? _instance;

  //  一定要在main里面初始化
  static Future<void> init() async {
    _instance ??= AppCache.create(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  }

  // 简化获取工具类的缓存实例，以便在下方封装一些方法
  static SharedPreferences get _pre => _instance!.sharedPreferences;

  //  封装设置token的方法
  static Future<bool> setToken(String token) async {
    return await _pre.setString(CacheKey.TOKEN, token);
  }

  //  封装清除token的方法
  static Future<bool> cleanToken() async {
    return await _pre.setString(CacheKey.TOKEN, '');
  }

  //  封装获取token的方法
  static String? get token => _pre.getString(CacheKey.TOKEN);

  //  封装设置phone的方法
  static Future<bool> setPhone(String phone) async {
    return _pre.setString(CacheKey.PHONE, phone);
  }

  //  封装清除phone的方法
  static Future<bool> cleanPhone() async {
    return await _pre.setString(CacheKey.PHONE, '');
  }

  //  封装获取phone的方法
  static String? get phone => _pre.getString(CacheKey.PHONE);

}

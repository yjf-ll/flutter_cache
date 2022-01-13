# flutter_cache

#### 一：前言

在项目开发中有一些数据是经常使用的（比如账号，token等），并且希望重新打开app数据也还在，所有这个时候就可以把一些数据放在缓存中保存起来，下次就可以直接从缓存中获取了，借此，封装一个缓存类还是很有必要的，个人封装思路如下:

- 使用单例封装一个缓存类，在main函数里面初始化，并在类里面添加一些常用的方法

- 封装一个工具类来保存常用的键名

#### 二：废话不多说，现在开始

- 在项目中添加缓存依赖库，我这里使用的是shared_preferences 

  > flutter pub add shared_preferences

- 编写缓存键名工具类

  ```dart
  // 缓存里的值的键名, 格式因人因项目而异，我这里取得比较简单
  class CacheKey {
    static const String TOKEN = 'app_token';
  
    static const String PHONE = 'app_phone';
  }
  ```

- 编写缓存类

  ```dart
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
  ```

- 首页代码如下

  ```dart
  Future<void> main() async {
    //  这条语句一定要加上，不然会报错，具体原因可以搜一下，这里就不解释了
    WidgetsFlutterBinding.ensureInitialized();
    //  初始化缓存工具类
    await AppCache.init();
    runApp(MyApp());
  }
  
  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      );
    }
  }
  
  class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);
  
    @override
    _HomePageState createState() => _HomePageState();
  }
  
  class _HomePageState extends State<HomePage> {
    String? phone;
  
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      getPhone();
    }
  
    void getPhone() {
      print('获取手机号码');
      setState(() {
        //  使用方法，直接调用工具类设置的一些get方法就可以获取想要的数据了
        phone = AppCache.phone;
      });
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cache demo'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('当前保存的手机号码是：$phone'),
              ElevatedButton(
                onPressed: () async {
                  //  保存手机号
                  await AppCache.setPhone('137xxxxxxxx');
                  getPhone();
                },
                child: Text('保存'),
              ),
              ElevatedButton(
                onPressed: () async {
                  //  清除手机号
                  await AppCache.cleanPhone();
                  getPhone();
                },
                child: Text('清除'),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- 附上demo图，点击保存，重新打开app，手机号还在，完结。感谢看完的小伙伴，倘若有更好的实现方式欢迎一起交流啊  ^_^

![img.png](img.png)






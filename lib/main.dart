import 'package:flutter/material.dart';
import 'package:flutter_cache/cache/cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
                await AppCache.setPhone('137xxxxxxxx');
                getPhone();
              },
              child: Text('保存'),
            ),
            ElevatedButton(
              onPressed: () async {
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

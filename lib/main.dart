import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugas_resep/models/resep_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ResepHiveAdapter());
  await Hive.openBox<ResepHive>('favorites');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:la_loge/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

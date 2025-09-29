import 'package:flutter/material.dart';
import 'core/config/supabase_config.dart';
import 'services/services.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  // Initialize Services
  await ServiceProvider.initialize();
  
  runApp(const CollegeConfessionsApp());
}

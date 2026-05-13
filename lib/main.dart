import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/work_order_provider.dart';
import 'providers/plant_provider.dart';

import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/notifications/notification_list_screen.dart';
import 'screens/notifications/notification_detail_screen.dart';
import 'screens/work_orders/work_order_list_screen.dart';
import 'screens/work_orders/work_order_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authProvider = AuthProvider();
  await authProvider.checkLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WorkOrderProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: const MaintenancePortalApp(),
    ),
  );
}

class MaintenancePortalApp extends StatelessWidget {
  const MaintenancePortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'Maintenance Portal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: authProvider.isAuthenticated ? '/dashboard' : '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/notifications': (context) => const NotificationListScreen(),
            '/notification_detail': (context) => const NotificationDetailScreen(),
            '/work_orders': (context) => const WorkOrderListScreen(),
            '/work_order_detail': (context) => const WorkOrderDetailScreen(),
          },
        );
      },
    );
  }
}

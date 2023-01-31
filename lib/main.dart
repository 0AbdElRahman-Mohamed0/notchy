import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notchy/providers/auth_provider.dart';
import 'package:notchy/providers/cart_provider.dart';
import 'package:notchy/providers/categories_provider.dart';
import 'package:notchy/providers/navigation_index_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/screens/auth_screens/login_screen.dart';
import 'package:notchy/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationIndexProvider>(
          create: (_) => NavigationIndexProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ProductsProvider>(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider<CategoriesProvider>(
          create: (_) => CategoriesProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Notchy',
        theme: NotchyTheme.getLightTheme(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}

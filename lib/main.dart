import 'package:alak/admin/screens/admin_screen.dart';
import 'package:alak/common/widgets/bottom_bar.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/features/auth/screens/auth_screen.dart';
import 'package:alak/features/auth/services/auth_service.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:alak/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    await authService.getUserData(context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : context.read<UserProvider>().user.token.isNotEmpty
              ? context.read<UserProvider>().user.type == 'user'
                  ? const BottomBar()
                  : const AdminScreen()
              : const AuthScreen(),
    );
  }
}

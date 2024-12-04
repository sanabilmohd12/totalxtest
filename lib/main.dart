import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/home/data/i_userfacade.dart';
import 'package:totalxtest/features/home/presentation/provider/main_provider.dart';
import 'package:totalxtest/features/home/presentation/view/home_screen.dart';
import 'package:totalxtest/features/productuploading/data/i_product_facade.dart';
import 'package:totalxtest/features/productuploading/presentation/provider/product_provider.dart';
import 'package:totalxtest/general/di/injection.dart';

import 'features/login/presentation/provider/loginprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await configureDependency();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(sl<IUserfacade>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(sl<IProductFacade>()),
        ),
        ChangeNotifierProvider(
          create: (context) => Loginprovider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TotalXtest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

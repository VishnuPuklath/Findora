import 'package:alak/admin/screens/add_product_screen.dart';
import 'package:alak/admin/screens/admin_screen.dart';
import 'package:alak/admin/screens/posts_screen.dart';
import 'package:alak/common/widgets/bottom_bar.dart';
import 'package:alak/features/address/screens/address_screen.dart';
import 'package:alak/features/auth/screens/auth_screen.dart';
import 'package:alak/features/home/screens/category_deals_screen.dart';
import 'package:alak/features/home/screens/home_screen.dart';
import 'package:alak/features/ordered_details/screens/ordered_detail_screen.dart';
import 'package:alak/features/product_details/screen/product_detail_screen.dart';
import 'package:alak/features/search/screens/search_screen.dart';
import 'package:alak/models/order.dart';
import 'package:alak/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const BottomBar(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AdminScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddProductScreen(),
      );
    case PostsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const PostsScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderedDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => OrderedDetailScreen(order: order),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Screen doesnt exist'),
          ),
        ),
      );
  }
}

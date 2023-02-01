import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/cart_provider.dart';
import 'package:notchy/providers/navigation_index_provider.dart';
import 'package:notchy/ui/screens/nav_screens/account_screen.dart';
import 'package:notchy/ui/screens/nav_screens/cart_screen.dart';
import 'package:notchy/ui/screens/nav_screens/home_screen.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];
  }

  _clearCart() async {
    try {
      LoadingScreen.show(context);
      await context.read<CartProvider>().deleteCart();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your cart deleted successfully.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } on DioError catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = context.watch<NavigationIndexProvider>().index;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          index == 0
              ? 'Home'
              : index == 1
                  ? 'Cart'
                  : 'Account',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: index == 1
            ? [
                IconButton(
                  onPressed: _clearCart,
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                )
              ]
            : [],
      ),
      body: _widgetOptions.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).shadowColor,
        elevation: 0.0,
        iconSize: 24,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).scaffoldBackgroundColor,
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
        items: [
          BottomNavigationBarItem(
            activeIcon: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.home_filled,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            icon: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.home_filled,
                size: 20,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            icon: Icon(
              Icons.shopping_cart,
              size: 20,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            activeIcon: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.account_circle_outlined,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            icon: Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.account_circle_outlined,
                size: 20,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: index,
        onTap: (index) {
          context.read<NavigationIndexProvider>().changeIndex(index);
          if (mounted) setState(() {});
        },
      ),
    );
  }
}

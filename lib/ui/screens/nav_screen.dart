import 'package:flutter/material.dart';
import 'package:notchy/providers/navigation_index_provider.dart';

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
      const Center(
        child: Text('home'),
      ),
      const Center(
        child: Text('cart'),
      ),
      const Center(
        child: Text('profile'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final index = context.watch<NavigationIndexProvider>().index;

    return Scaffold(
      body: _widgetOptions.elementAt(index),
      bottomNavigationBar: Container(
        // height: (MediaQuery.of(context).size.height * 90) / 812,
        decoration: const BoxDecoration(
          color: Color(0xFF2A292A),
        ),
        child: BottomNavigationBar(
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
      ),
    );
  }
}

import 'package:cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fake_user_package/user_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:home/home_model.dart';
import 'package:product/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late String baseUrl;

  late List<HomeModel> _homeModels;

  @override
  void initState() {
    baseUrl = GetIt.I<String>();

    _homeModels = [
      HomeModel(
        title: 'Products',
        page: ProductScreen(baseUrl: baseUrl),
        icon: const Icon(Icons.store),
      ),
      HomeModel(
        title: 'Cart',
        page: CartScreen(baseUrl: baseUrl),
        icon: const Icon(Icons.shopping_cart),
      ),
      HomeModel(
        title: 'User',
        page: UserScreen(baseUrl: baseUrl),
        icon: const Icon(Icons.person),
      ),
    ];

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600) ...[
            NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.all,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                selectedIconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                useIndicator: false,
                selectedLabelTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                destinations: _homeModels
                    .map(
                      (model) => NavigationRailDestination(
                        icon: model.icon,
                        label: Text(model.title),
                      ),
                    )
                    .toList()),
            const VerticalDivider(thickness: 1, width: 1),
          ],
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _homeModels.map((model) => model.page).toList(),
            ),
          )
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              items: _homeModels
                  .map((model) => BottomNavigationBarItem(
                        icon: model.icon,
                        label: model.title,
                      ))
                  .toList(),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
    );
  }
}

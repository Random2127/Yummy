import 'package:flutter/material.dart';
import 'package:yummy/screens/add_screen.dart';
import 'package:yummy/screens/chat_screen.dart';
import 'package:yummy/screens/favourites_screen.dart';
import 'package:yummy/screens/param_screen.dart';
import 'package:yummy/widgets/custom_app_bar.dart';
import 'package:yummy/widgets/custom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [ChatScreen(), AddScreen(), FavouritesScreen(), ParamsScreen()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lab_assg_2/List/tutorsList.dart';

import '../List/subjectsList.dart';


class mainScreen extends StatefulWidget {
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
      
  final List<Widget> _widgetOptions = <Widget>[
    subjectsList(),
    tutorsList(),
    const Text(
      'Subscribe',
      style: optionStyle,
    ),
    const Text(
      'Favourite',
      style: optionStyle,
    ),
    const Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY Tutor'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: 'Subjects',
            backgroundColor: Colors.blue[200],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: 'Tutors',
            backgroundColor: Colors.green[200],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.subscriptions),
            label: 'Subscribe',
            backgroundColor: Colors.orange[200],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Favourite',
            backgroundColor: Colors.pink[200],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.purple[200],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResponseProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StrollBonfireScreen(),
    );
  }
}

class StrollBonfireScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          GradientOverlay(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(), // Placeholder for any top content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ProfileAndOptions(),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
    );
  }
}

class ProfileAndOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/profile.png'),
          radius: 30,
        ),
        SizedBox(height: 10),
        Text(
          'Angelina, 28',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          'What is your favorite time of the day?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '"Mine is definitely the peace in the morning."',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 20),
        OptionRow(
          options: [
            Option(text: 'The peace in the early mornings', label: 'A'),
            Option(text: 'The magical golden hours', label: 'B'),
          ],
        ),
        SizedBox(height: 8),
        OptionRow(
          options: [
            Option(text: 'Wind-down time after dinners', label: 'C'),
            Option(text: 'The serenity past midnight', label: 'D'),
          ],
        ),
      ],
    );
  }
}

class OptionRow extends StatelessWidget {
  final List<Option> options;

  OptionRow({required this.options});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options
          .map(
            (option) => Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: OptionButton(text: option.text, label: option.label),
              ),
            ),
          )
          .toList(),
    );
  }
}

class Option {
  final String text;
  final String label;

  Option({required this.text, required this.label});
}

class OptionButton extends StatelessWidget {
  final String text;
  final String label;

  OptionButton({required this.text, required this.label});

  @override
  Widget build(BuildContext context) {
    final responseProvider = Provider.of<ResponseProvider>(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 65, 62, 62).withOpacity(0.8),
        onPrimary: const Color.fromARGB(255, 190, 190, 190),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        responseProvider.setSelectedResponse(text);
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Container(
      color: Colors.black,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationIcon(
            assetPath: 'assets/card.png',
            index: 0,
            selectedIndex: navigationProvider.selectedIndex,
            onTap: () => navigationProvider.setSelectedIndex(0),
          ),
          NavigationIcon(
            assetPath: 'assets/fire.png',
            index: 1,
            selectedIndex: navigationProvider.selectedIndex,
            onTap: () => navigationProvider.setSelectedIndex(1),
          ),
          NavigationIcon(
            assetPath: 'assets/chat.png',
            index: 2,
            selectedIndex: navigationProvider.selectedIndex,
            onTap: () => navigationProvider.setSelectedIndex(2),
          ),
          NavigationIcon(
            assetPath: 'assets/user.png',
            index: 3,
            selectedIndex: navigationProvider.selectedIndex,
            onTap: () => navigationProvider.setSelectedIndex(3),
          ),
        ],
      ),
    );
  }
}

class NavigationIcon extends StatelessWidget {
  final String assetPath;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  NavigationIcon({
    required this.assetPath,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: index == 0 || index == 3 ? 40.0 : 20.0,
      icon: ImageIcon(
        AssetImage(assetPath),
        color: selectedIndex == index
            ? Color.fromARGB(255, 117, 115, 163)
            : Color(0xffb5b2ff),
      ),
      onPressed: onTap,
    );
  }
}

class ResponseProvider extends ChangeNotifier {
  String _selectedResponse = '';

  String get selectedResponse => _selectedResponse;

  void setSelectedResponse(String response) {
    _selectedResponse = response;
    notifyListeners();
  }
}

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

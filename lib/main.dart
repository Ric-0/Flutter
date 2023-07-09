import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';

void main() {
  	runApp(const App());
}

class App extends StatelessWidget {
	const App({super.key});

	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		title: 'Flutter Shop',
		theme: ThemeData(
			useMaterial3: true,
			colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
		),
		home: const HomeScreen(title: 'Flutter Shop Home'),
		);
	}
}
import 'package:flutter/material.dart';
import 'package:movie_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_app/pages/home_page.dart';

void main() {
  RetrofitDataAgentImpl().getNowPlayingMovies(1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
// import '../../views/home_view.dart';
import '../../views/home/home_page.dart';
import '../../views/reader_view.dart';
import '../../views/quiz_view.dart';
import '../../views/result_view.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      // case ReaderView.route:
      //   return MaterialPageRoute(builder: (_) => ReaderView.fromArgs(settings.arguments));
      // case QuizView.route:
      //   return MaterialPageRoute(builder: (_) => QuizView.fromArgs(settings.arguments));
      // case ResultView.route:
      //   return MaterialPageRoute(builder: (_) => ResultView.fromArgs(settings.arguments));
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))));
    }
  }
}
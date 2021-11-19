import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/pages/bro_page.dart';
import 'package:motivator/pages/broup_page.dart';
import 'package:motivator/pages/home_page.dart';
import 'package:motivator/constants/route_paths.dart' as routes;

import 'objects/bro_bros.dart';
import 'objects/broup.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.BroRoute:
      BroBros bro = settings.arguments as BroBros;
      return MaterialPageRoute(builder: (context) => BroPage(bro: bro));
    case routes.BroupRoute:
      Broup broup = settings.arguments as Broup;
      return MaterialPageRoute(builder: (context) => BroupPage(broup: broup));
    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}

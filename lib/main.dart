import 'package:flutter/material.dart';
import 'package:flutter_navigator_v2/navigator_v2/route_Information_parser.dart';
import 'package:flutter_navigator_v2/navigator_v2/router_delegate.dart';

void main() {
  runApp(VeggiesApp());
}

class VeggiesApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VeggiesAppState();
}

class _VeggiesAppState extends State<VeggiesApp> {
  VeggieRouterDelegate _routerDelegate = VeggieRouterDelegate();
  VeggieRouteInformationParser _routeInformationParser =
      VeggieRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Veggies App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

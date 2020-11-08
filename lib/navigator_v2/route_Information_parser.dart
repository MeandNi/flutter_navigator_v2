import 'package:flutter/material.dart';
import 'package:flutter_navigator_v2/navigator_v2/model.dart';

class VeggieRouteInformationParser extends RouteInformationParser<VeggieRoutePath> {
  @override
  Future<VeggieRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("parseRouteInformation");
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return VeggieRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'veggie') return VeggieRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return VeggieRoutePath.unknown();
      return VeggieRoutePath.details(id);
    }

    // Handle unknown routes
    return VeggieRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(VeggieRoutePath path) {
    print("restoreRouteInformation");
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/veggie/${path.id}');
    }
    return null;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_navigator_v2/data/local_veggie_provider.dart';
import 'package:flutter_navigator_v2/data/veggie.dart';
import 'package:flutter_navigator_v2/navigator_v2/model.dart';
import 'package:flutter_navigator_v2/navigator_v2/page.dart';
import 'package:flutter_navigator_v2/screen/list.dart';
import 'package:flutter_navigator_v2/screen/unknown.dart';

class VeggieRouterDelegate extends RouterDelegate<VeggieRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<VeggieRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Veggie _selectedVeggie;
  bool show404 = false;

  List<Veggie> veggies = LocalVeggieProvider.veggies;

  VeggieRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  VeggieRoutePath get currentConfiguration {
    print("currentConfiguration");
    if (show404) {
      return VeggieRoutePath.unknown();
    }
    return _selectedVeggie == null
        ? VeggieRoutePath.home()
        : VeggieRoutePath.details(veggies.indexOf(_selectedVeggie));
  }

  @override
  Widget build(BuildContext context) {

    List<Page> pages = <Page>[
      MaterialPage(
        key: ValueKey('VeggiesListPage'),
        child: VeggiesListScreen(
          veggies: veggies,
          onTapped: _handleVeggieTapped,
        ),
      ),
      if (show404)
        MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
      else
        if (_selectedVeggie != null)
          VeggieDetailsPage(veggie: _selectedVeggie)
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedVeggie to null
        _selectedVeggie = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(VeggieRoutePath path) async {
    print("setNewRoutePath");
    if (path.isUnknown) {
      _selectedVeggie = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.id < 0 || path.id > veggies.length - 1) {
        show404 = true;
        return;
      }

      _selectedVeggie = veggies[path.id];
    } else {
      _selectedVeggie = null;
    }

    show404 = false;
  }

  void _handleVeggieTapped(Veggie veggie) {
    print("_handleVeggieTapped");
    _selectedVeggie = veggie;
    notifyListeners();
  }
}
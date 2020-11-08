import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// 该文件可独立运行
// 右击点击 create 'router_example.dart' -> OK
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final delegate = MyRouteDelegate(
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return MyHomePage(title: 'Route: ${settings.name}');
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routeInformationParser: MyRouteParser(),
      routerDelegate: delegate,
    );
  }
}

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final _stack = <String>[];

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  MyRouteDelegate({
    @required this.onGenerateRoute,
  });

  final RouteFactory onGenerateRoute;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;

  List<String> get stack => List.unmodifiable(_stack);

  void push(String newRoute) {
    _stack.add(newRoute);
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack
      ..clear()
      ..add(configuration);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last == route.settings.name) {
        _stack.remove(route.settings.name);
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    print('${describeIdentity(this)}.stack: $_stack');
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: [
        for (final name in _stack)
          MyPage(
            key: ValueKey(name),
            name: name,
          ),
      ],
    );
  }
}

class MyPage extends Page {
  const MyPage({
    LocalKey key,
    String name,
  }) : super(
    key: key,
    name: name,
  );

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return MyHomePage(title: 'Route: ${name}');
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int _counter = 0;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Is this being displayed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('YES'),
            ),
          ],
        );
      },
    );
  }

  void _removeLast() {
    final delegate = MyRouteDelegate.of(context);
    final stack = delegate.stack;
    if (stack.length > 2) {
      delegate.remove(stack[stack.length - 2]);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    MyRouteDelegate.of(context).push('Route$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'dialog',
            onPressed: _showDialog,
            tooltip: 'Show dialog',
            child: Icon(Icons.message),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: _removeLast,
            tooltip: 'Remove last',
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

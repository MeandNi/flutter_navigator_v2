import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

// 该文件可独立运行
// 右击点击 create 'pages_example.dart' -> OK
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static int _counter = 15;

  // Initial Route: /category/5/item/15
  final pages = [
    MyPage(
      key: Key('/'),
      name: '/',
      builder: (context) => HomeScreen(),
    ),
    MyPage(
      key: Key('/category/5'),
      name: '/category/5',
      builder: (context) => CategoryScreen(id: 5),
    ),
    MyPage(
      key: Key('/item/15'),
      name: '/item/15',
      builder: (context) => ItemScreen(id: 15),
    ),
  ];

  void addPage(MyPage page) {
    setState(() => pages.add(page));
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    setState(() => pages.remove(route.settings));
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    print('build: $pages');
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: WillPopScope(
          onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
          child: Navigator(
            key: _navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pages),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              final int id = ++_counter;
              pages.add(
                MyPage(
                  key: Key('/item/$id'),
                  name: '/item/$id',
                  builder: (context) => ItemScreen(id: id),
                ),
              );
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyPage<T> extends Page<T> {
  const MyPage({
    @required LocalKey key,
    @required String name,
    @required this.builder,
  }) : super(key: key, name: name);

  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }

  @override
  String toString() => '$name';
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: Center(
        child: Text(
          'Home',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key key, this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      child: Center(
        child: Text(
          'Category $id',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key key, this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Item $id\n${ModalRoute.of(context).settings}',
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

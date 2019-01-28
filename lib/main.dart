import 'package:flutter/material.dart';
import 'newroute.dart';

void main() => runApp(MyApp());

/// main enter
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {'newPage': (context) => NewPage()},
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override


  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<bool> _selectList = [true, false, false, false];
  List<Tab> myTabs = [
    Tab(
      text: 'aaa',
      icon: Icon(Icons.list),
    ),
    Tab(
      text: 'aaa',
      icon: Icon(Icons.list),
    ),
    Tab(
      text: 'aaa',
      icon: Icon(Icons.list),
    ),
    Tab(
      text: 'aaa',
      icon: Icon(Icons.list),
    )
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  void changePosition(int position) {
    setState(() {
      for (int i = 0; i < _selectList.length; i++) {
        if (position == i) {
          _selectList[i] = true;
        } else {
          _selectList[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('drawer head'),
              decoration: BoxDecoration(color: Colors.amber),
            ),
            Column(
//              mainAxisSize: ,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.subtitles),
                  title: Text('aaa'),
                  selected: _selectList[0],
                  onTap: () {
                    changePosition(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.subtitles),
                  title: Text('aaa'),
                  selected: _selectList[1],
                  onTap: () {
                    changePosition(1);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              title: Text('more'),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.subtitles),
                  title: Text('aaa'),
                  selected: _selectList[2],
                  onTap: () {
                    changePosition(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.subtitles),
                  title: Text('aaa'),
                  selected: _selectList[3],
                  onTap: () {
                    changePosition(3);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          return Center(child: Text(tab.text));
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          Navigator.pushNamed(context, 'newPage');
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new NewPage();
          }));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// xian du item
class XDItem extends StatefulWidget {
  @override
  _XDItemState createState() => _XDItemState();
}

class _XDItemState extends State<XDItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom AppBar Example"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          )
        ],
      ),
      body: Container(),
      floatingActionButton: CustomFab(
        onPressed: () {},
        child: Icon(Icons.healing),
        color: Colors.lightBlue,
        notchMargin: 4.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(
        color: Colors.green,
        hasNotch: true,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final Color color;
  final bool hasNotch;

  BottomBar({this.color, this.hasNotch});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      hasNotch: hasNotch,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => Drawer(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.search),
                            title: Text('Search App'),
                          ),
                          ListTile(
                            leading: Icon(Icons.rotate_right),
                            title: Text('Rotate App'),
                          ),
                        ],
                      ),
                    )),
          ),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class CustomFab extends StatefulWidget {
  final Widget child;
  final double notchMargin;
  final VoidCallback onPressed;
  final Color color;

  CustomFab({
    this.child,
    this.notchMargin: 8.0,
    this.onPressed,
    this.color,
  });

  @override
  CustomFabState createState() => CustomFabState();
}

class CustomFabState extends State<CustomFab> {
  VoidCallback _notchChange;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      shape: CustomBorder(),
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          width: 55.0,
          height: 55.0,
          child: IconTheme.merge(
            data: IconThemeData(color: Theme.of(context).accentIconTheme.color),
            child: widget.child,
          ),
        ),
      ),
      elevation: 5.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notchChange =
        Scaffold.setFloatingActionButtonNotchFor(context, computeNotch);
  }

  @override
  void deactivate() {
    if (_notchChange != null) {
      _notchChange();
    }
    super.deactivate();
  }

  Path computeNotch(Rect main, Rect fab, Offset start, Offset end) {
    final Rect marginFab = fab.inflate(widget.notchMargin);
    if (!main.overlaps(marginFab)) return Path()..lineTo(end.dx, end.dy);

    final Rect intersection = marginFab.intersect(main);
    final double notchCenter = intersection.height *
        (marginFab.height / 2.0) /
        (marginFab.width / 2.0);

    return Path()
      ..lineTo(marginFab.center.dx - notchCenter, main.top)
      ..lineTo(marginFab.left + marginFab.width / 2.0, marginFab.bottom)
      ..lineTo(marginFab.center.dx + notchCenter, main.top)
      ..lineTo(end.dx, end.dy);
  }
}

class CustomBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

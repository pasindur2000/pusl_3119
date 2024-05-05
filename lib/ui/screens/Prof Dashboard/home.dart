import 'package:flutter/material.dart';

class P_Dashboard extends StatefulWidget {
  const P_Dashboard({Key? key}) : super(key: key);

  @override
  State<P_Dashboard> createState() => _P_DashboardState();
}

class _P_DashboardState extends State<P_Dashboard> {
  final List<String> items = List<String>.generate(30, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item),
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$item dismissed')));
            },
            background: Container(color: Colors.red),
            child: ListTile(title: Text('$item')),
          );
        },
      ),
    );
  }
}

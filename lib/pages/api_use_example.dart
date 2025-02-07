import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/property.dart';

class ApiUseExamplePage extends StatefulWidget {
  late Future<List<Property>> properties;

  ApiUseExamplePage({super.key});

  @override
  State<ApiUseExamplePage> createState() => _ApiUseExamplePageState();
}

class _ApiUseExamplePageState extends State<ApiUseExamplePage> {
  @override
  void initState() {
    super.initState();
    widget.properties = Property.listProperties();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: FutureBuilder(
                    future: widget.properties,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: [
                          for (var property in snapshot.data!)
                            Text(property.name)
                        ]);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    }))));
  }
}

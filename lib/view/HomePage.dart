import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<Details> fetchData() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/id?=1'));
  if (response.statusCode == 200) {
    return Details.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load data');
  }
}


class _HomePageState extends State<HomePage> {

  late Future<Details> futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversation"),),
      body:
      Center(
        child: FutureBuilder<Details>(
          future: futureDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.username);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

    );
  }
}

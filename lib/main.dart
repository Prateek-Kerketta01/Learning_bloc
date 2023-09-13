import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lbloc/bloc/bloc_action.dart';

import 'dart:developer' as devtools show log;

import 'package:lbloc/bloc/person.dart';
import 'package:lbloc/bloc/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      // primaryColor: Colors.black,
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (_) => PersonsBloc(),
      child: const HomePage(),
    ),
  ));
}

// We need to download and parse the JSON data
Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

// Writing the BLoc header

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                            url: person1Url, loader: getPersons),
                      );
                },
                child: const Text(
                  'Load json #1',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                            url: person2Url, loader: getPersons),
                      );
                },
                child: const Text(
                  'Load json #2',
                ),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResults, currentResults) {
              return previousResults?.persons != currentResults?.persons;
            },
            builder: ((context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

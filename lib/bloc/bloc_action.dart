// Define a list of person URLs
import 'package:flutter/foundation.dart' show immutable;
import 'package:lbloc/bloc/person.dart';

const person1Url = 'http://127.0.0.1:5501/api/persons1.json';
const person2Url = 'http://127.0.0.1:5501/api/person2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

// Define an action for loading persons
// This is my action(event)
@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}


// enum PersonUrl {
//   person1,
//   person2,
// }

// // Add the URLs to PersonUrl
// // extension is a feature that allows you to add new functionality to existing classes.
// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.person1:
//         return "http://127.0.0.1:5501/api/persons1.json";

//       case PersonUrl.person2:
//         return "http://127.0.0.1:5501/api/person2.json";
//     }
//   }
// }
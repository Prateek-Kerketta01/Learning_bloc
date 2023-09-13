import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lbloc/bloc/bloc_action.dart';
import 'package:lbloc/bloc/person.dart';
import 'package:lbloc/bloc/persons_bloc.dart';

const mockPersons1 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    age: 30,
    name: 'Bar',
  ),
];

const mockPersons2 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    age: 30,
    name: 'Bar',
  ),
];

Future<Iterable<Person>> mockGetPerson1(String _) => Future.value(mockPersons1);

Future<Iterable<Person>> mockGetPerson2(String _) => Future.value(mockPersons2);

void main() {
  group(
    'Testing bloc',
    () {
      // write our test

      late PersonsBloc bloc;

      setUp(() {
        bloc = PersonsBloc();
      });

      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      // fetch mock data (person1) and compare it with FetchResult

      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving personsf rom first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockPersons1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockPersons1,
            isRetrievedFromCache: true,
          ),
        ],
      );
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving personsf rom first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockPersons2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockPersons2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}

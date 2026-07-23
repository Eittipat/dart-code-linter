// dart format off
void takesParameters(
  String firstParameter,
  String secondParameter
) {}

void takesArguments(String firstArgument, String secondArgument, String third) {}

void main() {
  takesArguments(
    'one',
    'two',
    'three'
  );

  final values = [
    1,
    2
  ];

  final entries = {
    'one': 1,
    'two': 2
  };

  final record = (
    'first',
    'second'
  );

  final typed = Wrapper<
    int,
    String
  >();

  usePatterns(
    ('first', 'second'),
    ExampleObject(first: 'first', second: 'second'),
    ['first', 'second'],
    {'first': 'first', 'second': 'second'},
  );
}

enum ExampleEnum {
  first,
  second
}

class Wrapper<
  T,
  U
> {}

class ExampleObject {
  final String first;
  final String second;

  const ExampleObject({required this.first, required this.second});
}

typedef RecordType = (
  int,
  String
);

typedef NamedRecordType = ({
  int first,
  String second
});

void usePatterns(
  Object recordValue,
  Object objectValue,
  Object listValue,
  Object mapValue,
) {
  if (recordValue case (
    String first,
    String second
  )) {}

  if (objectValue case ExampleObject(
    :final first,
    :final second
  )) {}

  if (listValue case [
    final first,
    final second
  ]) {}

  if (mapValue case {
    'first': final first,
    'second': final second
  }) {}
}
// dart format on

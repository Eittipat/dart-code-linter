import 'package:dart_code_linter/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_linter/src/analyzers/lint_analyzer/rules/rules_list/prefer_trailing_comma/prefer_trailing_comma_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

// ignore_for_file: avoid_escaping_inner_quotes

const _correctExamplePath =
    'prefer_trailing_comma/examples/correct_example.dart';
const _incorrectExamplePath =
    'prefer_trailing_comma/examples/incorrect_example.dart';
const _perPartExamplePath =
    'prefer_trailing_comma/examples/per_part_example.dart';
const _allPerPartIssueLines = [
  4,
  13,
  18,
  23,
  28,
  33,
  46,
  51,
  63,
  68,
  79,
  84,
  89,
  94,
];

void main() {
  group('PreferTrailingCommaRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-trailing-comma',
        severity: Severity.style,
      );
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 9, 13, 18, 24, 28, 38, 49, 58, 64, 70],
        startColumns: [50, 7, 5, 52, 9, 8, 3, 59, 3, 3, 3],
        locationTexts: [
          'String thirdArgument',
          "'and another string for length exceed'",
          'String arg3',
          'String thirdArgument',
          "'and another string for length exceed'",
          "'some other string'",
          'sixthItem',
          'this.forthField',
          "'and another string for length exceed'",
          "'and another string for length exceed'",
          "'and another string for length exceed': 'and another string for length exceed'",
        ],
        messages: [
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
        ],
        replacementComments: [
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
        ],
        replacements: [
          'String thirdArgument,',
          "'and another string for length exceed',",
          'String arg3,',
          'String thirdArgument,',
          "'and another string for length exceed',",
          "'some other string',",
          'sixthItem,',
          'this.forthField,',
          "'and another string for length exceed',",
          "'and another string for length exceed',",
          "'and another string for length exceed': 'and another string for length exceed',",
        ],
      );
    });

    test('with default config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with custom config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final config = {'break-on': 1};

      final issues = PreferTrailingCommaRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [37, 41],
        startColumns: [23, 19],
        locationTexts: [
          '() {\n'
              '      return;\n'
              '    }',
          '() {\n'
              '      return;\n'
              '    }',
        ],
        messages: [
          'Prefer trailing comma.',
          'Prefer trailing comma.',
        ],
      );
    });

    test('skips when opening and closing tokens are on the same line',
        () async {
      final unit = await RuleTestHelper.createAndResolveFromFile(
        content: '''
void takeTwo(int first, int second) {}

void main() {
  takeTwo(1, 2);
  final values = [1, 2];
  final record = (1, 2);
}
''',
        filePath: 'prefer_trailing_comma/examples/same_line_skip_case.dart',
      );
      final config = {'break-on': 1};

      final issues = PreferTrailingCommaRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with default config reports issues for all supported parts',
        () async {
      final unit = await RuleTestHelper.resolveFromFile(_perPartExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: _allPerPartIssueLines,
      );
    });

    test('with scoped config applies defaults for absent decomposed rules',
        () async {
      final unit = await RuleTestHelper.resolveFromFile(_perPartExamplePath);
      final config = {
        'break-on': {
          'arguments': 'disable',
          'parameters': 'disable',
          'enum-values': 'disable',
          'collections': 'disable',
        },
      };

      final issues = PreferTrailingCommaRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [28, 33, 51, 63, 68, 79, 84, 89, 94],
      );
    });

    test('with scoped config supports disabling specific decomposed rules',
        () async {
      final unit = await RuleTestHelper.resolveFromFile(_perPartExamplePath);
      final config = {
        'break-on': {
          'arguments': 'disable',
          'parameters': 'disable',
          'enum-values': 'disable',
          'collections': 'disable',
          'type-arguments': 'disable',
        },
      };

      final issues = PreferTrailingCommaRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [28, 51, 63, 68, 79, 84, 89, 94],
      );
    });

    group('covers all supported scoped rules', () {
      final cases = <String, List<int>>{
        'arguments': [13],
        'parameters': [4],
        'enum-values': [46],
        'collections': [18, 23],
        'type-arguments': [33],
        'type-parameters': [51],
        'record-literals': [28],
        'record-patterns': [79],
        'object-patterns': [84],
        'list-patterns': [89],
        'map-patterns': [94],
        'record-type-positional-fields': [63],
        'record-type-named-fields': [68],
      };

      for (final entry in cases.entries) {
        test('enabling only "${entry.key}" reports only that rule findings',
            () async {
          final unit =
              await RuleTestHelper.resolveFromFile(_perPartExamplePath);
          final config = {
            'break-on': {
              'all': 'disable',
              entry.key: 1,
            },
          };

          final issues = PreferTrailingCommaRule(config).check(unit);

          RuleTestHelper.verifyIssues(
            issues: issues,
            startLines: entry.value,
          );
        });
      }
    });
  });
}

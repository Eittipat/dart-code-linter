part of 'prefer_trailing_comma_rule.dart';

class _ConfigParser {
  static const _breakOnConfigName = 'break-on';
  static const _oldBreakOnConfigName = 'break_on';
  static const _argumentsConfigName = 'arguments';
  static const _parametersConfigName = 'parameters';
  static const _enumValuesConfigName = 'enum-values';
  static const _collectionsConfigName = 'collections';
  static const _typeArgumentsConfigName = 'type-arguments';
  static const _typeParametersConfigName = 'type-parameters';
  static const _recordLiteralsConfigName = 'record-literals';
  static const _recordPatternsConfigName = 'record-patterns';
  static const _objectPatternsConfigName = 'object-patterns';
  static const _listPatternsConfigName = 'list-patterns';
  static const _mapPatternsConfigName = 'map-patterns';
  static const _recordTypePositionalFieldsConfigName =
      'record-type-positional-fields';
  static const _recordTypeNamedFieldsConfigName = 'record-type-named-fields';

  static const _allConfigName = 'all';
  static const _defaultConfigName = 'default';

  static const _disableValue = 'disable';

  static _BreakOnConfig parseBreakOnConfig(Map<String, Object> config) {
    final breakOn = config.containsKey(_breakOnConfigName)
        ? config[_breakOnConfigName]
        : config[_oldBreakOnConfigName];

    if (breakOn is Map<Object?, Object?>) {
      return _parseScopedBreakOnConfig(breakOn);
    }

    final fallback = _parsePartConfig(breakOn) ?? const _PartConfig.enabled();

    return _BreakOnConfig.all(fallback);
  }

  static _BreakOnConfig _parseScopedBreakOnConfig(
    Map<Object?, Object?> breakOn,
  ) {
    final fallback = _parsePartConfig(
          _readConfig(
            breakOn,
            primaryKey: _allConfigName,
            secondaryKey: _defaultConfigName,
          ),
        ) ??
        const _PartConfig.enabled(1);

    return _BreakOnConfig(
      arguments: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _argumentsConfigName,
              secondaryKey: 'argument',
            ),
          ) ??
          fallback,
      parameters: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _parametersConfigName,
              secondaryKey: 'parameter',
            ),
          ) ??
          fallback,
      enumValues: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _enumValuesConfigName,
              secondaryKey: 'enum_values',
            ),
          ) ??
          fallback,
      collections: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _collectionsConfigName,
              secondaryKey: 'collection',
            ),
          ) ??
          fallback,
      typeArguments: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _typeArgumentsConfigName,
              secondaryKey: 'type_argument',
            ),
          ) ??
          fallback,
      typeParameters: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _typeParametersConfigName,
              secondaryKey: 'type_parameter',
            ),
          ) ??
          fallback,
      recordLiterals: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _recordLiteralsConfigName,
              secondaryKey: 'record_literal',
            ),
          ) ??
          fallback,
      recordPatterns: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _recordPatternsConfigName,
              secondaryKey: 'record_pattern',
            ),
          ) ??
          fallback,
      objectPatterns: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _objectPatternsConfigName,
              secondaryKey: 'object_pattern',
            ),
          ) ??
          fallback,
      listPatterns: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _listPatternsConfigName,
              secondaryKey: 'list_pattern',
            ),
          ) ??
          fallback,
      mapPatterns: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _mapPatternsConfigName,
              secondaryKey: 'map_pattern',
            ),
          ) ??
          fallback,
      recordTypePositionalFields: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _recordTypePositionalFieldsConfigName,
              secondaryKey: 'record_type_positional_fields',
            ),
          ) ??
          fallback,
      recordTypeNamedFields: _parsePartConfig(
            _readConfig(
              breakOn,
              primaryKey: _recordTypeNamedFieldsConfigName,
              secondaryKey: 'record_type_named_fields',
            ),
          ) ??
          fallback,
    );
  }

  static _PartConfig? _parsePartConfig(Object? rawConfig) {
    if (rawConfig == null) {
      return null;
    }

    if (rawConfig is bool) {
      return rawConfig
          ? const _PartConfig.enabled()
          : const _PartConfig.disabled();
    }

    if (rawConfig is num) {
      return _PartConfig.enabled(rawConfig.toInt());
    }

    final value = rawConfig.toString().trim();
    if (value.isEmpty) {
      return null;
    }

    if (value.toLowerCase() == _disableValue) {
      return const _PartConfig.disabled();
    }

    final breakpoint = int.tryParse(value);
    if (breakpoint != null) {
      return _PartConfig.enabled(breakpoint);
    }

    return null;
  }

  static Object? _readConfig(
    Map<Object?, Object?> config, {
    required String primaryKey,
    String? secondaryKey,
  }) {
    if (config.containsKey(primaryKey)) {
      return config[primaryKey];
    }

    final oldPrimaryKey = primaryKey.replaceAll('-', '_');
    if (config.containsKey(oldPrimaryKey)) {
      return config[oldPrimaryKey];
    }

    if (secondaryKey == null) {
      return null;
    }

    if (config.containsKey(secondaryKey)) {
      return config[secondaryKey];
    }

    final oldSecondaryKey = secondaryKey.replaceAll('-', '_');
    if (config.containsKey(oldSecondaryKey)) {
      return config[oldSecondaryKey];
    }

    return null;
  }
}

class _PartConfig {
  final bool isEnabled;
  final int? breakOn;

  const _PartConfig.enabled([this.breakOn]) : isEnabled = true;

  const _PartConfig.disabled()
      : isEnabled = false,
        breakOn = null;

  Object? toJson() {
    if (!isEnabled) {
      return _ConfigParser._disableValue;
    }

    return breakOn;
  }
}

class _BreakOnConfig {
  final _PartConfig arguments;
  final _PartConfig parameters;
  final _PartConfig enumValues;
  final _PartConfig collections;
  final _PartConfig typeArguments;
  final _PartConfig typeParameters;
  final _PartConfig recordLiterals;
  final _PartConfig recordPatterns;
  final _PartConfig objectPatterns;
  final _PartConfig listPatterns;
  final _PartConfig mapPatterns;
  final _PartConfig recordTypePositionalFields;
  final _PartConfig recordTypeNamedFields;

  const _BreakOnConfig({
    required this.arguments,
    required this.parameters,
    required this.enumValues,
    required this.collections,
    required this.typeArguments,
    required this.typeParameters,
    required this.recordLiterals,
    required this.recordPatterns,
    required this.objectPatterns,
    required this.listPatterns,
    required this.mapPatterns,
    required this.recordTypePositionalFields,
    required this.recordTypeNamedFields,
  });

  const _BreakOnConfig.all(_PartConfig config)
      : arguments = config,
        parameters = config,
        enumValues = config,
        collections = config,
        typeArguments = config,
        typeParameters = config,
        recordLiterals = config,
        recordPatterns = config,
        objectPatterns = config,
        listPatterns = config,
        mapPatterns = config,
        recordTypePositionalFields = config,
        recordTypeNamedFields = config;

  Object? toJson() {
    final areAllEnabled = arguments.isEnabled &&
        parameters.isEnabled &&
        enumValues.isEnabled &&
        collections.isEnabled &&
        typeArguments.isEnabled &&
        typeParameters.isEnabled &&
        recordLiterals.isEnabled &&
        recordPatterns.isEnabled &&
        objectPatterns.isEnabled &&
        listPatterns.isEnabled &&
        mapPatterns.isEnabled &&
        recordTypePositionalFields.isEnabled &&
        recordTypeNamedFields.isEnabled;
    final allBreakOn = [
      arguments.breakOn,
      parameters.breakOn,
      enumValues.breakOn,
      collections.breakOn,
      typeArguments.breakOn,
      typeParameters.breakOn,
      recordLiterals.breakOn,
      recordPatterns.breakOn,
      objectPatterns.breakOn,
      listPatterns.breakOn,
      mapPatterns.breakOn,
      recordTypePositionalFields.breakOn,
      recordTypeNamedFields.breakOn,
    ];
    final hasSameBreakOn = allBreakOn.toSet().length == 1;

    if (areAllEnabled && hasSameBreakOn) {
      return arguments.breakOn;
    }

    return {
      _ConfigParser._argumentsConfigName: arguments.toJson(),
      _ConfigParser._parametersConfigName: parameters.toJson(),
      _ConfigParser._enumValuesConfigName: enumValues.toJson(),
      _ConfigParser._collectionsConfigName: collections.toJson(),
      _ConfigParser._typeArgumentsConfigName: typeArguments.toJson(),
      _ConfigParser._typeParametersConfigName: typeParameters.toJson(),
      _ConfigParser._recordLiteralsConfigName: recordLiterals.toJson(),
      _ConfigParser._recordPatternsConfigName: recordPatterns.toJson(),
      _ConfigParser._objectPatternsConfigName: objectPatterns.toJson(),
      _ConfigParser._listPatternsConfigName: listPatterns.toJson(),
      _ConfigParser._mapPatternsConfigName: mapPatterns.toJson(),
      _ConfigParser._recordTypePositionalFieldsConfigName:
          recordTypePositionalFields.toJson(),
      _ConfigParser._recordTypeNamedFieldsConfigName:
          recordTypeNamedFields.toJson(),
    };
  }
}

part of 'prefer_trailing_comma_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final LineInfo _lineInfo;
  final _BreakOnConfig _breakOnConfig;

  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  _Visitor(this._lineInfo, this._breakOnConfig);

  @override
  void visitArgumentList(ArgumentList node) {
    super.visitArgumentList(node);

    _visitNodeList(
      node.arguments,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.arguments,
    );
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    super.visitFormalParameterList(node);

    _visitNodeList(
      node.parameters,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.parameters,
    );
  }

  @override
  void visitListLiteral(ListLiteral node) {
    super.visitListLiteral(node);

    _visitNodeList(
      node.elements,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.collections,
    );
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    super.visitSetOrMapLiteral(node);

    _visitNodeList(
      node.elements,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.collections,
    );
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    super.visitEnumDeclaration(node);

    _visitNodeList(
      node.constants,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.enumValues,
    );
  }

  @override
  void visitTypeArgumentList(TypeArgumentList node) {
    super.visitTypeArgumentList(node);

    _visitNodeList(
      node.arguments,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.typeArguments,
    );
  }

  @override
  void visitTypeParameterList(TypeParameterList node) {
    super.visitTypeParameterList(node);

    _visitNodeList(
      node.typeParameters,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.typeParameters,
    );
  }

  @override
  void visitRecordLiteral(RecordLiteral node) {
    super.visitRecordLiteral(node);

    _visitNodeList(
      node.fields,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.recordLiterals,
    );
  }

  @override
  void visitRecordPattern(RecordPattern node) {
    super.visitRecordPattern(node);

    _visitNodeList(
      node.fields,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.recordPatterns,
    );
  }

  @override
  void visitObjectPattern(ObjectPattern node) {
    super.visitObjectPattern(node);

    _visitNodeList(
      node.fields,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.objectPatterns,
    );
  }

  @override
  void visitListPattern(ListPattern node) {
    super.visitListPattern(node);

    _visitNodeList(
      node.elements,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.listPatterns,
    );
  }

  @override
  void visitMapPattern(MapPattern node) {
    super.visitMapPattern(node);

    _visitNodeList(
      node.elements,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.mapPatterns,
    );
  }

  @override
  void visitRecordTypeAnnotation(RecordTypeAnnotation node) {
    super.visitRecordTypeAnnotation(node);

    _visitNodeList(
      node.positionalFields,
      node.leftParenthesis,
      node.rightParenthesis,
      _breakOnConfig.recordTypePositionalFields,
    );
  }

  @override
  void visitRecordTypeAnnotationNamedFields(
    RecordTypeAnnotationNamedFields node,
  ) {
    super.visitRecordTypeAnnotationNamedFields(node);

    _visitNodeList(
      node.fields,
      node.leftBracket,
      node.rightBracket,
      _breakOnConfig.recordTypeNamedFields,
    );
  }

  void _visitNodeList(
    Iterable<AstNode> nodes,
    Token leftBracket,
    Token rightBracket,
    _PartConfig partConfig,
  ) {
    if (!partConfig.isEnabled || nodes.isEmpty) {
      return;
    }

    final last = nodes.last;

    if (last.endToken.next?.type != TokenType.COMMA &&
        (!_isLastItemMultiLine(last, leftBracket, rightBracket) &&
                _getLineNumber(leftBracket) != _getLineNumber(rightBracket) ||
            partConfig.breakOn != null &&
                nodes.length >= partConfig.breakOn!)) {
      _nodes.add(last);
    }
  }

  bool _isLastItemMultiLine(
    AstNode node,
    Token leftBracket,
    Token rightBracket,
  ) =>
      _getLineNumber(leftBracket) ==
          _lineInfo.getLocation(node.offset).lineNumber &&
      _getLineNumber(rightBracket) ==
          _lineInfo.getLocation(node.end).lineNumber;

  int _getLineNumber(SyntacticEntity entity) =>
      _lineInfo.getLocation(entity.offset).lineNumber;
}

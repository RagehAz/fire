import 'package:flutter/material.dart';

class QueryOrderBy {
  /// --------------------------------------------------------------------------
  const QueryOrderBy({
    @required this.fieldName,
    @required this.descending,
});
  /// --------------------------------------------------------------------------
  final String fieldName;
  final bool descending;
  /// --------------------------------------------------------------------------
}

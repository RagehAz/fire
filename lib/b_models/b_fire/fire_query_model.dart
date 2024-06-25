// part of super_fire;
// /// => TAMAM
// @immutable
// class FireQueryModel {
//   /// --------------------------------------------------------------------------
//   const FireQueryModel({
//     required this.coll,
//     this.doc,
//     this.subColl,
//     this.idFieldName ='id',
//     this.limit,
//     this.orderBy,
//     this.finders,
//     this.initialMaps,
//   });
//   /// --------------------------------------------------------------------------
//   final String coll;
//   final String? doc;
//   final String? subColl;
//   final int? limit;
//   final QueryOrderBy? orderBy;
//   final List<FireFinder>? finders;
//   final List<Map<String, dynamic>>? initialMaps;
//   final String idFieldName;
//   // -----------------------------------------------------------------------------
//
//   /// QueryParameter CREATOR
//
//   // --------------------
//   /// TESTED : WORKS PERFECT
//   FireQueryModel copyWith({
//     String? coll,
//     String? doc,
//     String? subColl,
//     String? idFieldName,
//     int? limit,
//     QueryOrderBy? orderBy,
//     List<FireFinder>? finders,
//     List<Map<String, dynamic>>? initialMaps,
//   }){
//     return FireQueryModel(
//       coll: coll ?? this.coll,
//       doc: doc ?? this.doc,
//       subColl: subColl ?? this.subColl,
//       idFieldName: idFieldName ?? this.idFieldName,
//       limit: limit ?? this.limit,
//       orderBy: orderBy ?? this.orderBy,
//       finders: finders ?? this.finders,
//       initialMaps: initialMaps ?? this.initialMaps,
//     );
//   }
//   // -----------------------------------------------------------------------------
//
//   /// EQUALITY
//
//   // --------------------
//   /// TESTED : WORKS PERFECT
//   static bool checkQueriesAreIdentical({
//     required FireQueryModel? model1,
//     required FireQueryModel? model2,
//   }){
//   bool _identical = false;
//
//   if (model1 == null && model2 == null){
//     _identical = true;
//   }
//
//   else if (model1 != null && model2 != null){
//
//     if (
//     model1.coll == model2.coll &&
//     model1.doc == model2.doc &&
//     model1.subColl == model2.subColl &&
//     model1.idFieldName == model2.idFieldName &&
//     model1.limit == model2.limit &&
//     model1.orderBy?.descending == model2.orderBy?.descending &&
//     model1.orderBy?.fieldName == model2.orderBy?.fieldName &&
//     FireFinder.checkFindersListsAreIdentical(model1.finders, model2.finders) == true &&
//     Mapper.checkMapsListsAreIdentical(maps1: model1.initialMaps, maps2: model2.initialMaps) == true
//     ){
//       _identical = true;
//     }
//
//   }
//
//   return _identical;
//   }
//   // -----------------------------------------------------------------------------
//
//   /// OVERRIDES
//
//   // --------------------
//   /*
//    @override
//    String toString() => 'MapModel(key: $key, value: ${value.toString()})';
//    */
//   // --------------------
//   @override
//   bool operator == (Object other){
//
//     if (identical(this, other)) {
//       return true;
//     }
//
//     bool _areIdentical = false;
//     if (other is FireQueryModel){
//       _areIdentical = checkQueriesAreIdentical(
//         model1: this,
//         model2: other,
//       );
//     }
//
//     return _areIdentical;
//   }
//   // --------------------
//   @override
//   int get hashCode =>
//       coll.hashCode^
//       doc.hashCode^
//       subColl.hashCode^
//       idFieldName.hashCode^
//       limit.hashCode^
//       orderBy.hashCode^
//       finders.hashCode^
//       initialMaps.hashCode;
//   // -----------------------------------------------------------------------------
// }

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      uid: json['uid'] as String,
      historyRef:
          json['history'] as List<DocumentReference<Map<String, dynamic>>>,
    );

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'history': instance.history,
    };

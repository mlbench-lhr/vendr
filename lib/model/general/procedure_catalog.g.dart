// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcedureCatalogModel _$ProcedureCatalogModelFromJson(
  Map<String, dynamic> json,
) => ProcedureCatalogModel(
  id: json['_id'] as String?,
  type: json['type'] as String?,
  procedure: json['procedure'] as String?,
  regions: (json['regions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  subZones: (json['sub_zones'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  techniquesBrands: (json['techniques_brands'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ProcedureCatalogModelToJson(
  ProcedureCatalogModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'type': instance.type,
  'procedure': instance.procedure,
  'regions': instance.regions,
  'sub_zones': instance.subZones,
  'techniques_brands': instance.techniquesBrands,
};

MedicalSpecialtyModel _$MedicalSpecialtyModelFromJson(
  Map<String, dynamic> json,
) => MedicalSpecialtyModel(
  name: json['name'] as String,
  id: json['_id'] as String?,
);

Map<String, dynamic> _$MedicalSpecialtyModelToJson(
  MedicalSpecialtyModel instance,
) => <String, dynamic>{'_id': instance.id, 'name': instance.name};

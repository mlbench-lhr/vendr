import 'package:json_annotation/json_annotation.dart';

part 'procedure_catalog.g.dart';

@JsonSerializable()
class ProcedureCatalogModel {
  ProcedureCatalogModel({
    this.id,
    this.type,
    this.procedure,
    this.regions,
    this.subZones,
    this.techniquesBrands,
  });

  factory ProcedureCatalogModel.fromJson(Map<String, dynamic> json) =>
      _$ProcedureCatalogModelFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String? type;
  final String? procedure;
  final List<String>? regions;

  @JsonKey(name: 'sub_zones')
  final List<String>? subZones;

  @JsonKey(name: 'techniques_brands')
  final List<String>? techniquesBrands;

  Map<String, dynamic> toJson() => _$ProcedureCatalogModelToJson(this);

  ProcedureCatalogModel copyWith({
    String? id,
    String? type,
    String? procedure,
    List<String>? regions,
    List<String>? subZones,
    List<String>? techniquesBrands,
  }) {
    return ProcedureCatalogModel(
      id: id ?? this.id,
      type: type ?? this.type,
      procedure: procedure ?? this.procedure,
      regions: regions ?? this.regions,
      subZones: subZones ?? this.subZones,
      techniquesBrands: techniquesBrands ?? this.techniquesBrands,
    );
  }
}

@JsonSerializable()
class MedicalSpecialtyModel {
  MedicalSpecialtyModel({
    required this.name,
    this.id,
  });

  factory MedicalSpecialtyModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalSpecialtyModelFromJson(json);

  @JsonKey(name: '_id')
  final String? id;
  final String name;

  Map<String, dynamic> toJson() => _$MedicalSpecialtyModelToJson(this);

  MedicalSpecialtyModel copyWith({
    String? id,
    String? name,
  }) {
    return MedicalSpecialtyModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

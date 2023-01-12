// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'dart:convert';

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
  Place({
    required this.meta,
    required this.documents,
  });

  Meta meta;
  List<Document> documents;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        meta: Meta.fromJson(json["meta"]),
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
      };
}

class Document {
  Document({
    required this.regionType,
    required this.code,
    required this.addressName,
    required this.region1DepthName,
    required this.region2DepthName,
    required this.region3DepthName,
    required this.region4DepthName,
    required this.x,
    required this.y,
  });

  String regionType;
  String code;
  String addressName;
  String region1DepthName;
  String region2DepthName;
  String region3DepthName;
  String region4DepthName;
  double x;
  double y;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        regionType: json["region_type"],
        code: json["code"],
        addressName: json["address_name"],
        region1DepthName: json["region_1depth_name"],
        region2DepthName: json["region_2depth_name"],
        region3DepthName: json["region_3depth_name"],
        region4DepthName: json["region_4depth_name"],
        x: json["x"].toDouble(),
        y: json["y"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "region_type": regionType,
        "code": code,
        "address_name": addressName,
        "region_1depth_name": region1DepthName,
        "region_2depth_name": region2DepthName,
        "region_3depth_name": region3DepthName,
        "region_4depth_name": region4DepthName,
        "x": x,
        "y": y,
      };
}

class Meta {
  Meta({
    required this.totalCount,
  });

  int totalCount;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
      };
}

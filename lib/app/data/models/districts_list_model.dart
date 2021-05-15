// To parse this JSON data, do
//
//     final districtList = districtListFromMap(jsonString);

import 'dart:convert';

class DistrictList {
  DistrictList({
    this.districts,
    this.ttl,
  });

  final List<District> districts;
  final int ttl;

  factory DistrictList.fromJson(String str) =>
      DistrictList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistrictList.fromMap(Map<String, dynamic> json) => DistrictList(
        districts: json["districts"] == null
            ? null
            : List<District>.from(
                json["districts"].map((x) => District.fromMap(x))),
        ttl: json["ttl"] == null ? null : json["ttl"],
      );

  Map<String, dynamic> toMap() => {
        "districts": districts == null
            ? null
            : List<dynamic>.from(districts.map((x) => x.toMap())),
        "ttl": ttl == null ? null : ttl,
      };
}

class District {
  District({
    this.districtId,
    this.districtName,
  });

  final int districtId;
  final String districtName;

  factory District.fromJson(String str) => District.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory District.fromMap(Map<String, dynamic> json) => District(
        districtId: json["district_id"] == null ? null : json["district_id"],
        districtName:
            json["district_name"] == null ? null : json["district_name"],
      );

  Map<String, dynamic> toMap() => {
        "district_id": districtId == null ? null : districtId,
        "district_name": districtName == null ? null : districtName,
      };
}

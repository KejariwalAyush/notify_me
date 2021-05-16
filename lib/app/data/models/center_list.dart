// To parse this JSON data, do
//
//     final centerList = centerListFromMap(jsonString);

import 'dart:convert';

class CenterList {
  CenterList({
    this.centers,
  });

  final List<CenterDetails> centers;

  factory CenterList.fromJson(String str) =>
      CenterList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CenterList.fromMap(Map<String, dynamic> json) => CenterList(
        centers: json["centers"] == null
            ? null
            : List<CenterDetails>.from(
                json["centers"].map((x) => CenterDetails.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "centers": centers == null
            ? null
            : List<dynamic>.from(centers.map((x) => x.toMap())),
      };
}

class CenterDetails {
  CenterDetails({
    this.centerId,
    this.name,
    this.address,
    this.stateName,
    this.districtName,
    this.blockName,
    this.pincode,
    this.lat,
    this.long,
    this.from,
    this.to,
    this.feeType,
    this.sessions,
  });

  final int centerId;
  final String name;
  final String address;
  final String stateName;
  final String districtName;
  final String blockName;
  final int pincode;
  final int lat;
  final int long;
  final String from;
  final String to;
  final String feeType;
  final List<Session> sessions;

  factory CenterDetails.fromJson(String str) =>
      CenterDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CenterDetails.fromMap(Map<String, dynamic> json) => CenterDetails(
        centerId: json["center_id"] == null ? null : json["center_id"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
        stateName: json["state_name"] == null ? null : json["state_name"],
        districtName:
            json["district_name"] == null ? null : json["district_name"],
        blockName: json["block_name"] == null ? null : json["block_name"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        feeType: json["fee_type"] == null ? null : json["fee_type"],
        sessions: json["sessions"] == null
            ? null
            : List<Session>.from(
                json["sessions"].map((x) => Session.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "center_id": centerId == null ? null : centerId,
        "name": name == null ? null : name,
        "address": address == null ? null : address,
        "state_name": stateName == null ? null : stateName,
        "district_name": districtName == null ? null : districtName,
        "block_name": blockName == null ? null : blockName,
        "pincode": pincode == null ? null : pincode,
        "lat": lat == null ? null : lat,
        "long": long == null ? null : long,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "fee_type": feeType == null ? null : feeType,
        "sessions": sessions == null
            ? null
            : List<dynamic>.from(sessions.map((x) => x.toMap())),
      };
}

class Session {
  Session({
    this.sessionId,
    this.date,
    this.availableCapacity,
    this.minAgeLimit,
    this.vaccine,
    this.slots,
    this.availableCapacityDose1,
    this.availableCapacityDose2,
  });

  final String sessionId;
  final String date;
  final int availableCapacity;
  final int minAgeLimit;
  final String vaccine;
  final List<Slot> slots;
  final int availableCapacityDose1;
  final int availableCapacityDose2;

  factory Session.fromJson(String str) => Session.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Session.fromMap(Map<String, dynamic> json) => Session(
        sessionId: json["session_id"] == null ? null : json["session_id"],
        date: json["date"] == null ? null : json["date"],
        availableCapacity: json["available_capacity"] == null
            ? null
            : json["available_capacity"],
        minAgeLimit:
            json["min_age_limit"] == null ? null : json["min_age_limit"],
        vaccine: json["vaccine"] == null ? null : json["vaccine"],
        slots: json["slots"] == null
            ? null
            : List<Slot>.from(json["slots"].map((x) => slotValues.map[x])),
        availableCapacityDose1: json["available_capacity_dose1"] == null
            ? null
            : json["available_capacity_dose1"],
        availableCapacityDose2: json["available_capacity_dose2"] == null
            ? null
            : json["available_capacity_dose2"],
      );

  Map<String, dynamic> toMap() => {
        "session_id": sessionId == null ? null : sessionId,
        "date": date == null ? null : date,
        "available_capacity":
            availableCapacity == null ? null : availableCapacity,
        "min_age_limit": minAgeLimit == null ? null : minAgeLimit,
        "vaccine": vaccine == null ? null : vaccine,
        "slots": slots == null
            ? null
            : List<dynamic>.from(slots.map((x) => slotValues.reverse[x])),
        "available_capacity_dose1":
            availableCapacityDose1 == null ? null : availableCapacityDose1,
        "available_capacity_dose2":
            availableCapacityDose2 == null ? null : availableCapacityDose2,
      };
}

enum Slot {
  THE_0800_AM_0900_AM,
  THE_0900_AM_1000_AM,
  THE_1000_AM_1100_AM,
  THE_1100_AM_0100_PM
}

final slotValues = EnumValues({
  "08:00AM-09:00AM": Slot.THE_0800_AM_0900_AM,
  "09:00AM-10:00AM": Slot.THE_0900_AM_1000_AM,
  "10:00AM-11:00AM": Slot.THE_1000_AM_1100_AM,
  "11:00AM-01:00PM": Slot.THE_1100_AM_0100_PM
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

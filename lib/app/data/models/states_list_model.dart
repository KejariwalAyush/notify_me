// To parse this JSON data, do
//
//     final statesList = statesListFromMap(jsonString);

import 'dart:convert';

class StatesList {
  StatesList({
    this.states,
    this.ttl,
  });

  final List<State> states;
  final int ttl;

  factory StatesList.fromJson(String str) =>
      StatesList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatesList.fromMap(Map<String, dynamic> json) => StatesList(
        states: json["states"] == null
            ? null
            : List<State>.from(json["states"].map((x) => State.fromMap(x))),
        ttl: json["ttl"] == null ? null : json["ttl"],
      );

  Map<String, dynamic> toMap() => {
        "states": states == null
            ? null
            : List<dynamic>.from(states.map((x) => x.toMap())),
        "ttl": ttl == null ? null : ttl,
      };
}

class State {
  State({
    this.stateId,
    this.stateName,
  });

  final int stateId;
  final String stateName;

  factory State.fromJson(String str) => State.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory State.fromMap(Map<String, dynamic> json) => State(
        stateId: json["state_id"] == null ? null : json["state_id"],
        stateName: json["state_name"] == null ? null : json["state_name"],
      );

  Map<String, dynamic> toMap() => {
        "state_id": stateId == null ? null : stateId,
        "state_name": stateName == null ? null : stateName,
      };
}

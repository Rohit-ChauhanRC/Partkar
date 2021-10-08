class PoliciesResponseModal {
  final bool status;
  final int code;
  final String message;
  final PoliciesModal data;

  PoliciesResponseModal.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'],
        data = PoliciesModal.fromJSON(parsedJSON['data']);
}

class PoliciesModal {
  final List<PolicyModal> policies;

  PoliciesModal.fromJSON(Map<String, dynamic> parsedJSON)
      : policies = (parsedJSON["policies"] as List)
            .map((c) => PolicyModal.fromJSON(c))
            .toList();
}

class PolicyModal {
  int id;
  String type;
  String description;

  PolicyModal.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON["id"],
        type = parsedJSON["type"],
        description = parsedJSON["description"];
}

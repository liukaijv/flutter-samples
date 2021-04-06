class Region {
  String code;
  String name;
  List<Region> children;

  Region({this.code, this.name, this.children});

  Region.fromJson(dynamic json) {
    code = json["code"];
    name = json["name"];
    if (json["children"] != null) {
      children = [];
      json["children"].forEach((v) {
        children.add(Region.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["name"] = name;
    if (children != null) {
      map["children"] = children.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

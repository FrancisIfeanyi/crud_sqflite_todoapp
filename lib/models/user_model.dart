class User {
  int? iD;
  String? firstName;
  String? lastName;
  String? gender;
  var age;
  int? status;

  User(
      {this.firstName,
      this.lastName,
      this.gender,
      required this.age,
      this.status});

  User.withId(
      {this.iD,
      this.firstName,
      this.lastName,
      this.gender,
      required this.age,
      this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    if (iD != null) {
      map['id'] = iD;
    }

    map['firstname'] = firstName;
    map['lastname'] = lastName;
    map['gender'] = gender;
    map['age'] = age;
    map['status'] = status;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.withId(
        iD: map['id'],
        firstName: map['firstname'],
        lastName: map['lastname'],
        gender: map['gender'],
        age: map['age'],
        status: map['status']);
  }
}

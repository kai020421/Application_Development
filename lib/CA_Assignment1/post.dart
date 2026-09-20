// PART A
class Address { // profile ke liye jo click ho kar aaye
  final String street;
  final String suite;
  final String city;

  const Address({ 
    required this.street,
    required this.suite,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address( // json decode kafrke adress banado
        street: json['street'] ?? '',
        suite: json['suite'] ?? '',
        city: json['city'] ?? '',
      );

  String get fullAddress => '$street, $suite, $city'; 
}

class Company { // company ke liye jo click ho kar aaye
  final String name;

  const Company({required this.name}); 

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] ?? '',
      );
}

class User { // user model se jo data molay api se
  final int id;
  final String name;
  final String email;
  final String phone;
  final Address address;
  final Company company;
  bool isFavorite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.company,
    this.isFavorite = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User( //json decode phir user detail
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        address: Address.fromJson(json['address'] ?? {}),
        company: Company.fromJson(json['company'] ?? {}),
      );

  String get initials { // user ke initials ko return kare
    List<String> names = name.trim().split(' '); //name split karke list mains store
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase(); //case sentive name first letter of first and last name
    }
    return name.isNotEmpty ? name[0].toUpperCase() : ''; // first letter ko upper case
  }
}
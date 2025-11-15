/*
[
  {
    "id": 1304279,
    "name": "Turmöl Quick",
    "location": {
      "address": "Windbüchelgasse 2",
      "postalCode": "4812",
      "city": "Pinsdorf",
      "latitude": 47.9375214,
      "longitude": 13.7570008
    },
    "contact": {
      "mail": "marketing-box@orlen-austria.at"
    },
    "openingHours": [
      {
        "day": "MO",
        "label": "Montag",
        "order": 1,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "DI",
        "label": "Dienstag",
        "order": 2,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "MI",
        "label": "Mittwoch",
        "order": 3,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "DO",
        "label": "Donnerstag",
        "order": 4,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "FR",
        "label": "Freitag",
        "order": 5,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "SA",
        "label": "Samstag",
        "order": 6,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "SO",
        "label": "Sonntag",
        "order": 7,
        "from": "00:00",
        "to": "24:00"
      },
      {
        "day": "FE",
        "label": "Feiertag",
        "order": 8,
        "from": "00:00",
        "to": "24:00"
      }
    ],
    "offerInformation": {
      "service": false,
      "selfService": false,
      "unattended": true
    },
    "paymentMethods": {
      "cash": true,
      "debitCard": true,
      "creditCard": true
    },
    "paymentArrangements": {
      "cooperative": false,
      "clubCard": false
    },
    "position": 1,
    "open": true,
    "distance": 0.44947241904777707,
    "prices": [
      {
        "fuelType": "DIE",
        "amount": 1.519,
        "label": "Diesel"
      }
    ]
  }
]
*/ 
class EControlModel {
  int id;
  String name;
  Location location;
  Contact contact;
  List<OpeningHour> openingHours;
  OfferInformation offerInformation;
  PaymentMethods paymentMethods;
  PaymentArrangements paymentArrangements;
  int position;
  bool open;
  double distance;
  List<Price> prices;

  EControlModel({
    required this.id,
    required this.name,
    required this.location,
    required this.contact,
    required this.openingHours,
    required this.offerInformation,
    required this.paymentMethods,
    required this.paymentArrangements,
    required this.position,
    required this.open,
    required this.distance,
    required this.prices,
  });

  factory EControlModel.fromMap(Map<String, dynamic> map) {
    return EControlModel(
      id: map['id'],
      name: map['name'],
      location: Location.fromMap(map['location']),
      contact: Contact.fromMap(map['contact']),
      openingHours: List<OpeningHour>.from(
          map['openingHours']?.map((x) => OpeningHour.fromMap(x))),
      offerInformation:
          OfferInformation.fromMap(map['offerInformation']),
      paymentMethods: PaymentMethods.fromMap(map['paymentMethods']),
      paymentArrangements:
          PaymentArrangements.fromMap(map['paymentArrangements']),
      position: map['position'],
      open: map['open'],
      distance: map['distance'].toDouble(),
      prices:
          List<Price>.from(map['prices']?.map((x) => Price.fromMap(x))),
    );
  }
}

class Price {
  String fuelType;
  double amount;
  String label;

  Price({
    required this.fuelType,
    required this.amount,
    required this.label,
  });

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      fuelType: map['fuelType'],
      amount: map['amount'].toDouble(),
      label: map['label'],
    );
  }
}

class PaymentArrangements {
  bool cooperative;
  bool clubCard;

  PaymentArrangements({
    required this.cooperative,
    required this.clubCard,
  });

  factory PaymentArrangements.fromMap(Map<String, dynamic> map) {
    return PaymentArrangements(
      cooperative: map['cooperative'],
      clubCard: map['clubCard'],
    );
  }
}

class PaymentMethods {
  bool cash;
  bool debitCard;
  bool creditCard;

  PaymentMethods({
    required this.cash,
    required this.debitCard,
    required this.creditCard,
  });

  factory PaymentMethods.fromMap(Map<String, dynamic> map) {
    return PaymentMethods(
      cash: map['cash'],
      debitCard: map['debitCard'],
      creditCard: map['creditCard'],
    );
  }
}

class OfferInformation {
  bool service;
  bool selfService;
  bool unattended;

  OfferInformation({
    required this.service,
    required this.selfService,
    required this.unattended,
  });

  factory OfferInformation.fromMap(Map<String, dynamic> map) {
    return OfferInformation(
      service: map['service'],
      selfService: map['selfService'],
      unattended: map['unattended'],
    );
  }
}

class OpeningHour {
  String day;
  String label;
  int order;
  String from;
  String to;

  OpeningHour({
    required this.day,
    required this.label,
    required this.order,
    required this.from,
    required this.to,
  });

  factory OpeningHour.fromMap(Map<String, dynamic> map) {
    return OpeningHour(
      day: map['day'],
      label: map['label'],
      order: map['order'],
      from: map['from'],
      to: map['to'],
    );
  }
}

class Contact {
  String mail;

  Contact({required this.mail});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      mail: map['mail']??'noMail',
    );
  }
}

class   Location {
  String address;
  String postalCode;
  String city;
  double latitude;
  double longitude;

  Location({
    required this.address,
    required this.postalCode,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'],
      postalCode: map['postalCode'],
      city: map['city'],
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
    );
  }
}
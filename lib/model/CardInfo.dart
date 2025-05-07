class CardInfo {
  String? cardType;
  String? cardNumber;
  String? cardholderName;
  String? expiryDate;
  String? cvv;
  late bool hasRFID;

  CardInfo({
    this.cardType,
    this.cardNumber,
    this.cardholderName,
    this.expiryDate,
    this.cvv,
    this.hasRFID = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardType': cardType,
      'cardNumber': cardNumber,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
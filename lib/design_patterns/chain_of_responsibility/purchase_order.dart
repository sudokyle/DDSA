enum Discount {
  bronze, // if purchase >= $50: $5 off
  silver, // if purchase >= $75: $10 off + bronze
  gold, // 10% off any purchase
  platinum, // apply gold to original then silver
  holiday, // if purchase >= $25: 5% off
  freeShip, // Free shipping
  unscVeteran, // freeship + gold
}

const Map<Discount, String> discountCodes = {
  Discount.bronze : 'BRONZE',
  Discount.silver : 'SILVER',
  Discount.gold : 'GOLD',
  Discount.platinum : 'PLATINUM',
  Discount.holiday : 'HOLIDAY',
  Discount.freeShip : 'FREESHIP',
  Discount.unscVeteran : 'UNSCVETERAN',
};

/// The Request Object
class PurchaseOrder {
  final double amount;
  final double shipping;
  final Discount appliedDiscount;
  PurchaseOrder(this.amount, this.shipping, this.appliedDiscount);

  @override
  String toString() {
    return 'PurchaseOrder{ amount: \$$amount, shipping: \$$shipping, appliedDiscount: ${discountCodes[appliedDiscount]} }';
  }

  @override
  bool operator ==(o) => o is PurchaseOrder &&
      amount == o.amount &&
      shipping == o.shipping &&
      appliedDiscount == o.appliedDiscount;

  @override
  int get hashCode => amount.hashCode^shipping.hashCode^appliedDiscount.hashCode;
}
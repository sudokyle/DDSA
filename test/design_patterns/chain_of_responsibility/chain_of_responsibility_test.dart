import 'package:DDSA/design_patterns/chain_of_responsibility/discount_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/free_shipping_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/percent_off_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';
import 'package:test/test.dart';

PurchaseHandler bronzeHandler = DiscountHandler(minimumAmount: 50, discount: 5);
PurchaseHandler silverHandler = DiscountHandler(minimumAmount: 75, discount: 10, nextHandler: bronzeHandler);
PurchaseHandler goldHandler = PercentOffHandler(minimumAmount: 0, percentOff: 10);
PurchaseHandler platinumHandler = goldHandler.copyOf()..updatePurchaseHandler(silverHandler);
PurchaseHandler holidayHandler = PercentOffHandler(minimumAmount: 25, percentOff: 5);
PurchaseHandler freeShipHandler = FreeShippingHandler();
PurchaseHandler unscVeteranHandler = goldHandler.copyOf()..updatePurchaseHandler(freeShipHandler.copyOf());

Map<Discount, PurchaseHandler> getDiscountHandler = {
  Discount.bronze: bronzeHandler,
  Discount.silver:  silverHandler,
  Discount.gold:  goldHandler,
  Discount.platinum:  platinumHandler,
  Discount.holiday:  holidayHandler,
  Discount.unscVeteran:  unscVeteranHandler,
  Discount.freeShip:  freeShipHandler,
};
void main() {

  final purchaseOrders = <PurchaseOrder>[
    PurchaseOrder(45, 10, Discount.bronze), // Expected: 45, 10, bronze
    PurchaseOrder(50, 10, Discount.bronze), // Expected: 45, 10, bronze
    PurchaseOrder(45, 10, Discount.silver), // Expected: 45, 10, silver
    PurchaseOrder(80, 10, Discount.silver), // Expected: 65, 10, silver
    PurchaseOrder(45, 10, Discount.gold), // Expected: 40.5, 10, gold
    PurchaseOrder(10, 10, Discount.platinum), // Expected: 9, 10, platinum
    PurchaseOrder(100, 10, Discount.platinum), // Expected: 75, 10, platinum
    PurchaseOrder(10, 10, Discount.holiday), // Expected: 10, 10, holiday
    PurchaseOrder(25, 10, Discount.holiday), // Expected: 23.75, 10, holiday
    PurchaseOrder(25, 10, Discount.freeShip), // Expected: 25, 0, holiday
    PurchaseOrder(25, 10, Discount.unscVeteran), // Expected: 22.5, 0, holiday
  ];

  final expectedPurchaseOrders = <PurchaseOrder>[
    PurchaseOrder(45, 10, Discount.bronze), // Expected: 45, 10, bronze
    PurchaseOrder(45, 10, Discount.bronze), // Expected: 45, 10, bronze
    PurchaseOrder(45, 10, Discount.silver), // Expected: 45, 10, silver
    PurchaseOrder(65, 10, Discount.silver), // Expected: 65, 10, silver
    PurchaseOrder(40.5, 10, Discount.gold), // Expected: 40.5, 10, gold
    PurchaseOrder(9, 10, Discount.platinum), // Expected: 9, 10, platinum
    PurchaseOrder(75, 10, Discount.platinum), // Expected: 75, 10, platinum
    PurchaseOrder(10, 10, Discount.holiday), // Expected: 10, 10, holiday
    PurchaseOrder(23.75, 10, Discount.holiday), // Expected: 23.75, 10, holiday
    PurchaseOrder(25, 0, Discount.freeShip), // Expected: 25, 0, holiday
    PurchaseOrder(22.5, 0, Discount.unscVeteran), // Expected: 22.5, 0, holiday
  ];

  group('ChainOfResponsibility', () {
    test('All purchase chains properly calculate values', () {
      // Process Orders
      for (var i = 0; i < purchaseOrders.length; i++) {
        var purchaseOrder = purchaseOrders[i];
        var updatedPurchaseOrder = purchaseOrder;
        final discountHandler = getDiscountHandler[purchaseOrder.appliedDiscount];
        if (discountHandler != null) {
          updatedPurchaseOrder = discountHandler.handleDiscount(purchaseOrder);
        }
        expect(updatedPurchaseOrder, equals(expectedPurchaseOrders[i]));
      }
    });
  });
}
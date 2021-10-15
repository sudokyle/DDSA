import 'package:DDSA/design_patterns/chain_of_responsibility/discount_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/free_shipping_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/percent_off_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';

import 'package:mockito/annotations.dart';
import 'chain_of_responsibility_test.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

PurchaseHandler bronzeHandler = DiscountHandler(minimumAmount: 50, discount: 5);
PurchaseHandler silverHandler = DiscountHandler(
    minimumAmount: 75, discount: 10, nextHandler: bronzeHandler);
PurchaseHandler goldHandler =
    PercentOffHandler(minimumAmount: 0, percentOff: 10);
PurchaseHandler platinumHandler = goldHandler.copyOf()
  ..updatePurchaseHandler(silverHandler);
PurchaseHandler holidayHandler =
    PercentOffHandler(minimumAmount: 25, percentOff: 5);
PurchaseHandler freeShipHandler = FreeShippingHandler();
PurchaseHandler unscVeteranHandler = goldHandler.copyOf()
  ..updatePurchaseHandler(freeShipHandler.copyOf());

Map<Discount, PurchaseHandler> getDiscountHandler = {
  Discount.bronze: bronzeHandler,
  Discount.silver: silverHandler,
  Discount.gold: goldHandler,
  Discount.platinum: platinumHandler,
  Discount.holiday: holidayHandler,
  Discount.unscVeteran: unscVeteranHandler,
  Discount.freeShip: freeShipHandler,
};

@GenerateMocks([DiscountHandler, PercentOffHandler, FreeShippingHandler])
void main() {
  group('ChainOfResponsibility:', () {
    group('When there are multiple chains which use each other', () {
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
        PurchaseOrder(
            25, 10, Discount.unscVeteran), // Expected: 22.5, 0, holiday
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
        PurchaseOrder(
            23.75, 10, Discount.holiday), // Expected: 23.75, 10, holiday
        PurchaseOrder(25, 0, Discount.freeShip), // Expected: 25, 0, holiday
        PurchaseOrder(
            22.5, 0, Discount.unscVeteran), // Expected: 22.5, 0, holiday
      ];
      test('then all purchase chains properly calculate values', () {
        // Process Orders
        for (var i = 0; i < purchaseOrders.length; i++) {
          var purchaseOrder = purchaseOrders[i];
          var updatedPurchaseOrder = purchaseOrder;
          final discountHandler =
              getDiscountHandler[purchaseOrder.appliedDiscount];
          if (discountHandler != null) {
            updatedPurchaseOrder =
                discountHandler.handleDiscount(purchaseOrder);
          }
          expect(updatedPurchaseOrder, equals(expectedPurchaseOrders[i]));
        }
      });
    });

    group('When a chain has', () {
      final fakeOrder = PurchaseOrder(5, 5, Discount.gold);
      late DiscountHandler discountHandler;
      late PercentOffHandler percentOffHandler;
      late FreeShippingHandler freeShippingHandler;

      setUp(() {
        discountHandler = DiscountHandler(minimumAmount: 5, discount: 5);
        percentOffHandler = PercentOffHandler(minimumAmount: 5, percentOff: 5);
        freeShippingHandler = FreeShippingHandler();
      });

      group('no next handler', () {
        test('then only that handler of the request handles it', () {
          expect(discountHandler.handleDiscount(fakeOrder),
              equals(PurchaseOrder(0, 5, Discount.gold)));
          expect(percentOffHandler.handleDiscount(fakeOrder),
              equals(PurchaseOrder(4.75, 5, Discount.gold)));
          expect(freeShippingHandler.handleDiscount(fakeOrder),
              equals(PurchaseOrder(5, 0, Discount.gold)));
        });
      });

      group('a next handler', () {
        late MockDiscountHandler mockDiscountHandler;
        late MockPercentOffHandler mockPercentOffHandler;
        late MockFreeShippingHandler mockFreeShippingHandler;

        setUp(() {
          // Create varying depth mock handlers
          mockDiscountHandler = MockDiscountHandler();
          when(mockDiscountHandler.handleDiscount(any)).thenReturn(fakeOrder);
          mockPercentOffHandler = MockPercentOffHandler();
          when(mockPercentOffHandler.handleDiscount(any)).thenReturn(fakeOrder);
          mockFreeShippingHandler = MockFreeShippingHandler();
          when(mockFreeShippingHandler.handleDiscount(any))
              .thenReturn(fakeOrder);

          // Configure chains
          discountHandler.updatePurchaseHandler(mockDiscountHandler);
          percentOffHandler.updatePurchaseHandler(mockPercentOffHandler);
          freeShippingHandler.updatePurchaseHandler(mockFreeShippingHandler);
        });

        test('then the the next handler is invoked', () {
          discountHandler.handleDiscount(fakeOrder);
          percentOffHandler.handleDiscount(fakeOrder);
          freeShippingHandler.handleDiscount(fakeOrder);

          verifyInOrder([
            mockDiscountHandler.handleDiscount(any),
            mockPercentOffHandler.handleDiscount(any),
            mockFreeShippingHandler.handleDiscount(any),
          ]);
        });
      });
    });
  });
}

import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';

abstract class PurchaseHandler {
  PurchaseHandler? _nextPurchaseHandler;
  PurchaseHandler({PurchaseHandler? handler}) : _nextPurchaseHandler = handler;

  PurchaseOrder handleDiscount(PurchaseOrder order);

  PurchaseHandler? get nextPurchaseHandler => _nextPurchaseHandler;

  PurchaseHandler copyOf();

  void updatePurchaseHandler(PurchaseHandler? nextHandler) {
    _nextPurchaseHandler = nextHandler;
  }
}
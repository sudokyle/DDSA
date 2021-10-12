import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';
import 'package:optional/optional.dart';

abstract class PurchaseHandler {
  Optional<PurchaseHandler> _nextPurchaseHandler;
  PurchaseHandler({PurchaseHandler? handler}) : _nextPurchaseHandler = Optional.ofNullable(handler);

  PurchaseOrder handleDiscount(PurchaseOrder order);

  Optional<PurchaseHandler> get nextPurchaseHandler => _nextPurchaseHandler;

  PurchaseHandler copyOf();

  void updatePurchaseHandler(PurchaseHandler? nextHandler) {
    _nextPurchaseHandler = Optional.ofNullable(nextHandler);
  }
}
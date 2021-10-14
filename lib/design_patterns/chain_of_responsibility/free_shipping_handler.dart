import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';

class FreeShippingHandler extends PurchaseHandler {

  FreeShippingHandler({PurchaseHandler? nextHandler}) : super(handler: nextHandler);

  @override
  PurchaseOrder handleDiscount(PurchaseOrder order) {
    var updatedOrder = PurchaseOrder(order.amount, 0, order.appliedDiscount);

    final handler = nextPurchaseHandler;
    if (handler != null) {
      updatedOrder = handler.handleDiscount(updatedOrder);
    }

    return updatedOrder;
  }

  @override
  FreeShippingHandler copyOf() {
    final handlerCopy = FreeShippingHandler();
    final nextHandler = nextPurchaseHandler;
    if (nextHandler != null) {
      handlerCopy.updatePurchaseHandler(nextHandler.copyOf());
    }

    return handlerCopy;
  }
}
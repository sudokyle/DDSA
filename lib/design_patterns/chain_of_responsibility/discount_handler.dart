import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';

class DiscountHandler extends PurchaseHandler {
  final double minimumAmount;
  final double discount;

  DiscountHandler({
    required this.minimumAmount,
    required this.discount,
    PurchaseHandler? nextHandler,
  }) : super(handler: nextHandler);

  @override
  PurchaseOrder handleDiscount(PurchaseOrder order) {
    var updatedOrder = order;

    if (order.amount >= minimumAmount) {
      final newAmount = order.amount - discount;
      updatedOrder =
          PurchaseOrder(newAmount, order.shipping, order.appliedDiscount);
    }

    final nextHandler = nextPurchaseHandler;
    if (nextHandler != null) {
      updatedOrder = nextHandler.handleDiscount(updatedOrder);
    }

    return updatedOrder;
  }

  @override
  DiscountHandler copyOf() {
    final handlerCopy =
        DiscountHandler(minimumAmount: minimumAmount, discount: discount);

    final nextHandler = nextPurchaseHandler;
    if (nextHandler != null) {
      handlerCopy.updatePurchaseHandler(nextHandler.copyOf());
    }

    return handlerCopy;
  }
}

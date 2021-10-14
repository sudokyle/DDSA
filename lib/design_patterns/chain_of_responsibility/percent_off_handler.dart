import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_handler.dart';
import 'package:DDSA/design_patterns/chain_of_responsibility/purchase_order.dart';

class PercentOffHandler extends PurchaseHandler {
  final double minimumAmount;
  final double percentOff;

  PercentOffHandler({
    required this.minimumAmount,
    required this.percentOff,
    PurchaseHandler? nextHandler,
  }) : super(handler: nextHandler);

  @override
  PurchaseOrder handleDiscount(PurchaseOrder order) {
    var updatedOrder = order;

    if (order.amount >= minimumAmount) {
      final newAmount = order.amount - ( order.amount * (percentOff / 100));
      updatedOrder = PurchaseOrder(newAmount, order.shipping, order.appliedDiscount);
    }

    final nextHandler = nextPurchaseHandler;
    if (nextHandler  != null) {
      updatedOrder = nextHandler.handleDiscount(updatedOrder);
    }

    return updatedOrder;
  }

  @override
  PercentOffHandler copyOf() {
    final handlerCopy = PercentOffHandler(minimumAmount: minimumAmount, percentOff: percentOff);
    final nextHandler = nextPurchaseHandler;

    if (nextHandler != null) {
      handlerCopy.updatePurchaseHandler(nextHandler.copyOf());
    }

    return handlerCopy;
  }
}
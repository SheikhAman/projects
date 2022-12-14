import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/purchase_model.dart';
import '/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../models/date_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class OrderDetailsPage extends StatelessWidget {
  static const String routeName = '/order_details';
  ValueNotifier<DateTime> dateChangeNotifier = ValueNotifier(DateTime.now());

  OrderDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dateChangeNotifier.value = DateTime.now();
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    final provider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: provider.getAllOrdersByOrderId(order.orderId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final detailsList = List.generate(
                snapshot.data!.docs.length,
                (index) =>
                    CartModel.fromMap(snapshot.data!.docs[index].data()));
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Product Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: detailsList
                        .map((cartM) => ListTile(
                              title: Text(cartM.productName!),
                              trailing: Text(
                                  '${cartM.quantity}x$currencySymbol${cartM.salePrice}'),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${order.deliveryAddress.streetAddress}\n'
                  '${order.deliveryAddress.area}, ${order.deliveryAddress.city}\n'
                  '${order.deliveryAddress.zipCode}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Charge'),
                            Text('$currencySymbol${order.deliveryCharge}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount'),
                            Text('${order.discount}%'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('VAT'),
                            Text('${order.vat}%'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total',
                                style: Theme.of(context).textTheme.headline6),
                            Text('$currencySymbol${order.grandTotal}',
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to get data'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _showPurchaseHistory(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
              itemCount: provider.purchaseListOfSpecificProduct.length,
              itemBuilder: (context, index) {
                final purchase = provider.purchaseListOfSpecificProduct[index];
                return ListTile(
                  title: Text(getFormattedDateTime(
                      purchase.dateModel.timestamp.toDate(), 'dd/MM/yyyy')),
                  subtitle: Text('Quantity: ${purchase.quantity}'),
                  trailing: Text('$currencySymbol${purchase.price}'),
                );
              },
            ));
  }
}

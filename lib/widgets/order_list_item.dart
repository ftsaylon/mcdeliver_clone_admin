import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcdelivery_clone_admin/models/order.dart';
import 'package:mcdelivery_clone_admin/services/orders_service.dart';

class OrderListItem extends StatefulWidget {
  final Order order;

  const OrderListItem({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  var _expanded = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ordersService = OrdersService(order: widget.order);
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '\$${widget.order.amount}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy hh:mm')
                              .format(widget.order.dateCreated),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${widget.order.customerName}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                              color: (widget.order.isProcessed)
                                  ? Colors.green
                                  : Colors.grey[300],
                              onPressed: () async {
                                await ordersService.setOrderIsProcessed(
                                  !widget.order.isProcessed,
                                );
                              },
                              child: Text(
                                'Processed',
                                style: TextStyle(
                                  color: (widget.order.isProcessed)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: (widget.order.isBeingPrepared)
                                  ? Colors.green
                                  : Colors.grey[300],
                              onPressed: () async {
                                await ordersService.setOrderIsBeingPrepared(
                                  !widget.order.isBeingPrepared,
                                );
                              },
                              child: Text(
                                'Preparing',
                                style: TextStyle(
                                  color: (widget.order.isBeingPrepared)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: (widget.order.isOnTheWay)
                                  ? Colors.green
                                  : Colors.grey[300],
                              onPressed: () async {
                                await ordersService.setOrderIsOnTheWay(
                                  !widget.order.isOnTheWay,
                                );
                              },
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: (widget.order.isOnTheWay)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_expanded) _buildProductsList(deviceSize),
          ],
        ),
      ),
    );
  }

  Container _buildProductsList(Size deviceSize) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16,
        right: 16,
        left: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: deviceSize.width * 0.6,
            child: Text(
              '${widget.order.address}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Remarks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: deviceSize.width * 0.6,
            child: Text(
              '${widget.order.remarks}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Change For',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${widget.order.changeFor}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          ...widget.order.products
              .map(
                (product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${product.quantity}x \$${product.price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

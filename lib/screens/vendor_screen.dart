import 'package:flutter/material.dart';
import 'package:shop_admin/widgets/vendor/vendor_list.dart';
import 'package:shop_admin/widgets/vendor/vendor_widget.dart';

class VendorScreen extends StatelessWidget {
  static const String id = 'vendor';

  const VendorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            'Vendors',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
          Row(
            children: const [
              RowHeader(text: 'LOGO', flex: 1),
              RowHeader(text: 'BUSINESS NAME', flex: 3),
              RowHeader(text: 'CITY', flex: 2),
              RowHeader(text: 'STATE', flex: 2),
              RowHeader(text: 'ACTION', flex: 1),
              RowHeader(text: 'VIEW MORE', flex: 1),
            ],
          ),
          const VendorList(),
        ],
      ),
    );
  }
}
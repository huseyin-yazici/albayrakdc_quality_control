import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_defect_bloc/product_defect_bloc.dart';
import '../bloc/product_defect_bloc/product_defect_state.dart';

class ProductDefectDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDefectBloc, ProductDefectState>(
      builder: (context, state) {
        if (state is ProductDefectLoading) {
          return CircularProgressIndicator();
        } else if (state is ProductDefectLoaded) {
          return DropdownButton<String>(
            hint: Text('Select a defect'),
            items: state.defects.map((String defect) {
              return DropdownMenuItem<String>(
                value: defect,
                child: Text(defect),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Burada seçilen değeri kullanabilirsiniz
              print('Selected defect: $newValue');
            },
          );
        } else if (state is ProductDefectError) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }
}
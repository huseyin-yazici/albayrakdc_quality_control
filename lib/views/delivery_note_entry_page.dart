import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/delivery_note_bloc/delivery_note_bloc.dart';
import '../bloc/delivery_note_bloc/delivery_note_event.dart';
import '../bloc/delivery_note_bloc/delivery_note_state.dart';
import '../theme/app_theme.dart';

class DeliveryNoteEntryPage extends StatelessWidget {
  DeliveryNoteEntryPage({Key? key}) : super(key: key);

  final TextEditingController irsaliyeKodController = TextEditingController();
  final TextEditingController irsaliyeKgController = TextEditingController();
  final TextEditingController aracPlakasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeliveryNoteBloc()..add(LoadCompanies()),
      child: BlocBuilder<DeliveryNoteBloc, DeliveryNoteState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.8)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildCompanyDropdown(context, state),
                                SizedBox(height: 20),
                                _buildIrsaliyeNoField(state),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: irsaliyeKgController,
                                  labelText: 'İrsaliye Kg',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: aracPlakasiController,
                                  labelText: 'Araç Plakası',
                                  textCapitalization: TextCapitalization.characters,
                                ),
                                SizedBox(height: 30),
                                _buildElevatedButton(state, context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            'İrsaliye Giriş',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildCompanyDropdown(BuildContext context, DeliveryNoteState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: state.selectedCompany?['name'],
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Firma Seçin',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: state.companies.map((company) {
          return DropdownMenuItem(
            value: company['name'],
            child: Text(company['name']!),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<DeliveryNoteBloc>().add(SelectCompany(value));
          }
        },
      ),
    );
  }

  Widget _buildIrsaliyeNoField(DeliveryNoteState state) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              state.selectedCompany?['prefix'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: _buildTextField(
            controller: irsaliyeKodController,
            labelText: 'Kod',
            keyboardType: TextInputType.number,
            maxLength: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: '',
        ),
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLength: maxLength,
      ),
    );
  }

  Widget _buildElevatedButton(DeliveryNoteState state, BuildContext context) {
    return ElevatedButton(
      onPressed: state.isLoading
          ? null
          : () {
        if (state.selectedCompany != null) {
          final prefix = state.selectedCompany!['prefix'] ?? '';
          final fullIrsaliyeNo = prefix + irsaliyeKodController.text;
          context.read<DeliveryNoteBloc>().add(SubmitDeliveryNote(
            firma: state.selectedCompany!['name']!,
            irsaliyeNo: fullIrsaliyeNo,
            irsaliyeKg: irsaliyeKgController.text,
            aracPlakasi: aracPlakasiController.text,
          ));
        }
      },
      child: state.isLoading
          ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Text('Kaydet'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
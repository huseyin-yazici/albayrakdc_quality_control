import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_management_bloc/data_management_bloc.dart';
import '../bloc/data_management_bloc/data_management_event.dart';
import '../bloc/data_management_bloc/data_management_state.dart';
import '../bloc/google_sheets_bloc/google_sheets_bloc.dart';
import '../bloc/google_sheets_bloc/google_sheets_event.dart';
import '../bloc/google_sheets_bloc/google_sheets_state.dart';
import '../bloc/image_processing_bloc/image_processing_bloc.dart';
import '../bloc/image_processing_bloc/image_processing_event.dart';
import '../bloc/image_processing_bloc/image_processing_state.dart';
import '../bloc/product_defect_bloc/product_defect_bloc.dart';
import '../bloc/product_defect_bloc/product_defect_state.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfields.dart';
import '../theme/app_theme.dart';

class TextRecognitionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  child: _buildBody(context),
                ),
              ),
            ],
          ),
        ),
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
            'Filmaşin Kabul Kontrol',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<GoogleSheetsBloc, GoogleSheetsState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: state.isClearingSheets
                    ? null
                    : () {
                  context
                      .read<GoogleSheetsBloc>()
                      .add(ClearGoogleSheetsRange());
                  context
                      .read<DataManagementBloc>()
                      .add(ResetSelectedNumberToOne()); // Yeni event'i tetikleyin
                },
                child: state.isClearingSheets
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : Icon(Icons.delete_outline_sharp, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<GoogleSheetsBloc, GoogleSheetsState>(
        listenWhen: (previous, current) =>
        previous.isSuccess != current.isSuccess ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.successMessage ?? 'Veri başarıyla yüklendi!'),
                  backgroundColor: Colors.green
              ),
            );
            context.read<DataManagementBloc>().add(IncrementSelectedNumber());
            context.read<ImageProcessingBloc>().add(ResetImageProcessingState());
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.error!), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocListener<ImageProcessingBloc, ImageProcessingState>(
          listener: (context, state) {
            if (state.isDataRecognized) {
              context
                  .read<DataManagementBloc>()
                  .add(UpdateExtractedData(state.extractedData));
              context.read<ImageProcessingBloc>().add(PrintRecognizedText());
            }
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdown(context),
                SizedBox(height: 20),
                _buildActionButtons(context),
                SizedBox(height: 30),
                _buildTextFields(),
                SizedBox(height: 20),
                _buildProductDefectDropdown(context),
                SizedBox(height: 20),
                _buildSaveButton(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildDropdown(BuildContext context) {
    return BlocBuilder<DataManagementBloc, DataManagementState>(
      builder: (context, state) {
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
          child: CustomDropdown(
            value: state.selectedNumber,
            onChanged: (int? newValue) {
              if (newValue != null) {
                context.read<DataManagementBloc>().add(UpdateSelectedNumber(newValue));
                // Ürün hatasını sıfırla
                context.read<DataManagementBloc>().add(UpdateSelectedDefect(ProductDefectLoaded.defaultDefect));
              }
            },
          ),
        );
      },
    );
  }
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomActionButton(
            icon: Icons.photo_library,
            onPressed: () => context
                .read<ImageProcessingBloc>()
                .add(RecognizeTextFromGallery()),
            label: 'Galeri',
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: CustomActionButton(
            icon: Icons.camera_alt,
            onPressed: () => context
                .read<ImageProcessingBloc>()
                .add(RecognizeTextFromCamera()),
            label: 'Kamera',
          ),
        ),
      ],
    );
  }

  Widget _buildProductDefectDropdown(BuildContext context) {
    return BlocBuilder<ProductDefectBloc, ProductDefectState>(
      builder: (context, productDefectState) {
        return BlocBuilder<DataManagementBloc, DataManagementState>(
          builder: (context, dataManagementState) {
            if (productDefectState is ProductDefectLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (productDefectState is ProductDefectLoaded) {
              List<String> allDefects = [ProductDefectLoaded.defaultDefect];
              allDefects.addAll(productDefectState.defects.where((defect) => defect != ProductDefectLoaded.defaultDefect));

              String currentValue = allDefects.contains(dataManagementState.selectedDefect)
                  ? dataManagementState.selectedDefect
                  : ProductDefectLoaded.defaultDefect;

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
                  value: currentValue,
                  decoration: InputDecoration(
                    labelText: 'Ürün Hatası',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  items: allDefects.map((String defect) {
                    return DropdownMenuItem<String>(
                      value: defect,
                      child: Text(defect),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<DataManagementBloc>().add(UpdateSelectedDefect(newValue));
                    }
                  },
                ),
              );
            } else if (productDefectState is ProductDefectError) {
              return Text('Hata: ${productDefectState.message}', style: TextStyle(color: Colors.red));
            }
            return Container(); // ProductDefectInitial durumu için boş container
          },
        );
      },
    );
  }  Widget _buildTextFields() {
    return BlocBuilder<DataManagementBloc, DataManagementState>(
      builder: (context, state) {
        return Column(
          children: state.fieldValues.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
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
                child: CustomTextField(
                  label: entry.key,
                  value: entry.value,
                  onChanged: (value) {
                    context
                        .read<DataManagementBloc>()
                        .add(UpdateTextFieldValue(entry.key, value));
                  },
                  keyboardType: entry.key == 'KALITE'
                      ? TextInputType.text
                      : TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<GoogleSheetsBloc, GoogleSheetsState>(
      builder: (context, sheetsState) {
        return BlocBuilder<DataManagementBloc, DataManagementState>(
          builder: (context, dataState) {
            bool isButtonEnabled = !sheetsState.isLoading && !sheetsState.isUploading;

            return ElevatedButton(
              onPressed: isButtonEnabled
                  ? () => _uploadData(context)  // Burayı güncelledik
                  : null,
              child: sheetsState.isLoading || sheetsState.isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Google Sheets\'e Kaydet'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: isButtonEnabled ? null : Colors.grey,
              ),
            );
          },
        );
      },
    );
  }

  void _uploadData(BuildContext context) {
    final data = context.read<DataManagementBloc>().state.fieldValues;
    final selectedNumber = context.read<DataManagementBloc>().state.selectedNumber;
    final selectedDefect = context.read<DataManagementBloc>().state.selectedDefect;

    context.read<GoogleSheetsBloc>().add(UploadToGoogleSheets(
      data: data,
      selectedNumber: selectedNumber,
      selectedDefect: selectedDefect,
    ));
  }
}
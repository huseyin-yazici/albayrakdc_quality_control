import 'package:albayrakdc_control/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/delivery_note_bloc/delivery_note_bloc.dart';
import 'bloc/image_processing_bloc/image_processing_bloc.dart';
import 'bloc/google_sheets_bloc/google_sheets_bloc.dart';
import 'bloc/data_management_bloc/data_management_bloc.dart';
import 'bloc/product_defect_bloc/product_defect_bloc.dart';
import 'bloc/product_defect_bloc/product_defect_event.dart';
import 'theme/app_theme.dart';
import 'g_sheets_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSheetsService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final googleSheetsService =
        GoogleSheetsService(); // Google Sheets servisinizi başlatın

    return MultiBlocProvider(
      providers: [
        BlocProvider<ImageProcessingBloc>(
            create: (context) => ImageProcessingBloc()),
        BlocProvider<GoogleSheetsBloc>(create: (context) => GoogleSheetsBloc()),
        BlocProvider<DataManagementBloc>(
            create: (context) => DataManagementBloc()),
        BlocProvider<ProductDefectBloc>(
          create: (context) =>
              ProductDefectBloc(googleSheetsService)..add(LoadProductDefects()),
        ),
        BlocProvider<DeliveryNoteBloc>(create: (context) => DeliveryNoteBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: HomePage(),
      ),
    );
  }
}

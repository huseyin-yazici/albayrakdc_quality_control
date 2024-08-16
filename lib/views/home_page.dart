import 'package:albayrakdc_control/views/text_recognition_page.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'delivery_note_entry_page.dart';

class HomePage extends StatelessWidget {
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
              _buildAppBar(),
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

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Text(
          'Albayrak DC Kontrol',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(
              context,
              'Filmaşin Kabul Kontrol',
              Icons.verified_user,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TextRecognitionScreen())),
            ),
            SizedBox(height: 30),
            _buildCard(
              context,
              'İrsaliye Giriş',
              Icons.receipt_long,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryNoteEntryPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.9,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Icon(icon, size: 60, color: AppTheme.primaryRed),
                SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Başlamak için dokunun',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

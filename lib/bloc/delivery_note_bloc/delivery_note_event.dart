abstract class DeliveryNoteEvent {}

class LoadCompanies extends DeliveryNoteEvent {}

class SelectCompany extends DeliveryNoteEvent {
  final String companyName;
  SelectCompany(this.companyName);
}
class SubmitDeliveryNote extends DeliveryNoteEvent {
  final String firma;
  final String irsaliyeNo;
  final String irsaliyeKg;
  final String aracPlakasi;

  SubmitDeliveryNote({
    required this.firma,
    required this.irsaliyeNo,
    required this.irsaliyeKg,
    required this.aracPlakasi,
  });
}
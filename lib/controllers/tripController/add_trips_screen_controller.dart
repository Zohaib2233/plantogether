
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTripScreenController extends GetxController{

  formatDate(String date){
    DateTime dateTime = DateTime.parse(date);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('E, MMM d y').format(dateTime);
    return formattedDate;
  }

}
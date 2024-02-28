

import 'package:flutter/cupertino.dart';
import 'package:machine_task/constants/api_urls.dart';
import 'package:machine_task/models/user_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


import '../models/image_model.dart';
import 'package:http/http.dart'as http;

class HomeScreenProvider with ChangeNotifier{

  ImageModel ? imageData;
  UserModel ? userData;
  bool isLoading = false;
  bool isUserLoading = false;

  Future<bool> getImage()async{
    try{

      isLoading = true;
      imageData = null;
      notifyListeners();
      http.Response response =await http.get(Uri.parse(ApiUrls.dogImageUrl));
      isLoading = false;
      notifyListeners();

      debugPrint('====== statusCode: ${response.statusCode}');
      if(response.statusCode!=200){
       return false;
      }
      var data = imageModelFromJson(response.body);

    if(data.status!='success'){
    return false;
    } else{
        imageData = data;
        notifyListeners();
        return true;
      }
    }catch(e){
      isLoading = false;
      notifyListeners();
      return false;
    }

  }

  Future<bool> getUser()async{
    try{

      isUserLoading = true;
      userData = null;
      notifyListeners();
      http.Response response =await http.get(Uri.parse(ApiUrls.profileDataUrl));
      isUserLoading = false;
      notifyListeners();
      debugPrint('====== statusCode::${response.statusCode}');
      if(response.statusCode!=200){
        return false;
      }

       else{
        var data = userModelFromJson(response.body);
        userData = data;
        debugPrint('====== user: ${userData?.results?[0].email}');
        notifyListeners();
        return true;
      }
    }catch(e){
      debugPrint('====== exception: ${e.toString()}');
      notifyListeners();
      return false;
    }

  }

  enableBluetooth()async{
     await FlutterBluePlus.turnOn();
  }



  int calculateDaysPassed(DateTime ? registrationDate) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference between current date and registration date
    Duration difference = currentDate.difference(registrationDate ?? currentDate);

    // Return the number of days passed
    return difference.inDays;
  }




}
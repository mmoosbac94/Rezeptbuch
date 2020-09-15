import 'package:flutter/cupertino.dart';

class AddRecipeUseCase extends ChangeNotifier {
  List<String> ingredientsList = [];

  void addIngredient(TextEditingController controller) {
    if (controller.text.isNotEmpty) ingredientsList.add(controller.text);
    controller.clear();
    notifyListeners();
  }

  void cancel(BuildContext context) {
    ingredientsList = [];
    Navigator.pop(context);
  }
}

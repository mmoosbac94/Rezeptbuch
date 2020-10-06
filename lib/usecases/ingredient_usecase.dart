import 'package:flutter/cupertino.dart';

class IngredientUseCase extends ChangeNotifier {
  List<String> ingredientsList = <String>[];

  void addIngredient(TextEditingController controller) {
    if (controller.text.isNotEmpty) ingredientsList.add(controller.text);
    controller.clear();
    notifyListeners();
  }

  void cancel(BuildContext context) {
    Navigator.pop(context);
  }
}

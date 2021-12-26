import '../Models/Instruction.dart';
import '../Models/Recipe.dart';
import '../Models/Section.dart';

void updateRecipeHelper(Recipe pointer, Recipe newRecipe) {
  // takes in a pointer to a reference in memory that holds a recipe
  // updates the values of said recipe with the values of a new recipe
  // has to be done since arguments cant be passed back through ios swipe back
  pointer.authorId = newRecipe.authorId;
  pointer.favorite = newRecipe.favorite;
  pointer.instructions = newRecipe.instructions
      .map((e) => Instruction.fromJSON(e.toJson()))
      .toList();
  pointer.sections =
      newRecipe.sections.map((e) => Section.fromJSON(e.toJson())).toList();
  pointer.photoUrl = newRecipe.photoUrl;
  pointer.serves = newRecipe.serves;
  pointer.tags = {...newRecipe.tags};
  pointer.title = newRecipe.title;
  pointer.uid = newRecipe.uid;
}

package com.saimirgasa.services;

import java.util.Set;

import com.saimirgasa.commands.RecipeCommand;
import com.saimirgasa.domain.Recipe;

public interface RecipeService {

    Set<Recipe> getRecipes();

    Recipe findById(Long id);

    RecipeCommand saveRecipeCommand(RecipeCommand command);
}

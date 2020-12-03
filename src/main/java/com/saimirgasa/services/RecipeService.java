package com.saimirgasa.services;

import java.util.Set;

import com.saimirgasa.domain.Recipe;

public interface RecipeService {

    Set<Recipe> getRecipes();

    Recipe findById(Long id);
}

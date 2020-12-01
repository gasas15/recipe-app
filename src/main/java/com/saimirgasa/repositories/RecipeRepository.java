package com.saimirgasa.repositories;

import org.springframework.data.repository.CrudRepository;

import com.saimirgasa.domain.Recipe;

public interface RecipeRepository extends CrudRepository<Recipe, Long> {
}

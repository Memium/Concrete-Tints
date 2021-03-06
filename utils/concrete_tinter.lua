local ConcreteTinter = {}

-- Create a item for a tinted concrete
function ConcreteTinter.MakeItem(concrete_item, tinted_tile)
    local tinted_item = table.deepcopy(concrete_item)

    tinted_item.name = tinted_tile.name
    tinted_item.place_as_tile.result = tinted_tile.name
    tinted_item.icons = {{
        icon = concrete_item.icon,
        icon_mipmaps = concrete_item.icon_mipmaps or 4,
        icon_size = concrete_item.icon_size or 64,
        tint = tinted_tile.tint
    }}
    tinted_item.localised_name = tinted_tile.localised_name

    return tinted_item
end

-- Create a recipe for a tinted concrete
function ConcreteTinter.MakeRecipe(concrete_recipe, tinted_tile)
    local recipe = table.deepcopy(concrete_recipe)

    recipe.name = tinted_tile.name
    recipe.result = tinted_tile.name
    recipe.ingredients = {{concrete_recipe.name, 10}}

    return recipe
end

-- Tint a concrete if the tile exist
function ConcreteTinter.Tint(concrete_type, color)
    -- Get the tinted tile
    local tinted_tile = data.raw['tile'][string.format("%s-%s", color, concrete_type)]

    -- If the tile does not exist just pass
    if (tinted_tile == nil) then return end

    -- Change tiles to be minable
    --tinted_tile.minable.result = name

    -- Setting up item
    local tinted_item = ConcreteTinter.MakeItem(
        data.raw["item"][concrete_type],
        tinted_tile
    )
    data.raw["item"][tinted_tile.name] = tinted_item

    -- Setting up recipe
    local tinted_recipe = ConcreteTinter.MakeRecipe(
        data.raw["recipe"][concrete_type],
        tinted_tile
    )
    data.raw["recipe"][tinted_tile.name] = tinted_recipe

    -- Make the recipe available for the punny engineer
    table.insert(data.raw["technology"]["concrete"]["effects"], {
        type="unlock-recipe",
        recipe=tinted_tile.name
    })
end

return ConcreteTinter
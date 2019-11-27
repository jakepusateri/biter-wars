-- item.lua
local fireArmor = table.deepcopy(data.raw.armor["heavy-armor"])

fireArmor.name = "fire-armor"
fireArmor.icons = {
    {icon = fireArmor.icon, tint = {r = 1, g = 0, b = 0, a = 0.3}}
}

fireArmor.resistances = {
    {type = "physical", decrease = 6, percent = 10},
    {type = "explosion", decrease = 10, percent = 30},
    {type = "acid", decrease = 5, percent = 30},
    {type = "fire", decrease = 0, percent = 100}
}

local recipe = table.deepcopy(data.raw.recipe["heavy-armor"])
recipe.enabled = true
recipe.name = "fire-armor"
recipe.ingredients = {{"copper-plate", 200}, {"steel-plate", 50}}
recipe.result = "fire-armor"

data:extend{fireArmor, recipe}

local biterTargetingRemote = table.deepcopy(
                                 data.raw.capsule["artillery-targeting-remote"])

local button = {
    type = "custom-input",
    name = "my-custom-input",
    key_sequence = "SHIFT + G",
    consuming = "none"
}
data:extend{button}

data:extend{
    {
        type = "capsule",
        name = "ZoomingReinvented_binoculars",
        subgroup = "tool",
        order = "z[binoculars]",
        icons = {
            {
                icon = "__biter-wars__/graphics/binoculars.png",
                icon_size = 32
            }
        },
        capsule_action = {type = "artillery-remote", flare = "zoom-in-flare"},
        flags = {},
        stack_size = 1,
        stackable = false
    }, {
        type = "recipe",
        name = "ZoomingReinvented_binoculars-recipe",
        enabled = true,
        ingredients = {{"iron-plate", 1}},
        result = "ZoomingReinvented_binoculars"
    }, {
        type = "artillery-flare",
        name = "zoom-in-flare",
        flags = {"placeable-off-grid", "not-on-map"},
        map_color = {r = 0, g = 0, b = 0},
        life_time = 1,
        shots_per_flare = 0,
        pictures = {
            {
                filename = "__biter-wars__/graphics/binoculars.png",
                width = 1,
                height = 1,
                scale = 0
            }
        }
    }
}

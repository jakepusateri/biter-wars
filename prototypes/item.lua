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

--data:extend{fireArmor, recipe}

local biterTargetingRemote = table.deepcopy(
                                 data.raw.capsule["artillery-targeting-remote"])

local button = {
    type = "custom-input",
    name = "my-custom-input",
    key_sequence = "SHIFT + G",
    consuming = "none"
}
data:extend{button}

local biterSpawner2 = {
    type = "item",
    name = "biter-spawner2",
    icon = "__base__/graphics/icons/biter-spawner.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "c[assembling-machine-3]",
    place_result = "biter-spawner2",
    stack_size = 1
}

local recipe2 = table.deepcopy(data.raw.recipe["heavy-armor"])
recipe2.enabled = true
recipe2.name = "biter-spawner2"
recipe2.ingredients = {{"copper-plate", 1}}
recipe2.result = "biter-spawner2"

data:extend{biterSpawner2, recipe2}

local biterAttackTarget = {
    type = "item",
    name = "biter-attack-target",
    icon = "__base__/graphics/icons/artillery-targeting-remote.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "c[assembling-machine-3]",
    place_result = "biter-place-target",
    stack_size = 1
}


data:extend{biterAttackTarget}
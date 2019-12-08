-- data:extend({
--    type = "unit-spawner"
-- })
local biterSpawner2 = table.deepcopy(data.raw["unit-spawner"]["biter-spawner"])
biterSpawner2.name = "biter-spawner2"
biterSpawner2.max_count_of_owned_units = 500
biterSpawner2.max_friends_around_to_spawn = 500
biterSpawner2.spawning_cooldown = {30, 30}
data:extend{biterSpawner2}

local biterPlaceTarget = {
    type = "arrow",
    name = "biter-place-target",
    flags = {"placeable-off-grid", "not-on-map", "placeable-neutral"},
    blinking = true,
    icon = "__base__/graphics/icons/artillery-targeting-remote.png",
    icon_size = 32,
    arrow_picture = {
        filename = "__core__/graphics/arrows/gui-arrow-medium.png",
        priority = "low",
        width = 58,
        height = 62
    },
    circle_picture = {
        filename = "__core__/graphics/arrows/gui-arrow-circle.png",
        priority = "low",
        width = 50,
        height = 50
    }
}
data:extend{biterPlaceTarget}

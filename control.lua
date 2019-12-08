-- control.lua
require("mod-gui")
function create_gui(player)
    local leaderboard_frame = mod_gui.get_frame_flow(player).add{
        type = "frame",
        name = "biter_wars.leaderboard",
        caption = "Leaderboard",
        style = mod_gui.frame_style
    }

    if (player.index == 1) then
        mod_gui.get_button_flow(player).add{
            type = "button",
            name = "biter_wars.start_round",
            caption = "Start Round",
            style = mod_gui.button_style
        }
    end
end

-- ensure 1 biter attack remote in inventory
script.on_nth_tick(60, function(event)
    for index, player in pairs(game.connected_players) do
        if player.get_inventory(defines.inventory.character_main) ~= nil then
            local inventory_count = player.get_inventory(
                                        defines.inventory.character_main)
                                        .get_item_count("biter-attack-target")
            if inventory_count == 0 and
                not (player.cursor_stack.valid_for_read and
                    player.cursor_stack.type ~= "biter-attack-target") then
                player.insert({name = "biter-attack-target", count = 1})
            end
        end
    end
end)

-- https://lua-api.factorio.com/latest/Concepts.html#Command
function attack_position(position, player_index)
    local player = game.players[player_index]
    local unitList = player.surface.find_entities_filtered(
                         {force = "player", type = "unit"})
    local unit_group = player.surface.create_unit_group({position = position, force = player.force})
    for k, entity in pairs(unitList) do
        entity.ai_settings.allow_try_return_to_spawner = false
        entity.ai_settings.allow_destroy_when_commands_fail = false
        unit_group.add_member(entity)
        
    end
    unit_group.set_command({
        type = defines.command.attack_area,
        destination = position,
        radius = 32,
        distraction = defines.distraction.by_anything
    })
end

-- todo remove after testing
script.on_event("my-custom-input", function(event)
    game.print(event.player_index)
    game.print(game.players)
    player = game.players[event.player_index]
    player.surface.create_entity({
        name = "biter-spawner2",
        force = "enemy",
        position = {player.position.x, player.position.y - 5}
    })
end)

script.on_event(defines.events.on_built_entity, function(event)
    local player_index = event.player_index
    local entity_position = event.created_entity.position
    player = game.players[event.player_index]

    attack_position(entity_position, player_index)

    event.created_entity.destroy()
    player.insert({name = "biter-attack-target", count = 1})
end, {{filter = "name", name = "biter-place-target"}})

function apply_long_reach_settings()
    -- todo apply to all forces
    game.map_settings.path_finder.max_clients_to_accept_short_new_request = 200
    game.surfaces[1].always_day = true
end

function reset_force(force_name)
    global.kill_scores[force_name] = 0
    game.forces[force_name].evolution_factor = 0

    -- kill all current biters on force
    local unitList = game.connected_players[1].surface.find_entities_filtered(
                         {force = force_name, type = "unit"})
    for k, entity in pairs(unitList) do entity.destroy() end

    -- kill all previous buildings
    local unitList = game.connected_players[1].surface.find_entities_filtered(
                         {force = force_name, name = "biter-spawner2"})
    for k, entity in pairs(unitList) do entity.destroy() end

end

-- radius of the circle to spread player spawns
function start_game()
    if not global.kill_scores then global.kill_scores = {} end

    local num_players = table.maxn(game.connected_players)
    local radius = 100 + 50 * num_players
    game.print(
        string.format('Starting a new round with %d players', num_players))
    for index, player in pairs(game.connected_players) do
        player.force.character_build_distance_bonus = 5000
        player.force.character_reach_distance_bonus = 5000
    
        player.force.disable_all_prototypes()
        reset_force(player.force.name)

        -- create new spawner
        local angle_in_radians = (index * 2 * math.pi) / num_players
        local starting_position = {
            x = math.cos(angle_in_radians) * radius,
            y = math.sin(angle_in_radians) * radius
        }
        player.surface.create_entity({
            name = "biter-spawner2",
            force = player.force,
            position = starting_position
        })

        -- teleport to correct starting location
        player.teleport({starting_position.x, starting_position.y + 3},
                        player.surface)
    end
    if num_players == 1 then
        reset_force("enemy")

        game.connected_players[1].surface.create_entity(
            {
                name = "biter-spawner2",
                force = "enemy",
                position = {x = 0, y = 0}
            })
    end
end
-- https://en.wikipedia.org/wiki/Logistic_function
function get_evo_from_score(score)
    local L = 1
    local e = math.exp(1)
    local k = 1
    local x_0 = 1000
    return L / (1 + (math.pow(e, -k * (score - x_0))))
end

function on_gui_click(event)
    if event.element.name == "biter_wars.start_round" then start_game() end
end
script.on_event(defines.events.on_gui_click,
                function(event) on_gui_click(event) end)
script.on_init(function() apply_long_reach_settings() end)

script.on_configuration_changed(function(data) apply_long_reach_settings() end)

script.on_event(defines.events.on_entity_died, function(event)
    local new_score = global.kill_scores[event.force.name] + 1
    global.kill_scores[event.force.name] = new_score

    -- TODO differing points for different kills
    game.print(string.format("%s kill score %d", event.force.name, new_score))
    event.force.evolution_factor = get_evo_from_score(new_score)
    game.print(event.force.evolution_factor)
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    player.clear_items_inside()
    player.set_quick_bar_slot(1, "biter-attack-target")

    create_gui(game.connected_players[event.player_index])
end)
-- new items
-- -- custom building, biter spawner, spitter spawner
-- -- custom building - worm defense?
-- -- play as queen? you die your force loses?
-- gameplay
-- -- 'start' button that disables spawning until everyone can join
-- -- tint units by team, red/blue/yellow/orange/purple/green/black/white (up to 8 players)
-- -- -- this might require new entitities for each force, since dynamic tinting isn't a thing?
-- further
-- -- respawn into god-mode (aka spectator) with that force deleted
-- -- limit surface size to big ring that you start on the edge of
-- higher tier units than behemoth, new weapons like flamethrower, etc
-- neutral human defenses for more points that are higher-tier towards the 'center'


-- Documentation - play on peaceful please :), no cliffs, (100 + 50 * players) * 2 for map dimensions

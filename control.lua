-- control.lua
script.on_event({defines.events.on_tick}, function(e)
    if e.tick % 30 == 0 then -- common trick to reduce how often this runs, we don't want it running every tick, just every 30 ticks, so twice per second
        for index, player in pairs(game.connected_players) do -- loop through all online players on the server

            -- if they're wearing our armor
            if player.character and
                player.get_inventory(defines.inventory.character_armor)
                    .get_item_count("fire-armor") >= 1 then
                -- create the fire where they're standing
                player.surface.create_entity{
                    name = "fire-flame",
                    position = player.position,
                    force = "neutral"
                }
            end
        end
    end
end)

script.on_event(defines.events.on_player_used_capsule, function(event)
    if event.item.name == "ZoomingReinvented_binoculars" then
        local player = game.players[event.player_index]
        local unitList = player.surface.find_entities_filtered{
            area = chunkarea,
            force = "player",
            type = "unit"
        }
        for k, entity in pairs(unitList) do
            entity.set_command({
                type = defines.command.attack_area,
                destination = event.position,
                radius = 32,
                distraction = defines.distraction.by_anything
            })
        end
    end
end)

script.on_event("my-custom-input", function(event)
    game.print(event.player_index)
    game.print(game.players)
    player = game.players[event.player_index]
    player.surface.create_entity({
        name = "small-biter",
        force = "player",
        position = {player.position.x, player.position.y + 5}
    })
end)

function isHolding(item_name, player_index)
    local cursor_stack = game.players[player_index].cursor_stack
    if not cursor_stack.valid_for_read then return false end
    if cursor_stack.name == item_name then return true end

    return false
end

function initGlobal()
    if not global then global = {} end
    if not global.sot then global.sot = {} end
    if not global.sot.players then global.sot.players = {} end
end

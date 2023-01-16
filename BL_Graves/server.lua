ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local items = {
    [1] = {chance = 2, id = 'rolex', name = 'Rolex', quantity = math.random(1,3), limit = 3},
    [2] = {chance = 3, id = 'wallet', name = 'Wallet', quantity = 1, limit = 4},
    [3] = {chance = 3, id = 'lotteryticket', name = 'Lottery Ticket', quantity = 1, limit = 10},
    [4] = {chance = 1, id = 'dagger', name = 'Rare item', quantity = 1, limit = 2},
    [5] = {chance = 3, id = 'fabric', name = 'Fabric', quantity = math.random(1,8), limit = 20},
    [6] = {chance = 3, id = 'blankblueprint', name = 'Blank Prints', quantity = math.random(1,8), limit = 100}
}

RegisterServerEvent('grave:GiveRandomItem')
AddEventHandler('grave:GiveRandomItem', function()
    local source = tonumber(source)
    local item = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local gotID = {}
    local rolls = math.random(1, 2)
    local foundItem = false
    for i = 1, rolls do
        item = items[math.random(1, #items)]
        if math.random(1, 10) >= item.chance then
            if not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count

                    if count >= item.limit then
                        TriggerClientEvent("pNotify:SendNotification", source, {
                            text =  'You found ' .. item.quantity .. 'x ' .. item.name .. ' but cannot carry any more of this item',
                            type = "success",
                            queue = "lmao",
                            timeout = 5000,
                            layout = "centerLeft"
                        })
                    else
                        gotID[item.id] = true
                        TriggerClientEvent("pNotify:SendNotification", source, {
                            text =  'You found ' .. item.quantity .. 'x ' .. item.name,
                            type = "success",
                            queue = "lmao",
                            timeout = 5000,
                            layout = "centerLeft"
                        })
                        xPlayer.addInventoryItem(item.id, item.quantity)
                        foundItem = true
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent("pNotify:SendNotification", source, {
                        text =  'You found ' .. item.quantity .. 'x ' .. item.name,
                        type = "success",
                        queue = "lmao",
                        timeout = 5000,
                        layout = "centerLeft"
                    })
                    xPlayer.addInventoryItem(item.id, item.quantity)
                    foundItem = true
                end
            end
        end

        if i == rolls and not gotID[item.id] and not foundItem then
            TriggerClientEvent("pNotify:SendNotification", source, {
            text =  'You found nothing',
            type = "success",
            queue = "lmao",
            timeout = 5000,
            layout = "centerLeft"
            })
        end
    end
end)
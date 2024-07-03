local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem("wheelgun", function(source, item)
    TriggerClientEvent('wheel:remove', source)
end)

QBCore.Functions.CreateUseableItem("welder", function(source, item)
    TriggerClientEvent('brakes:cut', source)
end)
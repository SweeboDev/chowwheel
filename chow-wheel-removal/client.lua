local QBCore = exports['qb-core']:GetCoreObject()

local wheelBones = {
    "wheel_lf", -- Front left
    "wheel_rf", -- Front right
    "wheel_lr", -- Rear left
    "wheel_rr"  -- Rear right
}
local originalBrakeForces = {}



function SetVehicleHandlingField(vehicle, class, field, value)
    local handling = GetVehicleHandlingFloat(vehicle, class, field)
    SetVehicleHandlingFloat(vehicle, class, field, value)
end


RegisterNetEvent('wheel:remove', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)

    if vehicle then
        if QBCore.Functions.HasItem("wheelgun") then
            local boneIndex, wheelBone, closestWheelIndex = GetClosestWheelBone(vehicle)
            
            if boneIndex then
                QBCore.Functions.Progressbar("remove_wheel", "Removing Wheel...", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                    anim = "machinic_loop_mechandplayer",
                    flags = 49,
                }, {}, {}, function() -- Done
                    ClearPedTasksImmediately(playerPed)
                    BreakOffVehicleWheel(vehicle, closestWheelIndex, true, true, true, false)
                    ApplyForceToEntity(vehicle, 0, 0, 100.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, true, true, true)
                
                    -- Adjusting wheel position to fall towards the player
                    local wheelPos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                    local playerPos = GetEntityCoords(playerPed)
                    local direction = (playerPos - wheelPos)
                    direction = direction / #(direction)  -- Normalize the direction vector
                    local offsetPos = wheelPos + direction * 0.5
                    local wheelProp = CreateObject(GetHashKey('prop_wheel_01'), offsetPos.x, offsetPos.y, offsetPos.z, true, true, true)
                    
                    -- Apply force to make the wheel fall towards the player
                    ApplyForceToEntity(wheelProp, 1, direction.x * 2.0, direction.y * 18.0, direction.z * 2.0, 0.0, 0.0, 0.0, 1, false, true, true, false, true)
                    
                    PlaceObjectOnGroundProperly(wheelProp)
                    QBCore.Functions.Notify("Wheel removed successfully", "success")
                end, function() -- Cancel
                    ClearPedTasksImmediately(playerPed)
                    QBCore.Functions.Notify("Wheel removal canceled", "error")
                end)
                
                
                
            else
                QBCore.Functions.Notify("No wheel detected", "error")
            end
        else
            QBCore.Functions.Notify("You need a wheelgun to remove the wheel", "error")
        end
    else
        QBCore.Functions.Notify("No vehicle nearby", "error")
    end
end)

function GetClosestWheelBone(vehicle)
    local closestDistance = 999.0
    local closestBoneIndex = nil
    local closestWheelBone = nil
    local closestWheelIndex = nil

    for index, wheelBone in ipairs(wheelBones) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, wheelBone)
        if boneIndex ~= -1 then
            local wheelPos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local distance = #(wheelPos - GetEntityCoords(PlayerPedId()))
            if distance < closestDistance then
                closestDistance = distance
                closestBoneIndex = boneIndex
                closestWheelBone = wheelBone
                closestWheelIndex = index - 1
            end
        end
    end

    return closestBoneIndex, closestWheelBone, closestWheelIndex
end


local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function loadAnimDict(dict)  
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end 

local graveyards = {
	cells = {
		sandy = {
			vector3(-279.39, 2842.88, 54.03),
			vector3(-276.43, 2841.93, 53.89),
			vector3(-293.94, 2840.52, 55.44),
			vector3(-292.01, 2839.41, 55.31),
			vector3(-286.92, 2836.94, 55.16),
			vector3(-289.93, 2838.83, 55.23),
			vector3(-281.84, 2843.96, 54.12),
			vector3(-285.27, 2844.96, 54.29),
			vector3(-287.16, 2845.73, 54.36),
			vector3(-289.34, 2850.38, 54.11),
			vector3(-291.88, 2851.41, 54.2),
			vector3(-293.51, 2852.92, 54.17),
			vector3(-1783.9470, -201.7204, 54.5982),
			vector3(-1797.8639, -209.5608, 52.8228),
			vector3(-1802.7074, -267.3396, 44.0044),
			vector3(-1764.0299, -303.6138, 46.4523),
			vector3(-1770.5204, -266.4391, 47.5860),
			vector3(-1740.6268, -281.8751, 49.4802),
			vector3(-1757.1519, -229.7124, 53.8685),
			vector3(-1715.1760, -235.5314, 55.0414),
			vector3(-1717.1843, -218.1249, 57.5958),
			vector3(-1703.9944, -219.7671, 57.6967),
			vector3(-1622.2960, -171.1660, 56.4067),
			vector3(-1625.4764, -183.0021, 55.6928),
			vector3(-1631.9799, -142.8353, 57.6844),
			vector3(-1655.9268, -147.3300, 58.5061),
			vector3(-1674.3601, -126.5405, 60.2370),
			vector3(-1678.1289, -170.9905, 57.7523),
			vector3(-1708.6661, -186.6246, 57.6658),
			vector3(5326.1606, -4881.7783, 15.1397),
		},
	},
}

local running = false
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)	
			if running == false then
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				local hasExited, letSleep = false, false, true
				local IsInMarker ='b'
				for k,v in pairs(graveyards) do
					for i=1, #v.sandy, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.sandy[i], true)
					if distance < 1.2 then
						DrawText3D(v.sandy[i], 'Press E to search', 0.40)
						letSleep = false
						if distance < 1.0 then
							if isInMarker == "b" then
								if IsControlJustPressed(0, 38) then 
								--running = true
									TriggerEvent('gravedigging', v.sandy[i])
								end
							else
								isInMarker = 'b'
								--running = false
							end
						end	
					end
				end
			end
		end
	end
end) 


local gravesearching = {}

RegisterNetEvent('gravedigging')
AddEventHandler('gravedigging', function(bedloc)
	local bedloc = bedloc
	local number = math.random(1,6)
	local playerPed = PlayerPedId()
	local bedsearched = false
	for i=1, #gravesearching, 1 do
		if gravesearching[i] == bedloc then
			notify('You have already searched here')
			bedsearched = true
			break
		end	
	end	

	if bedsearched == false then
		table.insert(gravesearching, bedloc)
		local playerPed = PlayerPedId()
		TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)	
		Wait(1)	
		FreezeEntityPosition(PlayerPedId(-1), true)
		exports.rprogress:Start("Digging Body", 15000)
			RequestModel( GetHashKey( "u_m_y_zombie_01" ) )
			while ( not HasModelLoaded( GetHashKey( "u_m_y_zombie_01" ) ) ) do
				Citizen.Wait( 1 )
			end
			local pos = GetEntityCoords(GetPlayerPed(-1))
			local ped = CreatePed(29, 0xE16D8F01, pos.x, pos.y, pos.z-1.6, 90.0, true, false)
			SetEntityHealth(ped, 0)
			Wait(4000)
			exports.rprogress:Start("Looting Body", 6000)
			FreezeEntityPosition(PlayerPedId(-1), false)
			DeleteEntity(ped)
			Wait(1000)
			ClearPedTasks(playerPed)
			TriggerServerEvent('grave:GiveRandomItem')
	end
end)


RegisterNetEvent('gravebed_reset')
AddEventHandler('gravebed_reset', function(bedloc)
gravesearching = {}
end)


function DrawText3D(vecter, text, scale) 
local vecter = vecter
local x, y, z = table.unpack(vecter) 
local onScreen, _x, _y = World3dToScreen2d(x, y, z) 
SetTextScale(scale, scale) 
SetTextFont(4) 
SetTextProportional(1)
 SetTextEntry("STRING") 
 SetTextCentre(true) 
 SetTextColour(255, 255, 255, 215) 
 AddTextComponentString(text) 
 DrawText(_x, _y) 
 local factor = (string.len(text)) / 700 
 DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100) 
end
 
function notify(string)
  exports.pNotify:SendNotification({text = string, timeout = 5000})
end

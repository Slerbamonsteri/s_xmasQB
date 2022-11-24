local ClaimedTrees = {}
local ClaimedNames = {}
local QBCore = exports['qb-core']:GetCoreObject()


--Prepare your eyes. This is one nasty payout event kekw. Hope you know how to read code

--I wouldve used netid's but creating trees locally for players gives out different netids thus i decided to go for tree coords for the checks.
RegisterServerEvent('s_xmas:claim', function(treecoords, sourcecoords)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local name = GetPlayerName(source) --I think you could change this to like xPlayer.identifier or something for even better security against reconnecting and reclaiming.
	local raredrop = math.random(1, 100) --Change this to your liking
	local randomizeLoot = math.random(1, #Config.LootTable) --Editing first number will increase given items from the loot table, defaulted as 1 per gift
	local randomizeRareLoot = math.random(1, #Config.RareLootTable)
	if ClaimedTrees[treecoords] ~= nil then 
		if ClaimedTrees[treecoords].looted <= Config.maxGifts then --Checking that the tree still has gifts

			--With this loop we will be checking every steam name that has claimed the tree, and then decide if player is eligible for reward!
			for k,v in pairs(ClaimedNames[treecoords]) do
				if v == name then
					--xPlayer.showNotification('You claimed this already!')
					return
				end
			end

			table.insert(ClaimedNames[treecoords], name)
			if raredrop >= 1 and raredrop <= 20 then --Editing these values you can increase / decrease chances of player rolling to raredrop table currently around 1:5 chance to roll it.
				for k,v in pairs(Config.RareLootTable[randomizeRareLoot]) do
					if v.itemtype == 'item' then
						xPlayer.Functions.AddItem(v.item, v.amount)
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
						--Add notif
						--Log your stuff here
					elseif v.itemtype == 'money' then
						xPlayer.Functions.AddMoney(v.amount)
						--xPlayer.showNotification('You hit the raredroptable and got: '..(v.amount).. '$ -Happy holidays!')
						--Log your stuff here
					elseif v.itemtype == 'weapon' then
						xPlayer.Functions.AddItem(v.item, v.amount)
						--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
						--Log your stuff here
					end
				end
			else --Didnt land on raredrop, lets give default loot!
				for k,v in pairs(Config.LootTable[randomizeLoot]) do
					if v.itemtype == 'item' then
						xPlayer.Functions.AddItem(v.item, v.amount)
						--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
						--Log your stuff here
					elseif v.itemtype == 'money' then
						xPlayer.Functions.AddMoney(v.amount)
						--xPlayer.showNotification('You hit the raredroptable and got: '..(v.amount).. '$ -Happy holidays!')
						--Log your stuff here
					elseif v.itemtype == 'weapon' then
						xPlayer.Functions.AddItem(v.item, v.amount)
						--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
						--Log your stuff here
					end
				end
			end
		else
			xPlayer.showNotification('This tree has no more gifts!')
		end
	else -- Only using this to create tables for trees.
		ClaimedTrees[treecoords] = {}
		ClaimedNames[treecoords] = {}
		ClaimedTrees[treecoords].looted = 1
		table.insert(ClaimedNames[treecoords], name) --Adding steam name to the table for later checking!
		if raredrop >= 1 and raredrop <= 20 then --Editing these values you can increase / decrease chances of player rolling to raredrop table currently around 1:5 chance to roll it.
			for k,v in pairs(Config.RareLootTable[randomizeRareLoot]) do
				if v.itemtype == 'item' then
					xPlayer.Functions.AddItem(v.item, v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
					--Log your stuff here
				elseif v.itemtype == 'money' then
					xPlayer.Functions.AddMoney(v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.amount).. '$ -Happy holidays!')
					--Log your stuff here
				elseif v.itemtype == 'weapon' then
					xPlayer.Functions.AddItem(v.item, v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
					--Log your stuff here
				end
			end
		else --Default loottable below
			for k,v in pairs(Config.LootTable[randomizeLoot]) do
				print(v.itemtype)
				if v.itemtype == 'item' then
					xPlayer.Functions.AddItem(v.item, v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
					--Log your stuff here
				elseif v.itemtype == 'money' then
					xPlayer.Functions.AddMoney(v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.amount).. '$ -Happy holidays!')
					--Log your stuff here
				elseif v.itemtype == 'weapon' then
					xPlayer.Functions.AddItem(v.item, v.amount)
					--xPlayer.showNotification('You hit the raredroptable and got: '..(v.item).. ' -Happy holidays!')
					--Log your stuff here
				end
			end
		end
	end

end)

--Feel free to use these, I added these for my own debugging but with these you can easily Clear every ped, vehicle and prop known to server.
--For example if cheaters spawn stuff you can use these to remove them. 


--[[
RegisterCommand('clearpeds', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local peds = GetAllPeds()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(peds) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			if not IsPedAPlayer(NetPed1) then
				DeleteEntity(v)
			end
		end
	end
end)

RegisterCommand('clearvehicles', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local AllVeh = GetAllVehicles()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(AllVeh) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			DeleteEntity(v)
		end
	end
end)

RegisterCommand('clearprops', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local AllProps = GetAllObjects()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(AllProps) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			DeleteEntity(v)
		end
	end
end)]]

--Example log, obviously you have to modify it to your liking if you decide to use this.
--xmasLog(121213, 'Present Log', 'Player: '..GetPlayerName(source)..' \nLooted xmas tree and got: '..v.item..' | '..v.amount..'', 'ExampleLog')
--[[
local webhook = 'ENTER WEBHOOK'
function xmasLog(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
            	["text"] = footer,
              },
          }
      }
    PerformHttpRequest(xenons, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end]]
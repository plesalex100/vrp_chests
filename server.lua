local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_chests")

--- Config
-- list of static chests
-- {access, x, y, z, name-optional}
-- access = can be user_id, user_permission or user_group. Set it to "none" to give to all players access to the chest.
-- name = if you have multiple chests with same access you need to set different name, or the chests with same access will containt same items.
local chests = {}
chests = {
	{"cop", 1851.3234863281,3690.7126464844,34.267040252686, "Police Locker"},
	{"1", -2361.0776367188,3243.5947265625,92.903678894043, "Owner's Chest"},
	{"none", 1438.2683105469,1146.2396240234,114.32404327393}
}
-- I've put some random locations just for test, change them.
---#

local function create_pleschest(owner_access, x, y, z, player, name)
	local namex = name or "chest"
	
	local chest_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if owner_access == "none" or user_id == tonumber(owner_access) or vRP.hasGroup({user_id, owner_access}) or vRP.hasPermission({user_id, owner_access}) then
				vRP.openChest({player, "static:"..owner_access..":"..namex, 200, nil, nil, nil})
			end
		end
	end

	local chest_leave = function(player,area)
		vRP.closeMenu({player})
	end
	
	local nid = "vRP:static-"..namex..":"..owner_access
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,148,255,125,150})
	vRP.setArea({player,nid,x,y,z,1,1.5,chest_enter,chest_leave})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
	for k, v in pairs(chests) do
		create_pleschest(v[1], v[2], v[3], v[4], source, v[5])
		--TriggerClientEvent('chatMessage', -1, "Chest created: "..v[1]..", "..v[2]..", "..v[3]..", "..v[4]..", "..v[5]..".") -- debuging.
	end
  end
end)

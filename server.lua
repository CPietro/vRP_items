MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Lang = module("vrp", "lib/Lang")

vRPfg = {}
Tunnel.bindInterface("vRP_items",vRPfg)
Proxy.addInterface("vRP_items",vRPfg)
FGclient = Tunnel.getInterface("vRP_items","vRP_items")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_items")
--vRPfg = Tunnel.getInterface("vrp_items","vrp_items")
lang = Lang.new(module("vrp_cards", "cfg/lang"))
config = module("vrp_items", "cfg/config")
local cfg = module("vrp_items", "cfg/adaptive_items")
--SQL--
local itemslist = config.itemslist

local itemtable = ""
for k,v in pairs(itemslist) do 
	itemtable = itemtable..[[
	CREATE TABLE IF NOT EXISTS vrp_]]..v..[[(
		iid INTEGER,
		ikey VARCHAR(255),
		ivalue TEXT,
		CONSTRAINT pk_]]..v..[[ PRIMARY KEY(iid)
	);]]
end
MySQL.createCommand("vRP/items_table", itemtable)

MySQL.execute("vRP/items_table")

local itemcommands = {}
for k,v in pairs(itemslist) do
	MySQL.createCommand("vRP/crea_"..v,"INSERT IGNORE INTO vrp_"..v.."(iid,ikey,ivalue) VALUES(@iid,@ikey,@ivalue)")
	MySQL.createCommand("vRP/get_"..v.."_number","SELECT ikey FROM vrp_"..v.." WHERE iid = @iid")
	MySQL.createCommand("vRP/get_"..v.."_value","SELECT ivalue FROM vrp_"..v.." WHERE iid = @iid")
	MySQL.createCommand("vRP/set_new_number_"..v,"UPDATE vrp_"..v.." SET ivalue = @ivalue WHERE iid = @iid")
	MySQL.createCommand("vRP/get_"..v.."_number1","SELECT * FROM vrp_"..v)
	MySQL.createCommand("vRP/get_"..v.."_value1","SELECT * FROM vrp_"..v)
	MySQL.createCommand("vRP/IBK_"..v,"INSERT IGNORE INTO vrp_"..v.."(iid,ikey,ivalue) VALUES(@iid,@ikey,@ivalue)")
	MySQL.execute("vRP/IBK_"..v, {iid = 999999, ikey = "number", ivalue = json.encode({value = 0})})
end

for k,v in pairs(cfg.adaptive_items) do
	vRP.defInventoryItem({k,v.name,v.desc,v.choices,v.weight})
end

function ProssimaKey(tipo,last,cbr)
	local dati = {value = last}
	MySQL.execute("vRP/set_new_number_"..tipo, {iid = 999999, ivalue = json.encode(dati)})
end

function DefInventoryItemSQL(tipo,spawnname,key,data)
	MySQL.execute("vRP/crea_"..tipo, {iid = key, ikey = spawnname, ivalue = json.encode(data)})
end

function generaNumero(user_id)
	math.randomseed(os.time() - os.clock() * 1000)
	for i=0,5 do
		math.random(4000000000000001,4999999999999999)
	end
	local numero = tonumber(math.random(4000000000000001,4999999999999999))
	return numero
end

function generaPIN(user_id)
	math.randomseed(os.time() - os.clock() * 1000)
	for i=0,5 do
		math.random(10001,99999)
	end
	local numero = tonumber(math.random(10001,99999))
	return numero
end

function GetValueByNumber(tipo,number,cbr)
	local task = Task(cbr)
    MySQL.query("vRP/get_"..tipo.."_value", {iid = number}, function(rows, affected)
		if #rows > 0 then
			task({rows[1].ivalue})
		else
			task()
		end
	end)
end

function buildItems()
	for _,k in ipairs(itemslist) do
		GetValueByNumber(k,999999, function(key) 
		local dec = json.decode(key)
		local number = tonumber(dec.value)
			if number > 0 then
				MySQL.query("vRP/get_"..k.."_value1", {}, function(rows, affected)
					if #rows > 0 then
						for i=1, number do
							if k ~= "zaino" then
								local val = json.decode(tostring(rows[i].ivalue))
								vRP.defInventoryItem({tostring(rows[i].ikey),val.name,val.desc,nil,val.weight})
							else
								local val = json.decode(tostring(rows[i].ivalue))
								local scelta = function(args)
									local menu = {}
										menu["Apri"] = {function(player,choice)
											vRP.openChest({player, "zaino_"..val.choice, math.ceil(val.weight*10),false,nil,nil})
										end}
									return menu
								end
								vRP.defInventoryItem({tostring(rows[i].ikey),val.name,val.desc,scelta,val.weight})
							end
						end
					end
				end)
			end
		end)
	end
end

SetTimeout(12000,function()
	buildItems()
end)
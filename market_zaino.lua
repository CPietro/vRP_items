local Lang = module("vrp", "lib/Lang")
lang = Lang.new(module("vrp_items", "cfg/lang"))
local zaino_shops = {
	{-927.94635009766,-2954.02734375,13.945074081421,"lsia.mission"}
}

local function ch_compra_zaino_10kg(player,choice)
  local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local kg = 10
		local weight = math.ceil(kg/10)
		local new_weight = vRP.getInventoryWeight({user_id})+weight
		if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
			if vRP.tryFullPayment({user_id,10000}) then
				vRP.closeMenu({player})
				GetValueByNumber("zaino",999999, function(nkey) 
					local lol = json.decode(nkey)
					local number = tonumber(lol.value)
					local key = number + 1
					SetTimeout(2000,function()
						local tipo = "zaino"
						local nomesp = "zaino_"..key
						local contenuto = lang.bag.desc()
						local nomevi = lang.bag.itemname({key})
						local menu = {}
						local scelta = function(args)
							local menu = {}
								menu[lang.bag.open_ch()] = {function(player,choice)
									vRP.openChest({player, "zaino_"..key, math.ceil(kg),false,nil,nil})
								end}
							return menu
						end
						local scelta_data = key
						vRP.defInventoryItem({nomesp,nomevi,contenuto,scelta,weight})
						vRP.giveInventoryItem({user_id, "zaino_"..key, 1, true})
						local dati = {name = nomevi, desc = contenuto, choice = scelta_data, weight = weight}
						DefInventoryItemSQL("zaino",nomesp, key, dati)
						ProssimaKey("zaino",key)
					end)
				end)
			else
				vRPclient.notify(player,{lang.common.not_enough_money()})
			end
		else
			vRPclient.notify(player,{lang.common.inventory_full()})
		end
	end
end

local zshop_menu = {name=lang.menu.name(),css={top="75px",header_color="rgba(0,255,255,0.75)"}}
zshop_menu[lang.menu.kg10_bag()] = {ch_compra_zaino_10kg, lang.menu.kg10_price()}
zshop_menu.onclose = function(source) vRP.closeMenu({source}) end


local function build_client_zaino_shop(source)
  local user_id = vRP.getUserId({source})
  if user_id ~= nil then
    for k,v in pairs(zaino_shops) do
      local x,y,z,perm = table.unpack(v)

      local zaino_shop_enter = function(source)
        local user_id = vRP.getUserId({source})
				if user_id ~= nil and vRP.hasPermission({user_id,perm or {}}) then
					vRP.openMenu({source,zshop_menu})
        		end
      end

      local function zaino_shop_leave(source)
        vRP.closeMenu({source})
      end

      vRPclient.addBlip(source,{x,y,z,175,28, lang.menu.buy_bags()})
      vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

      vRP.setArea({source,"vRP:zaino_shop"..k,x,y,z,1,1.5,zaino_shop_enter,zaino_shop_leave})
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
	  build_client_zaino_shop(source)
	end
end)

if config.cards then
	MySQL.createCommand("vRP/insert_num_pin","UPDATE vrp_cards SET numerocarta = @numerocarta , pin = @pin WHERE user_id = @user_id")
end

local cfg = {}

cfg.adaptive_items = {
	["cardcontract"] = {
		name = lang.card.name(),
		desc = lang.card.desc(),
		choices = function(args)
			local menu = {}
			menu[lang.common.sign()] = {function(player,choice)
				local user_id = vRP.getUserId({player})
				if user_id ~= nil then
					if vRP.tryGetInventoryItem({user_id,"contrattocarta",1,false}) and ( vRP.tryGetInventoryItem({user_id,"penna",1,false}) or vRP.tryGetInventoryItem({user_id,"pennablu_3",1,false}) ) then
						vRPclient.notify(player,{lang.common.writing()})
						vRPclient.playAnim(player,{false,{task="CODE_HUMAN_MEDIC_TIME_OF_DEATH"},true})             
						vRP.getUserIdentity({user_id, function(identity)
							GetValueByNumber("bank_cards",999999, function(nkey)		   
								SetTimeout(1000,function()
									numerocarta = generaNumero(user_id)
									pin = generaPIN(user_id)
									MySQL.execute("vRP/insert_num_pin", {user_id = user_id, numerocarta = numerocarta, pin = pin}, function(affected)	
										vRPclient.notify(player, {lang.card.pin({pin})})
									end)
									local lol = json.decode(nkey)
									local number = tonumber(lol.value)
									local key = number + 1
									local nomenum = numerocarta
									local nomesp = "bank_cards_"..nomenum
									local nomevi = lang.card.itemname({user_id})
									local contenuto = lang.card.itemdesc1({user_id})
									if identity then
										contenuto = lang.card.itemdesc2({identity.firstname, identity.name})
									end
									local scelta = nil
									local weight = 0.02
									vRP.defInventoryItem({nomesp,nomevi,contenuto,scelta,iweight})
									SetTimeout(2000,function()
										vRP.giveInventoryItem({user_id, nomesp, 1, true})
										local dati = {name = nomevi, desc = contenuto, choice = scelta, weight = weight}
										DefInventoryItemSQL("bank_cards",nomesp, key, dati)
										ProssimaKey("bank_cards",key) 
										vRPclient.stopAnim(player,{true})
										vRPclient.stopAnim(player,{false})
									end)
								end)
							end)
						end})
						vRP.closeMenu({player})
					else
						vRPclient.notify(player,{lang.common.pen_missing()})
					end
				end
			end}
			return menu
		end,
	weight = 0.1
	},
	["driving_contract"] = {
		name = lang.driving_lic.name(),
		desc = lang.driving_lic.desc(),
		choices = function(args)
			local menu = {}
			menu[lang.common.sign()] = {function(player,choice)
			local user_id = vRP.getUserId({player})
			if user_id ~= nil then
				if vRP.tryGetInventoryItem({user_id,"contratto_a",1,false}) and ( vRP.tryGetInventoryItem({user_id,"penna",1,false}) or vRP.tryGetInventoryItem({user_id,"pennablu_3",1,false}) ) then
					vRPclient.notify(player,{lang.common.writing()})
					vRPclient.playAnim(player,{false,{task="CODE_HUMAN_MEDIC_TIME_OF_DEATH"},true}) 
					vRP.getUserIdentity({user_id, function(identity)
						GetValueByNumber("patente",999999, function(nkey) 
							local lol = json.decode(nkey)
							local number = tonumber(lol.value)
							local key = number + 1
							local patente = "license"
							local nomesp = "patente_"..key
							local nomevi = lang.driving_lic.itemname({user_id})
							local contenuto = lang.driving_lic.itemdesc1({user_id})
							if identity then
								contenuto = lang.driving_lic.itemdesc2({identity.firstname, identity.name})
							end
							local scelta = nil
							local weight = 0.02
							vRP.defInventoryItem({nomesp,nomevi,contenuto,scelta,iweight})
							SetTimeout(2000,function()
								vRP.giveInventoryItem({user_id, nomesp, 1, true})
								local dati = {name = nomevi, desc = contenuto, choice = scelta, weight = weight}
								DefInventoryItemSQL("patente",nomesp, key, dati)
								ProssimaKey("patente",key)
								vRPclient.stopAnim(player,{true})
								vRPclient.stopAnim(player,{false})
							end)
						end)
					end})
					vRP.closeMenu({player})
				else
					vRPclient.notify(player,{lang.common.pen_missing()})
				end
			end
		end}
		return menu
	end,
	weight = 0.1
	}
}

return cfg

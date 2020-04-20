vRPfg = {}
Tunnel.bindInterface("vRP_items",vRPfg)
vRPserver = Tunnel.getInterface("vRP","vRP_items")
FGserver = Tunnel.getInterface("vRP_items","vRP_items")
vRP = Proxy.getInterface("vRP")

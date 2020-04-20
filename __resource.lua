

dependencies {
	'vrp',
	'vrp_mysql'
}

server_scripts { 

  "@vrp/lib/utils.lua",
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'market_zaino.lua'

}


client_scripts { 

  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "client.lua"

}

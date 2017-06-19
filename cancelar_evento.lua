redis.call("SELECT", 2)

local nome_evento = ARGV[1]
local lista_eventos = redis.call("LRANGE", "lista_eventos", "0", "-1")
local numero_eventos = redis.call("LLEN", "lista_eventos")
local novos_eventos = {}
local indice_unmatch = 0
local cancelado = false

for i=1, numero_eventos,1 do
	local evento_atual = redis.call("HMGET", lista_eventos[i], "nome")
	if(nome_evento == evento_atual[1]) then
		cancelado = true
		redis.call("DEL", "lista_eventos")
	else
		--redis.call("LPUSH", "lista_eventos", evento_atual[1])
		indice_unmatch = indice_unmatch + 1
		novos_eventos[indice_unmatch] = lista_eventos[i]
		
	end
end

if(cancelado) then
	for j=1, indice_unmatch, 1 do
		redis.call("LPUSH", "lista_eventos", novos_eventos[j])
	end
end

local nova_lista = redis.call("LRANGE", "lista_eventos", "0", "-1")
return nova_lista
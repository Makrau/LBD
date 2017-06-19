redis.call("SELECT", 2)
local dias_da_semana = ARGV[1]
local horario = ARGV[2]
local lista_salas = redis.call("LRANGE", "lista_salas", "0", "-1")
local lista_eventos = redis.call("LRANGE", "lista_eventos", "0", "-1")
local numero_eventos = redis.call("LLEN", "lista_eventos")
local numero_salas = redis.call("LLEN", "lista_salas")
local salas_indisponiveis = {}
local salas_disponiveis = {}
local indice = 0

for i=1,numero_eventos,1 do
	local sala_evento = redis.call("HMGET", lista_eventos[i], "sala")
	local horario_evento = redis.call("HMGET", lista_eventos[i], "horario")
	local dia_evento = redis.call("HMGET", lista_eventos[i], "dias")
	
	if(dias_da_semana == dia_evento[1] and horario == horario_evento[1]) then
		for j=1, numero_salas, 1 do
			if(lista_salas[j] == sala_evento[1]) then
				indice = indice + 1
				salas_indisponiveis[indice] = sala_evento[1]
			end
		end
	end
end

local segundo_indice = 1
local sala_invalida = false
for i=1, numero_salas, 1 do
	for j=1, indice,1 do
		if(lista_salas[i] == salas_indisponiveis[j]) then
			sala_invalida = true
		end
	end

	if(not sala_invalida) then
		salas_disponiveis[segundo_indice] = lista_salas[i]
		segundo_indice = segundo_indice + 1
	end

	sala_invalida = false
end
return salas_disponiveis

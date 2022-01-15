--- Criação de tabelas para trabalhar os dados da carga

DROP TABLE IF EXISTS act_pedidos
CREATE TABLE act_pedidos
(order_id int,
store_id int,
channel_id int,
order_amount float,
order_status varchar(50),
order_moment_created varchar(50)
)

INSERT INTO act_pedidos
SELECT order_id,store_id, channel_id, order_amount, order_status, order_moment_created
FROM CG_orders

CREATE TABLE act_lojafood
(store_id int,
hub_id int,
store_name varchar(100),
store_segment varchar(100)
)

INSERT INTO act_lojafood
SELECT store_id, hub_id, store_name, store_segment
FROM CG_stores

CREATE TABLE act_hubs
(hub_id int,
hub_name varchar(100),
hub_city varchar(100),
hub_state varchar(2)
)

INSERT INTO act_hubs
SELECT hub_id,hub_name, hub_city, hub_state
FROM CG_hubs


CREATE TABLE act_canal
(channel_id int,
channel_name varchar(50),
channel_type varchar(50)
)

INSERT INTO act_canal
SELECT *
FROM CG_channels


--- Verificar as novas tabelas criadas

SELECT TOP 5 *
FROM act_canal

SELECT TOP 5 *
FROM act_hubs

SELECT TOP 5 *
FROM act_lojafood

SELECT TOP 5 *
FROM act_pedidos

--- Criar uma tabela temporária para analisar o comportamento das order_id (pedidos) em relação a outras variáveis
--- Nesse processo o campo 'order_moment_created' foi dividido em 'hora' e dia_mes e seu data type foi convertido
-- de nvarchar para time e date respectivamente para ser usado em programas de visualizaçao posteriormente

CREATE TABLE #temp_comporgeral
(order_id int,
order_amount float,
order_status varchar(50),
channel_name varchar(50),
channel_type varchar(50),
store_name varchar(50),
store_segment varchar(50),
hub_name varchar(50),
hub_city varchar(50),
hub_state varchar(2),
hora time(0),
dia_mes date
)

INSERT INTO #temp_comporgeral
SELECT order_id, order_amount, order_status, channel_name, channel_type, store_name, store_segment, hub_name, hub_city, hub_state
, (SELECT CONVERT(TIME(0),order_moment_created)) AS hora, (SELECT CONVERT(date,order_moment_created)) AS dia_mes 
FROM act_pedidos AS ped
LEFT JOIN act_canal AS can
	ON ped.channel_id = can.channel_id
LEFT JOIN act_lojafood AS food
	ON ped.store_id = food.store_id
LEFT JOIN act_hubs AS hub
	ON food.hub_id = hub.hub_id


--- Criação de view para futuras visualizações

CREATE VIEW comportgeral AS
SELECT order_id, order_amount, order_status, channel_name, channel_type, store_name, store_segment, hub_name, hub_city, hub_state
, (SELECT CONVERT(TIME(0),order_moment_created)) AS hora, (SELECT CONVERT(date,order_moment_created)) AS dia_mes 
FROM act_pedidos AS ped
LEFT JOIN act_canal AS can
	ON ped.channel_id = can.channel_id
LEFT JOIN act_lojafood AS food
	ON ped.store_id = food.store_id
LEFT JOIN act_hubs AS hub
	ON food.hub_id = hub.hub_id

--- Recorte dos pedidos por mês para carregar em uma tabela excel

SELECT *
FROM comportgeral
WHERE MONTH(dia_mes) = 1

SELECT *
FROM comportgeral
WHERE MONTH(dia_mes) = 2

SELECT *
FROM comportgeral
WHERE MONTH(dia_mes) = 3

SELECT *
FROM comportgeral
WHERE MONTH(dia_mes) = 4



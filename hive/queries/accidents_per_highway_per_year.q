-- Qual é a estrada com maior número de acidentes em cada ano?

WITH acidentes_por_veiculo AS (
    SELECT DISTINCT id
        , cast(substr(data_inversa, 0, 4) AS int) AS ano
        , br
        , id_veiculo
    FROM acidentes
), acidentes_de_automoveis_por_ano_por_br AS (
    SELECT ano
        , br
        , count(*) num_acidentes
    FROM acidentes_por_veiculo
    LEFT JOIN veiculos
    ON acidentes_por_veiculo.id_veiculo = veiculos.id_veiculo
    WHERE tipo_veiculo LIKE 'Autom%'
    -- WHERE tipo_veiculo = 'Automóvel'
    GROUP BY ano, br
), max_acidentes_de_automoveis_por_ano AS (
    SELECT ano
        , max(num_acidentes) AS num_acidentes
    FROM acidentes_de_automoveis_por_ano_por_br
    GROUP BY ano
)

SELECT a.ano AS ano
    , b.br AS br
    , a.num_acidentes AS num_acidentes
FROM max_acidentes_de_automoveis_por_ano AS a
LEFT JOIN acidentes_de_automoveis_por_ano_por_br AS b
ON a.ano = b.ano
AND a.num_acidentes = b.num_acidentes
ORDER BY ano;
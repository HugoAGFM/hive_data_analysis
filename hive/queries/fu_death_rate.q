-- Qual é a unidade federativa com maior taxa de óbitos por número de pessoas envolvida em um acidente

USE transito;

SELECT uf
    ,sum(
    CASE
        WHEN estado_fisico LIKE '%bito' THEN 1
        -- WHEN estado_fisico = 'Óbito' THEN 1
        ELSE 0
    END
    ) AS num_obitos
    , count(*) AS num_pessoas
    ,sum(
    CASE
        WHEN estado_fisico LIKE '%bito' THEN 1
        -- WHEN estado_fisico = 'Óbito' THEN 1
        ELSE 0
    END
    ) / count(*) * 100 AS taxa_de_obitos
FROM acidentes
LEFT JOIN pessoas
ON acidentes.pesid = pessoas.pesid
GROUP by uf
ORDER BY taxa_de_obitos DESC;
-- LIMIT 1;

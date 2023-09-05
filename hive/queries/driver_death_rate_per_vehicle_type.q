-- Qual o tipo de veiculo que proporcionalemnte tem a maior mortalidade para o condutor

USE transito;

WITH condutores_acidentados AS (
    SELECT tipo_veiculo
        , estado_fisico
        , count(*) AS num_condutores_acidentados
    FROM acidentes
    LEFT JOIN veiculos
    ON acidentes.id_veiculo = veiculos.id_veiculo
    LEFT JOIN pessoas
    ON acidentes.pesid = pessoas.pesid
    WHERE tipo_envolvido = 'Condutor'
    GROUP BY tipo_veiculo, estado_fisico
)

SELECT tipo_veiculo
    ,sum(
    CASE
        WHEN estado_fisico LIKE '%bito' THEN num_condutores_acidentados
        -- WHEN estado_fisico = 'Óbito' THEN 1
        ELSE 0
    END
    ) AS num_obitos
    ,sum(num_condutores_acidentados) AS num_condutores_acidentados
    ,sum(
    CASE
        WHEN estado_fisico LIKE '%bito' THEN num_condutores_acidentados
        -- WHEN estado_fisico = 'Óbito' THEN 1
        ELSE 0
    END
    ) / sum(num_condutores_acidentados) * 100 AS taxa_de_fatalidade
FROM condutores_acidentados
GROUP BY tipo_veiculo
ORDER BY taxa_de_fatalidade DESC;
-- LIMIT 1;

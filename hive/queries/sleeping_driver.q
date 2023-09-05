-- Que diferença faz o numero de pessoas no veiculo para casos de acidentes onde o condutor dorme

USE transito;

WITH num_pessoas_no_veiculo AS (
    SELECT id
        , causa_acidente
        ,CASE
            WHEN count(*) > 1 THEN 'Mais de uma'
            ELSE 'Apenas uma'
        END AS quantidade_de_pessoas
    FROM acidentes
    LEFT JOIN pessoas
    ON acidentes.pesid = pessoas.pesid
    WHERE tipo_envolvido IN ('Passageiro', 'Condutor')
    GROUP BY id, causa_acidente
)

SELECT quantidade_de_pessoas AS quantidade_de_pessoas_no_veiculo
    ,sum(
    CASE
        WHEN causa_acidente = 'Condutor Dormindo' THEN 1
        ELSE 0
    END
    ) AS num_acidentes_condutor_dormindo
    , count(*) AS total_acidentes
    ,sum(
    CASE
        WHEN causa_acidente = 'Condutor Dormindo' THEN 1
        ELSE 0
    END
    ) / count(*) * 100 AS taxa_acidentes
FROM num_pessoas_no_veiculo
GROUP BY quantidade_de_pessoas;

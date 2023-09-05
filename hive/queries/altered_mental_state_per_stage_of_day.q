-- Qual a fase do dia onde proporcionalmente ocorre o maior número de acidentes por indestão de alcool ou substancia psicoativa

USE transito;

SELECT fase_dia
    ,sum(
    CASE
        WHEN causa_acidente LIKE 'Ingest%' THEN 1
        ELSE 0
    END
    ) AS num_acidentes
    ,count(*) AS total_de_acidentes
    ,sum(
    CASE
        WHEN causa_acidente LIKE 'Ingest%' THEN 1
        ELSE 0
    END
    ) / count(*) * 100 AS taxa_de_acidentes
FROM (
    SELECT DISTINCT id, fase_dia, causa_acidente FROM acidentes
) AS distinct_acidentes
GROUP BY fase_dia
ORDER BY taxa_de_acidentes DESC;
-- LIMIT 1;
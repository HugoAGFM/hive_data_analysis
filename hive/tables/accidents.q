CREATE EXTERNAL TABLE IF NOT EXISTS transito.acidentes (
    id int
    ,data_inversa string
    ,dia_semana string
    ,horario string
    ,uf string
    ,br string
    ,km int
    ,municipio string
    ,causa_acidente string
    ,tipo_acidente string
    ,classificacao_acidente string
    ,fase_dia string
    ,sentido_via string
    ,condicao_metereologica string
    ,tipo_pista string
    ,tracado_via string
    ,uso_solo string
    ,pesid int
    ,id_veiculo int
)
row format delimited fields terminated by ';'
location '/user/hugomendonca/transito/acidentes'
tblproperties('skip.header.line.count'='1');

ALTER TABLE transito.acidentes SET SERDEPROPERTIES ('serialization.encoding'='LATIN1');
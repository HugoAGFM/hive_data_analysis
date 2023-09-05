CREATE EXTERNAL TABLE IF NOT EXISTS transito.pessoas (
    pesid int
    , tipo_envolvido string
    , estado_fisico string
    , idade int
    , sexo string
)
row format delimited fields terminated by ';'
location '/user/hugomendonca/transito/pessoas'
tblproperties('skip.header.line.count'='1');

ALTER TABLE transito.pessoas SET SERDEPROPERTIES ('serialization.encoding'='LATIN1');
CREATE EXTERNAL TABLE IF NOT EXISTS transito.veiculos (
    id_veiculo int
    , tipo_veiculo string
    , marca string
    , ano_fabricacao_veiculo int
)
row format delimited fields terminated by ';'
location '/user/hugomendonca/transito/veiculos'
tblproperties('skip.header.line.count'='1');

ALTER TABLE transito.veiculos SET SERDEPROPERTIES ('serialization.encoding'='LATIN1');
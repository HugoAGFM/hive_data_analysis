# Brazil Highway Traffic Accidents Data Analysis Using Hive
## Table of contents

- [Introduction](#introduction)
- [About Dataset](#about-dataset)
- [Preparing Environment](#preparing-environment)
- [Analysis](#analysis)
- [Future work](#future-work)

## Introduction

This work proposes to briefly analyze a dataset containing Brazil highway traffic accidents data using Apache Hive.

## About Dataset

The dataset under analysis is available in [kaggle](https://www.kaggle.com/datasets/mcamera/brazil-highway-traffic-accidents) and contains data from Brazil's federal higways between 2007 and 2021 at various levels of granularity. 

The level of granularity chosen was 'accidents per person', and, because there's been  a change in the system used to record these data in 2017, this analysis will be restricted to the period of 2017 to 2021.

### Columns description

Below you can find the columns present in the dataset with a brief description, and how they've been mapped to each table in the data model.

| Coloumn                | Description                                                 | Table             |
| :--------------------- | :---------------------------------------------------------- | :---------------- |
| id                     | ID of accident                                              | Accidents         |
| data_inversa           | Date when accident hapened                                  | Accidents         |
| dia_semana             | Weekday when accident happened                              | Accidents         |
| horario                | Time when accident happened                                 | Accidents         |
| uf                     | Federal Unit where accident happened                        | Accidents         |
| br                     | Highway where accident happened                             | Accidents         |
| km                     | Highway kilometer where accident happened                  | Accidents         |
| municipio              | City where accident happened                                | Accidents         |
| causa_acidente         | Accident cause                                              | Accidents         |
| tipo_acidente          | Accident type                                               | Accidents         |
| classificacao_acidente | Accident classification                                     | Accidents         |
| fase_dia               | Pereiod of the day when  accident happened                  | Accidents         |
| sentido_via            | Lane direction where accident happened                      | Accidents         |
| condicao_metereologica | Weather condition when accident happened                    | Accidents         |
| tipo_pista             | Lane type where accident happened                           | Accidents         |
| tracado_via            | Lane layout where accident happened                         | Accidents         |
| uso_solo               | If the vehicle left the lane in the accident                                   | Accidents         |
| id_veiculo             | ID of vehicle involved in the accident                      | Accidents/Vehicle |
| tipo_veiculo           | Type of the vehicle involved in the accident                | Vehicle           |
| marca                  | Brand of the vehicle involved in the accident               | Vehicle           |
| ano_fabricacao_veiculo | Year of manufacture of the vehicle involved in the accident | Vehicle           |
| pesid                  | ID of person involved in the accident                       | Accidents/People  |
| tipo_envolvido         | Type of person involved in the accident                     | People            |
| estado_fisico          | Physical state of the person involved in the accident       | People            |
| idade                  | Age of the person involved in the accident                  | People            |
| sexo                   | Sex of the person involved in the accident                  | People            |

### Data model

For the purpose of this work and following the instructions of the professor, the dataset was denormalized and modeled as three different tables as described below.w

| Table     | Description                                                                                                             |
| :-------- | :---------------------------------------------------------------------------------------------------------------------- |
| Accidents | Accidents records. Relates to table People through column 'pesid', and with table Vehicles through column 'id_veiculo'. |
| People    | Information about the people involved in the accidents. Relates to the table Accidents through column 'pesid'.           |
| Vehicles  | Information about the veicles involved in the accidents. Relates to the table Accidents thorugh column 'id_veiculo'.                                                |

## Preparing Environment

This session contains all the steps taken to prepare the analytical environment.

**Prerequisites**
- Install terraform and gcloud cli
- Login to gcloud 

**Start a Dataproc cluster using [terraform](./terraform/main.tf)<br>**
> cd terraform <br>
> terraform init --auto-approve

**From terminal in the local machine, connect to the master node<br>**
> cd .. <br>
> PROJECT_ID="neural-land-395722"<br>
> ZONE="us-central1-c"<br>
> <br>
> gcloud beta compute ssh hadoop-cluster-lab-m \ <br>
> --project $PROJECT_ID \ <br>
> --zone $ZONE

**From the master node, create the destination directories for the .csv files<br>**
> mkdir ~/transito \ <br>
> ~/transito/acidentes \ <br>
> ~/transito/veiculos \ <br>
> ~/transito/pessoas <br>

**From the master node, create the destination directories in HDFS<br>**
> hdfs dfs -mkdir /user/\$USER \ <br>
> /user/\$USER/transito \ <br>
> /user/\$USER/transito/acidentes \ <br>
> /user/\$USER/transito/veiculos \ <br>
> /user/\$USER/transito/pessoas <br>

**From a separate terminal in the local machine, transfer dataset to the master node<br>**
> PROJECT_ID="neural-land-395722"  <br>
> ZONE="us-central1-c" <br>
> <br>
> gcloud compute scp ./traffic/accidents.csv \ <br>
> hadoop-cluster-lab-m:/home/hugomendonca/transito/acidentes \ <br>
> --project $PROJECT_ID \ <br>
> --zone $ZONE <br>
> <br>
> gcloud compute scp ./traffic/vehicles.csv \ <br>
> hadoop-cluster-lab-m:/home/hugomendonca/transito/veiculos \ <br>
> --project $PROJECT_ID \ <br>
> --zone $ZONE <br>
> <br>
> gcloud compute scp ./traffic/people.csv \ <br>
> hadoop-cluster-lab-m:/home/hugomendonca/transito/pessoas \ <br>
> --project $PROJECT_ID \ <br>
> --zone $ZONE <br>

**Back to the master node, load files into HDFS<br>**
> hdfs dfs -put /home/hugomendonca/transito/acidentes/\*.csv /user/hugomendonca/transito/acidentes <br>
> hdfs dfs -put /home/hugomendonca/transito/veiculos/\*.csv /user/hugomendonca/transito/veiculos <br>
> hdfs dfs -put /home/hugomendonca/transito/pessoas/\*.csv /user/hugomendonca/transito/pessoas <br>

**From the master node, start Hive and create [database](./hive/databases/) and [tables](./hive/tables/) following the scripts in the linked directories**


## Analysis

This session contains the set of analytical questions elaborated to explore the dataset. Along with each question, there will be the link to queries executed and the results with a brief discussion.

### What is the vehicle type with the highest driver death rate? [query](./hive/queries/driver_death_rate_per_vehicle_type.q)

#### Results

| Vehicle type | Deaths | Accidents | Death rate [%] |
| :----------- | :----: | :-------: | :------------: |
| Quadricycle  |   2    |     9     |     22.22      |
| Bicycle      |  932   |   8787    |     10.60      |
| Wheelbarrow  |   2    |    25     |      8.0       |
| Moped        |  117   |   1661    |      7.04      |
| Motorcycle   |  5626  |  107284   |      5.24      |

#### Discussion

Although the Quadricycle has the highest death rate, due to the low number of occurencies, it is possible to consider that the Bicycle as the vehicle with highest death rate.

### Does the number of people in the vehicle influence the occurrences of accidents where the driver sleeps? [query](./hive/queries/sleeping_driver.q)

#### Results

| Number of people     | Sleeping driver accidents | Total accidents | Rate [%] |
| :------------ | :----------------------------: | :-------------: | :------: |
| Just one      |              5971              |     105690      |   5.64   |
| More than one |              6111              |     215042      |   2.84   |

#### Discussion

When compared to the total number of accidents per number of people in the vehicle, the ones where the driver sleeps happens twice more when there is only one person in the vehicle.

### Which federal unit has the highest death rate by person involved in an accident? [query](./hive/queries/fu_death_rate.q)

#### Results

| Federal Unit | Dead People | Involved People | Death rate [%] |
| :----------- | :---------: | :-------------: | :------------: |
| MA           |    1022     |      14081      |      7.25      |
| AL           |     418     |      7228       |      5.78      |
| TO           |     380     |      6718       |      5.65      |
| BA           |    2284     |      41653      |      5.48      |
| PA           |     647     |      12424      |      5.20      |

#### Discussion

Maranhão is the State with the highest death rate per people involved in an accident. Beyond that, it is important to notice that only States from the North and Northeast regions are in the top 5.

### What is the highway with the highest number of accidents each year? [query](./hive/queries/accidents_per_highway_per_year.q)

#### Results

| Year | Highway | Accidents |
| :--- | :-----: | :-------: |
| 2017 |   101   |   10596   |
| 2018 |   101   |   8095    |
| 2019 |   101   |   7969    |
| 2020 |   101   |   7321    |
| 2021 |   101   |   3735    |

#### Discussion

The biggest highway in the Country, BR 101, is also the one with the highest number of accidents every year. It is important to notice that this number decreased throughout the years.


### What are the stages of the day where an accident involving someone in an altered mental stage is more likely to happen? [query](./hive/queries/altered_mental_state_per_day_stage.q)

#### Results

| Day Stage | Altered mental state accidents | Total accidents | Rate [%] |
| :-------- | :----------------------------: | :-------------: | :------: |
| Night     |             16096              |     111170      |  14.47   |
| Dawn      |              1500              |      15588      |   9.62   |
| Nightfall |              1343              |      17708      |   7.58   |
| Day       |              6965              |     176269      |   3.95   |

#### Discussion

When compared to the total number of accidents, the ones where someone is in an altered menthal state are more likely to happen during the night or dawn.

## Future work

For future work, there are three options to highlight:
1. Enrich dataset with data of public construction in the highways and traffic signaling updates to check if they impacted the accidents throughout the year.
2. Enrich the dataset with weather data throughout the year to analyze how they impact the accidents.
3. Treat data from the period of 2007 to 2016 in an attempt to inlcude it the analysis.

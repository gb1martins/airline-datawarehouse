# Airline Data Warehouse

Projeto de modelagem de dados desenvolvido para simular o ambiente analítico de uma companhia aérea utilizando PostgreSQL.

O projeto contempla desde a modelagem relacional (OLTP) até a construção de um Data Warehouse em Star Schema, incluindo processos ETL e implementação de Slowly Changing Dimensions (SCD).

---

## Objetivos

- Projetar um banco de dados relacional para uma companhia aérea.
- Desenvolver um Data Warehouse orientado à análise.
- Implementar processos ETL utilizando SQL.
- Aplicar conceitos de modelagem dimensional.
- Implementar estratégias de Slowly Changing Dimensions (SCD).

---

## Tecnologias

- PostgreSQL
- SQL
- Data Warehouse
- Star Schema
- Entity Relationship Modeling (ER)
- ETL
- Slowly Changing Dimensions (SCD)

---

## Arquitetura

```

OLTP Database
↓
SQL ETL
↓
Data Warehouse
↓
Star Schema
↓
Analytical Queries

```

---

## Modelagem Relacional (OLTP)

O banco transacional foi modelado utilizando relacionamento entre entidades para representar o domínio de uma companhia aérea.

Principais entidades:

- Passageiro
- Reserva
- Voo
- Aeroporto
- Rota
- Aeronave
- Programa de Fidelidade
- Assento
- Tripulação


---

## Data Warehouse

Foi desenvolvido um modelo dimensional seguindo a arquitetura Star Schema.

### Tabela Fato

- Fato_Reserva

### Dimensões

- Dim_Passageiro
- Dim_Data
- Dim_Voo
- Dim_Aeroporto
- Dim_Classe

---

## ETL

O processo ETL foi implementado utilizando SQL.

As etapas incluem:

- Carga das dimensões
- Atualização das dimensões
- Lookup de chaves substitutas
- Carga da tabela fato

---

## Slowly Changing Dimensions

O projeto utiliza diferentes estratégias de atualização das dimensões.

| Dimensão | Estratégia |
|----------|------------|
| Dim_Data | SCD Tipo 0 |
| Dim_Aeroporto | SCD Tipo 1 |
| Dim_Classe | SCD Tipo 1 |
| Dim_Voo | SCD Tipo 1 |
| Dim_Passageiro | SCD Tipo 2 |

---

## Conceitos Aplicados

- Modelagem Relacional
- Modelagem Dimensional
- Star Schema
- Entity Relationship Diagram (ERD)
- Data Warehouse
- SQL
- ETL
- Surrogate Keys
- Slowly Changing Dimensions
- Primary Keys
- Foreign Keys

---

## Estrutura do Projeto

```

database/
create_db.sql
load_data.sql

datawarehouse/
create_dw.sql

etl/
etl_dimensions.sql
etl_facts.sql

diagrams/
entity-relationship-model.pdf
star-schema.pdf

```

---

## Autor

Gabriel Augusto Martins

LinkedIn: *(coloque seu LinkedIn)*

DROP TABLE person_to_address;

CREATE TABLE person_to_address (
    address_eff_date  DATE,
    person_id         INTEGER,
    address_id        INTEGER NOT NULL
);

-- insert addresses for people --

insert into person_to_address(address_eff_date, person_id, address_id)
SELECT
      TO_DATE(
              TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2018-01-01','J')
                                    ,TO_CHAR(DATE '2020-01-31','J')
                                    )
                    ),'J'
               ),
      person_id,
      address_id
  FROM
           (
          SELECT
              ROWNUM AS pnumm,
              person_id
          FROM
              person
      ) per
      JOIN (
          SELECT
              ROWNUM AS anumm,
              address_id
          FROM
              x_address_unassigned
      ) ON ( pnumm = anumm )
      
      
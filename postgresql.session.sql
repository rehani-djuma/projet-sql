git config global user.name "rehani-djuma"

git config global user.email "rehanimayundo@gmail.com"


-----====analyse de la ressources humaine


alter TABLE ressources alter column performance_score 
type text;
 SELECT *FROM ressources;
---------DATA CLEANING

----------verification des doublons

 SELECT employee_id,
 count(*)from ressources
 group by employee_id
  HAVING count(*)>1;


-----suppression des doublons

   delete from ressources where employee_id = 'EMP1';

   -------verification des cases vides

   select *from ressources WHERE employee_id is NULL or department is NULL
                or salary is NULL or performance_score is NULL
                    or hire_date is NULL or status IS NULL

------mise enjour des details qui manque sur certaines donnee

UPDATE  ressources set employee_id='MP91' where 
 salary='4888.21';

 UPDATE  ressources set employee_id='MP104' where 
 salary='4111.15';

UPDATE ressources SET performance_score='2.6' WHERE  employee_id='MP131'

UPDATE ressources SET status='active' WHERE  employee_id='MP189'
UPDATE ressources SET status='active' WHERE  employee_id='MP104'
       

---------- modification des types des donnees sur les colonne

----pour la colone salary
alter TABLE ressources alter column salary  type numeric(12,2)
using salary::numeric


---pour la colone performence_score
alter TABLE ressources alter column performance_score type numeric(12,2)
using salary::numeric

--------pour la hire_date

alter TABLE ressources alter column hire_date type date
using hire_date::date
 
 

-----veriication de type des donnees de caque colonne


select column_name,data_type
from information_schema.columns
where table_name='ressources';


------------REPONSE AUX QUESTION
=========================================================================
-------1.NIVEAU OPERATIONNEL
====================================================================
 ------nombre total d'employes

 select count (distinct employee_id)as total 
 from ressources

-------les employes actifs

select count(distinct employee_id)as employes_actfs
from ressources where status='Active';

---les employes demissionnes

select count(distinct employee_id)as employes_actfs
from ressources where status='Resigned';

---les employes on leave(qui veulent quitter)

select count(distinct employee_id)as employes_actfs
from ressources where status='On Leave';

-----Répartition des employés par département

SELECT department,
       COUNT(*) AS nb_employees
FROM ressources
GROUP BY department;

------Salaire moyen global

SELECT AVG(salary)
FROM ressources;

-----Salaire moyen par département

SELECT department,
       AVG(salary)
FROM ressources
GROUP BY department;

---------Salaire maximum

SELECT MAX(salary)
FROM ressources;

---------Salaire minimum

SELECT MIN(salary)
FROM ressources;

----------Masse salariale totale

SELECT SUM(salary)
FROM ressources;

-------Performance moyenne

SELECT AVG(performance_score)
FROM ressources;
================================================================
-----------NIVEAU TACTIQUE

-----Ces analyses aident les responsables
-- RH à prendre des décisions à moyen terme.

===============================================================

------Performance moyenne par département

SELECT department,
       AVG(performance_score)
FROM ressources
GROUP BY department;

---------Top 10 employés performants

SELECT *
FROM ressources
ORDER BY performance_score DESC
LIMIT 10;

----Bottom 10 employés

SELECT *
FROM ressources
ORDER BY performance_score ASC
LIMIT 10;


---------Effectif recruté par année

SELECT EXTRACT(YEAR FROM hire_date) AS annee,
       COUNT(*)
FROM ressources
GROUP BY annee
ORDER BY annee;

-----Effectif recruté par mois

SELECT DATE_TRUNC('month',hire_date),
       COUNT(*)
FROM ressources
GROUP BY 1;

------Ancienneté moyenne

SELECT AVG(
CURRENT_DATE - hire_date
)
FROM ressources;

-------Ancienneté par département

SELECT department,
AVG(CURRENT_DATE - hire_date)
FROM ressources
GROUP BY department;

------Départements les plus anciens

select distinct department,
CURRENT_DATE - hire_date from ressources
GROUP BY department,hire_date
order BY department DESC

------Nombre d'employés très performants

SELECT COUNT(*)
FROM ressources
WHERE performance_score >=3.5;
=============================================================

---NIVEAU STRATEGIQUE

-----Taux de rétention

SELECT
ROUND(
COUNT(CASE WHEN status='Active' THEN 1 END)*100.0/
COUNT(*),2)
AS retention_rate
FROM ressourceS;

----Taux de départ

SELECT
ROUND(
COUNT(CASE WHEN status='Inactive' THEN 1 END)*100.0/
COUNT(*),2)
AS turnover_rate
FROM ressources;

-------Masse salariale par département

SELECT department,
SUM(salary)
FROM ressources
GROUP BY department;

---------Part de chaque département dans la masse salariale

SELECT department,
SUM(salary)*100.0/
(SUM(SUM(salary)) OVER())
AS percentage
FROM ressources
GROUP BY department;

---Employés fortement rémunérés mais peu performants


SELECT *
FROM ressources
WHERE salary >
(SELECT AVG(salary) FROM ressource)
AND performance_score <
(SELECT AVG(performance_score) FROM ressources);

-------Employés peu rémunérés mais très performants

SELECT *
FROM ressourceS
WHERE salary <
(SELECT AVG(salary) FROM ressources)
AND performance_score >
(SELECT AVG(performance_score) FROM ressources);

-----Coût moyen par employé

SELECT SUM(salary)/COUNT(*)
FROM ressources;

-----Productivité salariale

SELECT department,
AVG(performance_score)/AVG(salary)
AS productivity_ratio
FROM ressourceS
GROUP BY department;
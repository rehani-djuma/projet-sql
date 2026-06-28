----explotation des donnees pour commencerla netoyage

SELECT *from employes LIMIT 20;
SELECT *from departements LIMIT 20;
SELECT *from performences LIMIT 20;
SELECT *from produits LIMIT 20;
SELECT *from turnover LIMIT 20;

---verification des doublons
==================================
select nom,
count(*) from employes
GROUP BY nom
 HAVING count(*)>1
 ---=======================

 select id_employe,
 count(*)from employes
 GROUP BY id_employe
 HAVING count(*)>1
 ===--------=========================
  ----pour la table departement

select id_departement,
 count(*)from departements
 GROUP BY id_departement
 HAVING count(*)>1
===============================================
 select nom_departement,
 count(*)from departements
 GROUP BY nom_departement
 HAVING count(*)>1
=============================================
 SELECT nom, prenom, date_embauche, COUNT(*) 
FROM employes 
GROUP BY nom, prenom, date_embauche 
HAVING COUNT(*) > 1; 

=---------------========================

-------verification des elements manquants

--------pour la table employes

select *from employes where id_employe is null or
nom is null or prenom is null  or poste is null or departement_id is 
null or  date_embauche is null or date_depart is null 
or salaire is null;

--------effectif des touts les employes

select count(nom)from employes

-------effectif des employes  employes actif
select count (*)as effectif from employes
WHERE date_depart is NULL

----------ajout de la colonne ETAT/statut

alter table employes add column ETAT text

------mise nejour logique de employes actif et deja demisionner

update employes set ETAT=case
when date_depart is null then 'actif' else 'demissionner'
end

--------------ajout de la colonne ancieneter

ALTER TABLE employes 
ADD COLUMN anciennete INT; 

-------mise enjour logique Ancienneté / Tenure des employés 

UPDATE employes 
SET anciennete = EXTRACT
(YEAR FROM AGE(CURRENT_DATE, date_embauche)); 

-------suppression des espace unitile
update employes set
 nom= trim(nom),
 prenom=trim(prenom);

 ---------mise enjour des nom et des prenom en majuscule

 update employes set 
 nom= upper(nom),
 prenom= upper(prenom),
 poste=upper(poste),
 ETAT= upper(ETAT)

 ===----------------------------------------------------------

update departements set
nom_departement=upper(nom_departement),
manager=upper(manager)

============================================================
 ------------verification des cles etrangere

 SELECT p.* 
FROM performances p 
LEFT JOIN employes e ON p.id_employe = e.id_employe 
WHERE e.id_employe IS NULL; 

======================================================
--------data cleaning and preparation pour a table performence

select*from performances LIMIT 10

---------verification des doublons
 SELECT id_performance,
  COUNT(*) 
FROM performances 
GROUP BY id_performance 
HAVING COUNT(*) > 1; 

========-----------------------
=======================================================================
---------- Calcul des KPIs RH & Cohortes

----------- Nombre d’employés actifs et anciens 

SELECT ETAT, COUNT(*) AS nb_employes 
FROM employes 
GROUP BY ETAT

----------Tenure moyenne par département 

SELECT d.nom_departement, ROUND(AVG(e.anciennete),2) AS 
anciennete_moyenne 
FROM employes e 
JOIN departements d ON e.id_employe = d.id_departement 
WHERE e.ETAT = 'ACTIF' 
GROUP BY d.nom_departement 
ORDER BY anciennete_moyenne DESC;

-------------Performance moyenne par cohorte 

-----Montre l’évolution de la performance par cohorte et département. 

SELECT EXTRACT(YEAR FROM date_embauche) AS annee_embauche, 
COUNT(*) FILTER (WHERE ETAT = 'DEMISSIONNER') AS nb_sortants, 
COUNT(*) AS nb_total, 
ROUND((COUNT(*) FILTER (WHERE ETAT = 
'DEMISSIONER')*100.0)/COUNT(*),2) AS turnover_pourcentage 
FROM employes 
GROUP BY annee_embauche 
ORDER BY annee_embauche; 

---------Top 5 départements selon performance 

--------Permet d’identifier les départements les plus performants. 

SELECT d.nom_departement, ROUND(AVG(p.score),2) AS perf_moyenne 
FROM employes e 
JOIN departements d ON e.id_employe = d.id_departement 
JOIN performances p ON e.id_employe = p.id_employe 
GROUP BY d.nom_departement 
ORDER BY perf_moyenne DESC 
LIMIT 5; 


================================================================

-- Cohortes et segmentation 
-- ● Cohortes par année d’embauche : comparer la rétention et la performance. 
-- ● Cohortes par ancienneté : créer des groupes “junior / intermédiaire / senior” pour 
-- analyser les KPIs. 

ALTER TABLE employes 
ADD COLUMN niveau_seniorite TEXT; 
UPDATE employes 
SET niveau_seniorite = CASE 
WHEN anciennete < 3 THEN 'Junior' 
WHEN anciennete BETWEEN 3 AND 6 THEN 'Intermédiaire' 
ELSE 'Senior' 
END;

---Ces colonnes facilitent les filtres et l’analyse segmentée. 
=============================================================

==========================================================
--------- Analyse de la performance par cohorte
SELECT d.nom_departement, 
EXTRACT(YEAR FROM e.date_embauche) AS annee_embauche, 
ROUND(AVG(p.score),2) AS performance_moyenne 
FROM employes e 
JOIN departements d ON e.id_employe= d.id_departement 
JOIN performances p ON e.id_employe = p.id_employe 
WHERE e.ETAT ='ACTIF' 
GROUP BY d.nom_departement, annee_embauche 
ORDER BY performance_moyenne DESC; 
======--Analyse si les départements avec un turnover élevé ont aussi une performance 
--moyenne plus faible. 



SELECT *from employes LIMIT 110;

SELECT *from employes WHERE id_employe is NULL or
nom IS NULL or prenom is NULL or poste is NULL or date_depart
is NULL or date_embauche is NULL or salaire is NULL;

SELECT  count(*)from employes WHERE id_employe is NULL or
nom IS NULL or prenom is NULL or poste is NULL or date_depart
is NULL or date_embauche is NULL or salaire is NULL;

selct
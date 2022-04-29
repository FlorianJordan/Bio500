##### Working directory ####
#getwd()
#setwd()
#
#pour flo: setwd("~/Desktop/dossier_mere/universite/Session_6/method_comp/Bio500")
#pour frank: setwd("C:/Users/Francis/Desktop/BIO500/Bio500/donnees_BIO500")
#pour marge: setwd("C:\Users\margu\Documents\Bio500\donnees_BIO500")

#À ajouter dans le script de fonction pour effectuer plusieurs tar_make de suite
dbSendQuery(con,"DROP TABLE collaborations;")
dbSendQuery(con,"DROP TABLE noeuds;")
dbSendQuery(con,"DROP TABLE cours;")
dbSendQuery(con,"DROP TABLE collaborations_dif;")
dbSendQuery(con,"DROP TABLE collaborations_nontsb;")
dbSendQuery(con,"DROP TABLE collaborations_nontsb_dif;")

#install.packages("dplyr")
library(dplyr)
#install.packages("RSQLite")
library(RSQLite)
#install.packages("targets")
library(targets)
#install.packages("igraph")
library(igraph)

#### Suggestion de questions ####
#À quel point les élèves gardent les même équipes?
#Combien de collaborations différentes par élèves/La moyenne de collaboration par élève
#Pour la question précédente, on pourrait éliminer les travaux à 15 personnes vu que l'effort n'est pas vraiment comparable
#Quel est le degré le plus élevé entre les élèves? Combien d'élèves ont se degré? Le degré le plus élevé est 
#induit par combien d'élève?

#Est-ce que les étudiants ont plus tendance à faire des collab ensemble lorsqu'ils sont dans le même programme?
#Est-ce que les étudiants ont plus tendance à faire des collab ensemble lorsqu'ils sont en programme coop?


#Est-ce que les étudiants ont plus tendance à faire des collabs ensemble lorsqu'ils sont dans le même programme?
#Est-ce que les étudiants ont plus tendance à faire des collabs ensemble lorsqu'ils proviennent de la même cohorte?
#Est-ce que les étudiants ont plus tendance à faire des collabs ensemble lorsqu'ils sont en programme coop?
#Est-ce que les étudiants ont plus tendance à garder les mêmes équipes lorsque le choix des coéquipiers est libre?

##### Chercher les données #####

#Lecture des fichiers bruts de noeuds
noeuds_amelie<-read.csv("data/noeuds_amelie.csv", sep=";")
noeuds_anthonystp<-read.table("data/noeuds_anthonystp .txt",header = T,sep=";")
noeuds_cvl<-read.csv("data/noeuds_cvl_jl_jl_mp_xs.csv", sep=";")
noeuds_dp<-read.csv("data/noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")
noeuds_fxc<-read.table("data/noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")
noeuds_jbca<-read.table("data/noeuds_jbcaldlvjlgr.txt",header = T,sep=";")
noeuds_martineau<-read.table("data/noeuds_martineau.txt",header = T,sep=";")
noeuds_alexis<-read.table("data/etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
noeuds_ilmdph<-read.table("data/etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

#Lecture des fichiers bruts de cours
cours_amelie<-read.csv("data/cours_amelie.csv", sep=";")
cours_anthonystp<-read.table("data/cours_anthonystp.txt",header = T,sep=";")
cours_cvl<-read.csv("data/cours_cvl_jl_jl_mp_xs.csv", sep=";")
cours_dp<-read.csv("data/cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")
cours_fxc<-read.table("data/cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")
cours_jbca<-read.table("data/cours_jbcaldlvjlgr.txt",header = T,sep=";")
cours_martineau<-read.table("data/cours_martineau.txt",header = T,sep=";")
cours_alexis<-read.table("data/Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
cours_ilmdph<-read.table("data/cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

#Lecture des fichers bruts de collaborations
collaborations_amelie<-read.csv("data/collaborations_amelie.csv", sep=";")
collaborations_anthonystp<-read.table("data/collaborations_anthonystp.txt",header = T, sep=";")
collaborations_cvl<-read.csv("data/collaborations_cvl_jl_jl_mp_xs.csv", sep=";")
collaborations_dp<-read.csv("data/collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")
collaborations_fxc<-read.table("data/collaborations_FXC_MF_TC_LRT_WP..txt",header = T, sep="")
collaborations_jbca<-read.table("data/collaborations_jbcaldlvjlgr.txt",header = T, sep=";")
collaborations_martineau<-read.table("data/collaborations_martineau.txt",header = T, sep=";")
collaborations_alexis<-read.table("data/collaboration_Alexis_Nadya_Edouard_Penelope.txt",header = T, sep="")
collaborations_ilmdph<-read.table("data/collaborations_IL_MDH_ASP_MB_OL.txt",header = T, sep=";")

##### Enlever les colonnes en trop pour certains fichiers bruts ####

cours_amelie<-cours_amelie[,-c(6:7)]
cours_anthonystp<-cours_anthonystp[,-5]
collaborations_ilmdph<-collaborations_ilmdph[,-5]
collaborations_dp<-collaborations_dp[,-5]
noeuds_cvl<-noeuds_cvl[,-1]

##### Corretion des noms de colonne #####

cours_cvl<-rename(cours_cvl,sigle=Sigle)
cours_fxc<-rename(cours_fxc,credits=credit)

collaborations_amelie<-rename(collaborations_amelie,sigle=cours)
collaborations_anthonystp<-rename(collaborations_anthonystp,sigle=cours)
collaborations_cvl<-rename(collaborations_cvl,sigle=cours)
collaborations_dp<-rename(collaborations_dp,sigle=cours)
collaborations_martineau<-rename(collaborations_martineau,sigle=cours)

colnames(noeuds_amelie)<-c("nom_prenom","annee_debut","session_debut","programme","coop")
colnames(collaborations_amelie)<-c("etudiant1","etudiant2","sigle","date")
colnames(cours_amelie)<-c("sigle","credits","obligatoire","laboratoire","libre")

##### Fusionner les fichiers bruts####

data_noeuds<-bind_rows(noeuds_amelie,noeuds_anthonystp,noeuds_cvl,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)
data_noeuds
data_cours<-bind_rows(cours_amelie,cours_anthonystp,cours_cvl,cours_dp,cours_fxc,cours_jbca,cours_martineau,cours_alexis,cours_ilmdph)
data_cours
data_collaborations<-bind_rows(collaborations_amelie,collaborations_anthonystp,collaborations_cvl,collaborations_dp,collaborations_fxc,collaborations_jbca,collaborations_martineau,collaborations_alexis,collaborations_ilmdph)
data_collaborations

#### Enlever les doublons ####

cours<-data_cours[!duplicated(data_cours$sigle),] #Enlever les lignes contenant le même sigle qu'une ligne supérieure
cours


collaborations<-distinct(data_collaborations) #Enlever les lignes pareilles à une ligne supérieure
collaborations

data_noeuds<-data_noeuds %>% arrange(rowSums(is.na(data_noeuds))) #Placer les lignes ayant le moins de NA en haut du data frame
noeuds<-data_noeuds[!duplicated(data_noeuds$nom_prenom),] #Enlever les lignes ayant le même nom_prenom qu'une ligne supérieure
noeuds

#### Enlever les anciennes tables SQL ####

con<-dbConnect(SQLite(),dbname="attributs.db")
dbSendQuery(con,"DROP TABLE collaborations;")
dbSendQuery(con,"DROP TABLE noeuds;")
dbSendQuery(con,"DROP TABLE cours;")

#### Création des tables SQL ####  

tbl_noeuds <- "
CREATE TABLE noeuds (
  nom_prenom      VARCHAR(50),
  annee_debut      DATE(4),
  session_debut CHAR(1),
  programme       VARCHAR(20),
  coop        BOOLEAN(1),
  PRIMARY KEY (nom_prenom)
);"
dbSendQuery(con, tbl_noeuds)

tbl_cours <- "
CREATE TABLE cours (
sigle   CHAR(6) NOT NULL,
credits       INTEGER(1) ,
obligatoire     BOOLEAN(1),
laboratoire       BOOLEAN(1),
distance   BOOLEAN(1),
groupes   BOOLEAN(1),
libre   BOOLEAN(1),
PRIMARY KEY (sigle)
);"
dbSendQuery(con, tbl_cours)

tbl_collaborations <- "
CREATE TABLE collaborations (
  etudiant1     VARCHAR(50),
  etudiant2     VARCHAR(50),
  sigle   CHAR(6),
  date    DATE(3),
  PRIMARY KEY (etudiant1, etudiant2, sigle, date),
  FOREIGN KEY (etudiant1) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (etudiant2) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (sigle) REFERENCES cours(sigle)
);"
dbSendQuery(con, tbl_collaborations)
dbListTables(con) #Vérifier l'ajout des tables


dbWriteTable(con, append = TRUE, name = "noeuds", value = noeuds, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "cours", value = cours, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = collaborations, row.names = FALSE)

#Nombre de collaborations par étudiant
sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens <- dbGetQuery(con,sql_requete)
liens

#Nombre de collaborations par paire d'étudiants
sql_requete2 <- "
SELECT etudiant1, etudiant2, count(sigle) as liens
FROM collaborations
GROUP BY etudiant1, etudiant2
ORDER BY liens DESC
"
liens_paire <- dbGetQuery(con,sql_requete2)
liens_paire

#### Calcul de paramètres des liens ####

mean(liens$liens) #Moyenne du nombre de collaborations par étudiant
var(liens$liens) #Variance du nombre de collaborations par étudiant

#### Réseau de base ####

m_adj<-table(collaborations$etudiant1,collaborations$etudiant2) #Matrice d'adjacence de tous les étudiants
m_adj

deg<-apply(m_adj, 2, sum) + apply(m_adj, 1, sum)
rk<-rank(deg)
col.vec<-rev(heat.colors(nrow(m_adj))) #Création du vecteur pour la couleur des noeuds
adj<-graph.adjacency(m_adj) #Création du réseau avec tous les étudiants
V(adj)$color = col.vec[rk] #Ajout de la couleurs des noeuds
col.vec<-seq(10, 80, length.out = nrow(m_adj)) #Création du vecteur pour la taille des noeuds
V(adj)$size = col.vec[rk] #Ajout de la taille des noeuds
adj2<-simplify(adj) #Enlever les liens parallèles
#Fonction pour la largeur des liens
E(adj2)$weight = sapply(E(adj2), function(e) { 
  length(all_shortest_paths(adj, from=ends(adj2, e)[1], to=ends(adj2, e)[2])$res) } )

#Création du graphique pour le réseau contenant tous les étudiants
plot(adj2, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), edge.width=E(adj2)$weight*0.5, asp=0.9)

#### Enlever TSB303 ####

#Prélever toutes les collaborations sauf celle provenant du cours TSB303
sql_requete3 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"
collab_nontsb<-dbGetQuery(con,sql_requete3)

#Nombre de collaborations par étudiant sans les collaborations du cours TSB303
sql_requete_liens <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
GROUP BY etudiant
ORDER BY liens
"
liens_nontsb <- dbGetQuery(con,sql_requete_liens)
liens_nontsb

mean(liens_nontsb$liens) #Moyenne du nombre de collaborations par étudiant sans les collaborations du cours TSB303

#Collaboration du cours TSB303
sql_requete_tsb <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle LIKE '%TSB303%'
"
collab_tsb<-dbGetQuery(con,sql_requete_tsb)

#Programme de chaque étudiant
sql_requete_prog <- "
SELECT nom_prenom,programme
FROM noeuds
"
prog<-dbGetQuery(con,sql_requete_prog)

#Code de couleur pour les programmes
col<-data.frame(programme=unique(prog$programme),color=c("green","yellow","yellow","yellow","yellow","yellow","yellow","yellow"))
prog$color<-col$color[match(prog$programme, col$programme)]

m_adj_nontsb<-table(collab_nontsb$etudiant1,collab_nontsb$etudiant2) #Matrice d'adjacence pour le réseau sans TSB303
m_adj_tsb<-table(collab_tsb$etudiant1,collab_tsb$etudiant2) #Matrice d'adjacence pour le réseau du cours TSB303

adj_nontsb<-graph.adjacency(m_adj_nontsb) #Créatiom du réseau sans TSB303 
adj_tsb<-graph.adjacency(m_adj_tsb) #Création du réseau du cours TSB303

V(adj_nontsb)$color = prog$color #Ajout de la couleur des noeuds
V(adj_nontsb)$size = 40 #Taille des noeuds
vertex_attr(adj_nontsb)
adj_nontsb<-simplify(adj_nontsb) #Enlever les liens parallèles

par(mfrow=c(1,2))
#Création du graphique pour le réseau sans TSB303
plot(adj_nontsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_nontsb), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), asp=0.9)

#Graphique du résau du cours TSB303 #Pas utilisé
#V(adj_tsb)$color = prog$color
#vertex_attr(adj_tsb)
#V(adj_tsb)$size = 40
#adj_tsb<-simplify(adj_tsb)
#E(adj_tsb)$color = "black"

#plot(adj_tsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_tsb), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), edge.width = 2)

#Grapique du réseau de base mettant en évidence les collaboration du cours TSB303
adj3<-graph.adjacency(m_adj) #Création d'une copie du réseau de base
V(adj3)$color = prog$color #Ajout de la couleur des noeuds
V(adj3)$size = 40 #Taille des noeuds
adj3<-simplify(adj3) #enlever les liens parallèles

edge_tsb<-as.data.frame(get.edgelist(adj_tsb)) #Liste des collaborations du cours TSB303
edge_tsb$color<- "black" #Ajout du code de couleur pour les liens
edge_tsb$width<-2 #Ajout du code pour la taille des liens

edge_nontsb<-as.data.frame(get.edgelist(adj_nontsb)) #Liste des collaborations sans TSB303
edge_nontsb$color<- "gray" #Ajout du code de couleur pour les liens
edge_nontsb$width<-1 #Ajout sdu code pour la taille des liens

edge_tot<-as.data.frame(get.edgelist(adj3)) #Data frame des collaboration du réseau de base
edge_tot<-bind_rows(edge_nontsb,edge_tsb) #Ajout de la couleur et la largeur des liens dans le data frame
edge_tot<-edge_tot %>% distinct(V1, V2, .keep_all = TRUE) #Enlever les lignes dupliquées

E(adj3)$color = edge_tot$color #Ajout de la couleur des liens
E(adj3)$width = edge_tot$width #Ajout de la taille des liens
edge_attr(adj3)

#Création du graphique du réseau de base mettant en évidence les collaboration du cours TSB303
plot(adj3, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), asp=0.9)

#### Réseau des étudiants ayant plus de 30 collaborations ####

liens30<-liens[liens$liens>=30,] #Liste des étudiant ayant plus de 30 collaborations

#Création du data frame contenant les collaborations entre les gens ayant plus de 30 collaborations
sql_requete4 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE (etudiant1 LIKE '%robert_penelope%' OR etudiant1 LIKE '%gregoire_simon%' OR etudiant1 LIKE '%quevillon_vincent%' OR etudiant1 LIKE '%saintpierre_anthony%' OR etudiant1 LIKE '%poulin_william%' OR etudiant1 LIKE '%prevosto_clara%' OR etudiant1 LIKE '%martineau_alexandre%' OR etudiant1 LIKE '%duchesne_marguerite%' OR etudiant1 LIKE '%jordan_florian%' OR etudiant1 LIKE '%lacroix_guillaume%' OR etudiant1 LIKE '%lepage_jeremi%' OR etudiant1 LIKE '%roy_elisabeth%' OR etudiant1 LIKE '%beland_laura%' OR etudiant1 LIKE '%beliveau_lauralie%' OR etudiant1 LIKE '%boum_laurence%' OR etudiant1 LIKE '%perron_maxime%' OR etudiant1 LIKE '%racine_gabrielle%' OR etudiant1 LIKE '%barbeau_juliette%' OR etudiant1 LIKE '%dhamelin_maili%' OR etudiant1 LIKE '%laurie_veldonjames%' OR etudiant1 LIKE '%nadonbeaumier_edouard%' OR etudiant1 LIKE '%stamant_xavier%' OR etudiant1 LIKE '%beaubien_marie%' OR etudiant1 LIKE '%langlois_claudieanne%' OR etudiant1 LIKE '%saintpierre_audreyann%' OR etudiant1 LIKE '%lalonde_daphnee%' OR etudiant1 LIKE '%lessard_martin%' OR etudiant1 LIKE '%matte_alexis%' OR etudiant1 LIKE '%tardy_nadia%' OR etudiant1 LIKE '%leclerc_olivier%' OR etudiant1 LIKE '%bergeron_amelie%' OR etudiant1 LIKE '%lefebvre_isabelle%' OR etudiant1 LIKE '%lavoie_alissandre%' OR etudiant1 LIKE '%lenneville_jordan%' OR etudiant1 LIKE '%plewinski_david%' OR etudiant1 LIKE '%dufour_melodie%' OR etudiant1 LIKE '%amyot_audreyanne%' OR etudiant1 LIKE '%berthiaume_elise%') AND (etudiant2 LIKE '%robert_penelope%' OR etudiant2 LIKE '%gregoire_simon%' OR etudiant2 LIKE '%quevillon_vincent%' OR etudiant2 LIKE '%saintpierre_anthony%' OR etudiant2 LIKE '%poulin_william%' OR etudiant2 LIKE '%prevosto_clara%' OR etudiant2 LIKE '%martineau_alexandre%' OR etudiant2 LIKE '%duchesne_marguerite%' OR etudiant2 LIKE '%jordan_florian%' OR etudiant2 LIKE '%lacroix_guillaume%' OR etudiant2 LIKE '%lepage_jeremi%' OR etudiant2 LIKE '%roy_elisabeth%' OR etudiant2 LIKE '%beland_laura%' OR etudiant2 LIKE '%beliveau_lauralie%' OR etudiant2 LIKE '%boum_laurence%' OR etudiant2 LIKE '%perron_maxime%' OR etudiant2 LIKE '%racine_gabrielle%' OR etudiant2 LIKE '%barbeau_juliette%' OR etudiant2 LIKE '%dhamelin_maili%' OR etudiant2 LIKE '%laurie_veldonjames%' OR etudiant2 LIKE '%nadonbeaumier_edouard%' OR etudiant2 LIKE '%stamant_xavier%' OR etudiant2 LIKE '%beaubien_marie%' OR etudiant2 LIKE '%langlois_claudieanne%' OR etudiant2 LIKE '%saintpierre_audreyann%' OR etudiant2 LIKE '%lalonde_daphnee%' OR etudiant2 LIKE '%lessard_martin%' OR etudiant2 LIKE '%matte_alexis%' OR etudiant2 LIKE '%tardy_nadia%' OR etudiant2 LIKE '%leclerc_olivier%' OR etudiant2 LIKE '%bergeron_amelie%' OR etudiant2 LIKE '%lefebvre_isabelle%' OR etudiant2 LIKE '%lavoie_alissandre%' OR etudiant2 LIKE '%lenneville_jordan%' OR etudiant2 LIKE '%plewinski_david%' OR etudiant2 LIKE '%dufour_melodie%' OR etudiant2 LIKE '%amyot_audreyanne%' OR etudiant2 LIKE '%berthiaume_elise%')
"
collabs30<-dbGetQuery(con,sql_requete4)

m_adj_30<-table(collabs30$etudiant1,collabs30$etudiant2) #Matrice d'ajacence des étudiants ayant plus de 30 collaborations

deg_30<-apply(m_adj_30, 2, sum) + apply(m_adj_30, 1, sum)
rk_30<-rank(deg_30)
col.vec_30<-rev(topo.colors(nrow(m_adj_30))) #Création du vecteur pour le code de couleur des noeuds
adj_30<-graph.adjacency(m_adj_30) #Création du réseau des étudiants ayant plus de 30 collaborations
V(adj_30)$color = col.vec_30[rk_30] #Ajout de la couleur des noeuds
col.vec_30<-seq(30, 50, length.out = nrow(m_adj_30)) #Création du vecteur de la taille des noeuds
V(adj_30)$size = col.vec_30[rk_30] #Ajout de la taille des noeuds
V(adj_30)$label.cex = 0.6 #Diminution de la taille des étiquettes
adj_30_2<-simplify(adj_30) #Enlever les liens parallèles
#Fonction pour la largeur des liens
E(adj_30_2)$weight = sapply(E(adj_30_2), function(e) { 
  length(all_shortest_paths(adj_30, from=ends(adj_30_2, e)[1], to=ends(adj_30_2, e)[2])$res) } )

par(mfrow=c(1,1))
#Création du graphique du réseau des étudiants ayant plus de 30 collaborations
plot(adj_30_2, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_30), rescale=FALSE, ylim=c(-4,4), xlim=c(-4,4), edge.width=E(adj_30_2)$weight*0.5, asp=0.9)

#### nombre de collabs différentes ####

#Enlever les tableaux précédemment créés
dbSendQuery(con,"DROP TABLE collaborations_dif;")
dbSendQuery(con,"DROP TABLE collaborations_nontsb_dif;")
dbSendQuery(con,"DROP TABLE collaborations_nontsb;")

#Création d'un nouveau tableau contenant uniquement les collaborations différentes des étudiants
sql_requete5 <- "
CREATE TABLE collaborations_dif AS 
  SELECT DISTINCT etudiant1,etudiant2
  FROM collaborations
"
dbExecute(con,sql_requete5)
dbListTables(con) #Vérifier l'ajout des tables

#Création d'un tableau contenant toutes les collaborations sauf pour le cours TSB303
sql_requete5_1 <- "
CREATE TABLE collaborations_nontsb AS 
  SELECT etudiant1,etudiant2,sigle,date
  FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"
dbExecute(con,sql_requete5_1)
dbListTables(con) #Vérifier l'ajout des tables

#Création d'un tableau contenant uniquement les collaborations différentes des étudiants sans les collaborations de TSB303
sql_requete5_2 <- "
CREATE TABLE collaborations_nontsb_dif AS 
  SELECT DISTINCT etudiant1,etudiant2
  FROM collaborations_nontsb
"
dbExecute(con,sql_requete5_2)
dbListTables(con) #Vérifier l'ajout des tables

#Création d'un data frame des collaborations différentes par étudiant
sql_requete6 <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens_dif
  FROM collaborations_dif
  GROUP BY etudiant
  ORDER BY liens_dif
"
liens_dif <- dbGetQuery(con,sql_requete6)
liens_dif

mean(liens_dif$liens_dif) #Moyenne des collaborations différentes par étudiant

#Création d'un data frame des collaborations différentes par étudiant sans TSB303
sql_requete6_1 <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens_dif
  FROM collaborations_nontsb_dif
  GROUP BY etudiant
  ORDER BY liens_dif
"
liens_nontsb_dif <- dbGetQuery(con,sql_requete6_1)
liens_nontsb_dif

mean(liens_nontsb_dif$liens_dif) #Moyenne des collaborations différentes par étudiant sans TSB303

par(mfrow=c(2,2))
#Histogrammes des collaborations totales et différentes, avec ou sans TSB303
hist(liens$liens, xlab = "Collaborations par étudiant", ylab = "Fréquence", main = "a)")
hist(liens_dif$liens_dif, xlab = "Collaborations différentes par étudiant", ylab = "Fréquence", main = "b)")
hist(liens_nontsb$liens, xlab = "Collaborations par étudiant (sans TSB303)", ylab = "Fréquence", main = "c)")
hist(liens_nontsb_dif$liens_dif, xlab = "Collaborations différentes par étudiant (sans TSB303)", ylab = "Fréquence", main = "d)")

#Graphique du réseau des collaborations différents #Pas utilisé
#sql_requete7 <- "
#SELECT etudiant1, etudiant2
#FROM collaborations_dif
#"
#collabs_dif<-dbGetQuery(con,sql_requete7)

#m_adj_dif<-table(collabs_dif$etudiant1,collabs_dif$etudiant2)

#adj_dif<-graph.adjacency(m_adj_dif)
#plot(adj_dif,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### progression du réseau ####Pas utilisé
#### 2014 ####Pas utilisé

#sql_requete8 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%'
#"
#collab_14<-dbGetQuery(con,sql_requete8)

#m_adj_14<-table(collab_14$etudiant1,collab_14$etudiant2)

#adj_14<-graph.adjacency(m_adj_14)
#plot(adj_14,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### 2017 ####Pas utilisé

#sql_requete9 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%' OR date LIKE '%H17%'
#"
#collab_17<-dbGetQuery(con,sql_requete9)

#m_adj_17<-table(collab_17$etudiant1,collab_17$etudiant2)

#adj_17<-graph.adjacency(m_adj_17)
#plot(adj_17,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### 2018 ####Pas utilisé

#sql_requete10 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%' OR date LIKE '%H17%' OR date LIKE '%A17%' OR date LIKE '%E18%'
#"
#collab_18<-dbGetQuery(con,sql_requete10)

#m_adj_18<-table(collab_18$etudiant1,collab_18$etudiant2)

#adj_18<-graph.adjacency(m_adj_18)
#plot(adj_18,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### 2019 ####Pas utilisé

#sql_requete11 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%' OR date LIKE '%H17%' OR date LIKE '%A17%' OR date LIKE '%E18%' OR date LIKE '%H19%'
#"
#collab_19<-dbGetQuery(con,sql_requete11)

#m_adj_19<-table(collab_19$etudiant1,collab_19$etudiant2)

#adj_19<-graph.adjacency(m_adj_19)
#plot(adj_19,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### 2020 ####Pas utilisé

#sql_requete12 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%' OR date LIKE '%H17%' OR date LIKE '%A17%' OR date LIKE '%E18%' OR date LIKE '%H19%' OR date LIKE '%A19%' OR date LIKE '%H20%' OR date LIKE '%E20%'
#"
#collab_20<-dbGetQuery(con,sql_requete12)

#m_adj_20<-table(collab_20$etudiant1,collab_20$etudiant2)

#adj_20<-graph.adjacency(m_adj_20)
#plot(adj_20,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### 2021 ####Pas utilisé

#sql_requete13 <- "
#SELECT etudiant1,etudiant2,sigle,date
#FROM collaborations WHERE date LIKE '%H14%' OR date LIKE '%H17%' OR date LIKE '%A17%' OR date LIKE '%E18%' OR date LIKE '%H19%' OR date LIKE '%A19%' OR date LIKE '%H20%' OR date LIKE '%E20%' OR date LIKE '%A20%' OR date LIKE '%H21%' OR date LIKE '%E21%'
#"
#collab_21<-dbGetQuery(con,sql_requete13)

#m_adj_21<-table(collab_21$etudiant1,collab_21$etudiant2)

#adj_21<-graph.adjacency(m_adj_21)
#plot(adj_21,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### cours labo vs theorie ####Pas utilisé

#sql_requete14 <- "
#SELECT etudiant1,etudiant2,sigle,date,laboratoire
#FROM collaborations
#INNER JOIN cours USING (sigle)
#"
#collab_cours<-dbGetQuery(con,sql_requete14)

#collab_theo<-collab_cours[collab_cours$laboratoire==0,]

#m_adj_theo<-table(collab_theo$etudiant1,collab_theo$etudiant2)

#adj_theo<-graph.adjacency(m_adj_theo)
#plot(adj_theo,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#collab_labo<-collab_cours[collab_cours$laboratoire==1,]

#m_adj_labo<-table(collab_labo$etudiant1,collab_labo$etudiant2)

#adj_labo<-graph.adjacency(m_adj_labo)
#plot(adj_labo,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA)

#### collaborations ecologie ####Pas utilisé

#sql_requete15 <- "
#SELECT collaborations.etudiant1,noeuds1.programme as programme1,collaborations.etudiant2,noeuds2.programme as programme2,collaborations.sigle,collaborations.date
#FROM collaborations
#INNER JOIN noeuds noeuds1 ON collaborations.etudiant1=noeuds1.nom_prenom
#INNER JOIN noeuds noeuds2 ON collaborations.etudiant2=noeuds2.nom_prenom
#"
#collab_prog<-dbGetQuery(con,sql_requete15)

#collab_eco<-collab_prog[collab_prog$programme1=="ecologie",]
#collab_eco<-collab_eco[collab_eco$programme2=="ecologie",]

#m_adj_eco<-table(collab_eco$etudiant1,collab_eco$etudiant2)

#adj_eco<-graph.adjacency(m_adj_eco)
#plot(adj_eco,vertex.label = NA, edge.arrow.mode = 0,vertex.frame.color = NA, layout=layout.kamada.kawai(adj_eco))

###########

library(targets)

tar_option_set(packages = c("RSQLite","igraph","dplyr"))

source("R/fonctions.R")
list(
  #Donnee noeud
  tar_target(noeuds_amelie,read.csv("data/noeuds_amelie.csv", sep=";")),
  tar_target(noeuds_anthonystp,read.table("data/noeuds_anthonystp .txt",header = T,sep=";")),
  tar_target(noeuds_cvl,read.csv("data/noeuds_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(noeuds_dp,read.csv("data/noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(noeuds_fxc,read.table("data/noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")),
  tar_target(noeuds_jbca,read.table("data/noeuds_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(noeuds_martineau,read.table("data/noeuds_martineau.txt",header = T,sep=";")),
  tar_target(noeuds_alexis,read.table("data/etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(noeuds_ilmdph,read.table("data/etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  #Donnee cours
  tar_target(cours_amelie,read.csv("data/cours_amelie.csv", sep=";")),
  tar_target(cours_anthonystp,read.table("data/cours_anthonystp.txt",header = T,sep=";")),
  tar_target(cours_cvl,read.csv("data/cours_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(cours_dp,read.csv("data/cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(cours_fxc,read.table("data/cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")),
  tar_target(cours_jbca,read.table("data/cours_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(cours_martineau,read.table("data/cours_martineau.txt",header = T,sep=";")),
  tar_target(cours_alexis,read.table("data/Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(cours_ilmdph,read.table("data/cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  #Donnee collaborations
  
  tar_target(collaborations_amelie,read.csv("data/collaborations_amelie.csv", sep=";")),
  tar_target(collaborations_anthonystp,read.table("data/collaborations_anthonystp.txt",header = T, sep=";")),
  tar_target(collaborations_cvl,read.csv("data/collaborations_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(collaborations_dp,read.csv("data/collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(collaborations_fxc,read.table("data/collaborations_FXC_MF_TC_LRT_WP..txt",header = T, sep=";")),
  tar_target(collaborations_jbca,read.table("data/collaborations_jbcaldlvjlgr.txt",header = T, sep=";")),
  tar_target(collaborations_martineau,read.table("data/collaborations_martineau.txt",header = T, sep=";")),
  tar_target(collaborations_alexis,read.table("data/collaboration_Alexis_Nadya_Edouard_Penelope.txt",header = T, sep=";")),
  tar_target(collaborations_ilmdph,read.table("data/collaborations_IL_MDH_ASP_MB_OL.txt",header = T, sep=";")),
  
  #correction d'erreure
  
  tar_target(cours_amelie_corrige,fonction_cours_amelie(cours_amelie)),
  tar_target(cours_anthonystp_corrige,fonction_cours_anthonystp(cours_anthonystp)),
  tar_target(collaborations_ilmdph_corrige,fonction_collaborations_ilmdph(collaborations_ilmdph)),
  tar_target(collaborations_dp_corrige,fonction_collaborations_dp(collaborations_dp)),
  tar_target(noeuds_cvl_corrige,fonction_noeuds_cvl(noeuds_cvl)),
  
  tar_target(cours_cvl_corrige,fonction_cours_cvl(cours_cvl)),
  tar_target(cours_fxc_corrige,fonction_cours_fxc(cours_fxc)),
  tar_target(collaborations_amelie_corrige,fonction_collaborations_amelie(collaborations_amelie)),
  tar_target(collaborations_anthonystp_corrige,fonction_collaborations_anthonystp(collaborations_anthonystp)),
  tar_target(collaborations_cvl_corrige,fonction_collaborations_cvl(collaborations_cvl)),
  tar_target(collaborations_dp_corrige2,fonction_collaborations_dp(collaborations_dp)),
  tar_target(collaborations_martineau_corrige,fonction_collaborations_martineau(collaborations_martineau)),
  tar_target(noeuds_amelie_corrige,fonction_noeuds_amelie(noeuds_amelie)),
  tar_target(collaborations_amelie_corrige2,fonction_collaborations_amelie_col(collaborations_amelie_corrige)),
  tar_target(cours_amelie_corrige2,fonction_cours_amelie_col(cours_amelie_corrige)),
  
  # Merge des donnes
  tar_target(data_noeuds,bind_rows(noeuds_amelie_corrige,noeuds_anthonystp,noeuds_cvl_corrige,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)),
  tar_target(data_cours,bind_rows(cours_amelie_corrige2,cours_anthonystp_corrige,cours_cvl_corrige,cours_dp,cours_fxc_corrige,cours_jbca,cours_martineau,cours_alexis,cours_ilmdph)),
  tar_target(data_collaborations,bind_rows(collaborations_amelie_corrige2,collaborations_anthonystp_corrige,collaborations_cvl_corrige,collaborations_dp_corrige2,collaborations_fxc,collaborations_jbca,collaborations_martineau_corrige,collaborations_alexis,collaborations_ilmdph_corrige)),
  
  #Suppression des doublons
  
  tar_target(con,fonction_connect()),
  tar_target(noeuds,fonction_doublons_noeuds(data_noeuds)),
  tar_target(cours,fonction_doublons_cours(data_cours)),
  tar_target(collaborations,fonction_doublons_collaborations(data_collaborations)),
  
  tar_target(tables,fonction_creation_table(noeuds, cours, collaborations))
)
#####fonction
fonction_cours_amelie<-function(x){
  x<-x[,-c(6:7)]
  colnames(x)<-c("sigle","credits","obligatoire","laboratoire","libre")
  
  x}
fonction_cours_anthonystp <-function(x){x<-x[,-5]
x}
fonction_collaborations_ilmdph <-function(x){
  x<-x[,-5]
  x}
fonction_collaborations_dp<-function(x){
  x<-x[,-5]
  x}
fonction_noeuds_cvl<-function(x){
  x<-x[,-1]
  x}

fonction_cours_cvl<-function(x){x<-rename(x,sigle=Sigle)
x}
fonction_cours_fxc<-function(x){x<-rename(x,credits=credit)
x}
fonction_collaborations_amelie<-function(x){
  x<-rename(x,sigle=cours)
  x}
fonction_collaborations_anthonystp<-function(x){x<-rename(x,sigle=cours)
x}
fonction_collaborations_cvl<-function(x){x<-rename(x,sigle=cours)
x}
fonction_collaborations_dp<-function(x){x<-rename(x,sigle=cours)
x}
fonction_collaborations_martineau<-function(x){x<-rename(x,sigle=cours)
x}

fonction_noeuds_amelie<-function(x){colnames(x)<-c("nom_prenom","annee_debut","session_debut","programme","coop")
x}
fonction_collaborations_amelie_col<-function(x){colnames(x)<-c("etudiant1","etudiant2","sigle","date")
x}
fonction_cours_amelie_col<-function(x){colnames(x)<-c("sigle","credits","obligatoire","laboratoire","libre")
x}

fonction_doublons_cours<-function(x){x<-x[!duplicated(x$sigle),]
x}
fonction_doublons_collaborations<-function(x){x<-distinct(x)
x}
fonction_doublons_noeuds<-function(x){x<-x %>% arrange(rowSums(is.na(x)))
x<-x[!duplicated(x$nom_prenom),]
x}



fonction_creation_table<-function(noeuds,cours,collaborations){
  
  
  con<-dbConnect(SQLite(),dbname="attributs.db")
  dbSendQuery(con,"DROP TABLE collaborations;")
  dbSendQuery(con,"DROP TABLE noeuds;")
  dbSendQuery(con,"DROP TABLE cours;")
  
  tbl_noeuds <- "
CREATE TABLE noeuds (
  nom_prenom      VARCHAR(50),
  annee_debut      DATE(4),
  session_debut CHAR(1),
  programme       VARCHAR(20),
  coop        BOOLEAN(1),
  PRIMARY KEY (nom_prenom)
);"
  dbSendQuery(con, tbl_noeuds)
  
  tbl_cours <- "
CREATE TABLE cours (
sigle   CHAR(6) NOT NULL,
credits       INTEGER(1) ,
obligatoire     BOOLEAN(1),
laboratoire       BOOLEAN(1),
distance   BOOLEAN(1),
groupes   BOOLEAN(1),
libre   BOOLEAN(1),
PRIMARY KEY (sigle)
);"
  dbSendQuery(con, tbl_cours)
  
  tbl_collaborations <- "
CREATE TABLE collaborations (
  etudiant1     VARCHAR(50),
  etudiant2     VARCHAR(50),
  sigle   CHAR(6),
  date    DATE(3),
  PRIMARY KEY (etudiant1, etudiant2, sigle, date),
  FOREIGN KEY (etudiant1) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (etudiant2) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (sigle) REFERENCES cours(sigle)
);"
  dbSendQuery(con, tbl_collaborations)
  
  dbWriteTable(con, append = TRUE, name = "noeuds", value = noeuds, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "cours", value = cours, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "collaborations", value = collaborations, row.names = FALSE)
  
  
}

graph_base<-function(x){
  pdf(file = "results/figure1.pdf")
  m_adj<-table(x$etudiant1,x$etudiant2)
  m_adj
  
  deg<-apply(m_adj, 2, sum) + apply(m_adj, 1, sum)
  rk<-rank(deg)
  col.vec<-rev(heat.colors(nrow(m_adj)))
  adj<-graph.adjacency(m_adj)
  V(adj)$color = col.vec[rk]
  col.vec<-seq(10, 70, length.out = nrow(m_adj))
  V(adj)$size = col.vec[rk]
  adj2<-simplify(adj)
  E(adj2)$weight = sapply(E(adj2), function(e) { 
    length(all_shortest_paths(adj, from=ends(adj2, e)[1], to=ends(adj2, e)[2])$res) } )
  
  plot(adj2, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-2,2), xlim=c(-5,12), edge.width=E(adj2)$weight*0.5, asp=0.9)
  
}


fonction_requete_tsb303<-function(){
  
  con<-dbConnect(SQLite(),dbname="attributs.db")
  
  sql_requete3 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"
  
  collab_nontsb<-dbGetQuery(con,sql_requete3)
  collab_nontsb
  
  sql_requete_liens <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
GROUP BY etudiant
ORDER BY liens
"
  liens_nontsb <- dbGetQuery(con,sql_requete_liens)
  liens_nontsb
  
  sql_requete_tsb <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle LIKE '%TSB303%'
"
  
  collab_tsb<-dbGetQuery(con,sql_requete_tsb)
  collab_tsb
  
  sql_requete_prog <- "
SELECT nom_prenom,programme
FROM noeuds
"
  prog<-dbGetQuery(con,sql_requete_prog)
  pdf(file = "results/figure2.pdf")
  prog<-dbGetQuery(con,sql_requete_prog)
  col<-data.frame(programme=unique(prog$programme),color=c("green","yellow","yellow","yellow","yellow","yellow","yellow","yellow"))
  prog$color<-col$color[match(prog$programme, col$programme)]
  
  m_adj_nontsb<-table(collab_nontsb$etudiant1,collab_nontsb$etudiant2)
  m_adj_tsb<-table(collab_tsb$etudiant1,collab_tsb$etudiant2)
  
  adj_nontsb<-graph.adjacency(m_adj_nontsb)
  adj_tsb<-graph.adjacency(m_adj_tsb)
  
  V(adj_nontsb)$color = prog$color
  V(adj_nontsb)$size = 50
  vertex_attr(adj_nontsb)
  adj_nontsb<-simplify(adj_nontsb)
  
  plot(adj_nontsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_nontsb), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), asp=0.9)
}

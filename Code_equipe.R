##### Working directory ####
#getwd()
#setwd()

#pour flo # setwd("~/Desktop/dossier_mere/universite/Session_6/method_comp/Bio500/donnees_BIO500")
#Modif
#Pour frank; setwd("C:/Users/Francis/Desktop/BIO500/Bio500/donnees_BIO500")
sdgdfg

#install.packages("dyplr")
library(dplyr)
#install.packages("RSQLite")
library(RSQLite)
##### Chercher les données #####

noeuds_amelie<-read.csv("noeuds_amelie.csv", sep=";")
noeuds_anthonystp<-read.table("noeuds_anthonystp .txt",header = T,sep=";")
noeuds_cvl<-read.csv("noeuds_cvl_jl_jl_mp_xs.csv", sep=";")
noeuds_dp<-read.csv("noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")
noeuds_fxc<-read.table("noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")
noeuds_jbca<-read.table("noeuds_jbcaldlvjlgr.txt",header = T,sep=";")
noeuds_martineau<-read.table("noeuds_martineau.txt",header = T,sep=";")
noeuds_alexis<-read.table("etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
noeuds_ilmdph<-read.table("etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

cours_amelie<-read.csv("cours_amelie.csv", sep=";")
cours_anthonystp<-read.table("cours_anthonystp.txt",header = T,sep=";")
cours_cvl<-read.csv("cours_cvl_jl_jl_mp_xs.csv", sep=";")
cours_dp<-read.csv("cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")
cours_fxc<-read.table("cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")
cours_jbca<-read.table("cours_jbcaldlvjlgr.txt",header = T,sep=";")
cours_martineau<-read.table("cours_martineau.txt",header = T,sep=";")
cours_alexis<-read.table("Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
cours_ilmdph<-read.table("cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

collaborations_amelie<-read.csv("collaborations_amelie.csv", sep=";")
collaborations_anthonystp<-read.table("collaborations_anthonystp.txt",header = T,sep=";")
collaborations_cvl<-read.csv("collaborations_cvl_jl_jl_mp_xs.csv", sep=";")
collaborations_dp<-read.csv("collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")
collaborations_fxc<-read.table("collaborations_FXC_MF_TC_LRT_WP..txt",header = T,sep="")
collaborations_jbca<-read.table("collaborations_jbcaldlvjlgr.txt",header = T,sep=";")
collaborations_martineau<-read.table("collaborations_martineau.txt",header = T,sep=";")
collaborations_alexis<-read.table("collaboration_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
collaborations_ilmdph<-read.table("collaborations_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

##### Enlever les colonnes en trop pour certains ####

cours_amelie<-cours_amelie[,-c(6:7)]
cours_anthonystp<-cours_anthonystp[,-5]
collaborations_ilmdph<-collaborations_ilmdph[,-5]
collaborations_dp<-collaborations_dp[,-5]
noeuds_cvl<-noeuds_cvl[,-1]

##### Corretion nom de colonne #####

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

##### Fusionner les fichiers ####

data_noeuds<-bind_rows(noeuds_amelie,noeuds_anthonystp,noeuds_cvl,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)
data_noeuds
data_cours<-bind_rows(cours_amelie,cours_anthonystp,cours_cvl,cours_dp,cours_fxc,cours_jbca,cours_martineau,cours_alexis,cours_ilmdph)
data_cours
data_collaborations<-bind_rows(collaborations_amelie,collaborations_anthonystp,collaborations_cvl,collaborations_dp,collaborations_fxc,collaborations_jbca,collaborations_martineau,collaborations_alexis,collaborations_ilmdph)
data_collaborations

#### Enlever les doublons #### sujet à changement ####

cours<-data_cours[!duplicated(data_cours$sigle),]
cours


collaborations<-distinct(data_collaborations)
collaborations

noeuds<-data_noeuds[!duplicated(data_noeuds$nom_prenom),]
noeuds

#### Enlever les anciennes tables SQL ####

con<-dbConnect(SQLite(),dbname="attributs.db")
dbSendQuery(con,"DROP TABLE noeuds;")

#### Creation des tables SQL ####

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
  PRIMARY KEY (etudiant1, etudiant2, sigle,date),
  FOREIGN KEY (etudiant1) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (etudiant2) REFERENCES noeuds(nom_prenom),
  FOREIGN KEY (sigle) REFERENCES cours(sigle)
);"
dbSendQuery(con, tbl_collaborations)
dbListTables(con)


dbWriteTable(con, append = TRUE, name = "noeuds", value = noeuds, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "cours", value = cours, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "collaborations", value = collaborations, row.names = FALSE)

sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens <- dbGetQuery(con,sql_requete)
liens

sql_requete2 <- "
SELECT etudiant1, etudiant2, count(sigle) as liens
FROM collaborations
GROUP BY etudiant1, etudiant2
ORDER BY liens DESC
"
liens_paire <- dbGetQuery(con,sql_requete2)
liens_paire

#### Calcul de paramètres des liens ####

mean(liens$liens)
var(liens$liens)

tt
##### Working directory ####
#getwd()
#setwd()
#
#pour flo # setwd("~/Desktop/dossier_mere/universite/Session_6/method_comp/Bio500")
#pour frank: setwd("C:/Users/Francis/Desktop/BIO500/Bio500/donnees_BIO500")
#pour marge : setwd("C:\Users\margu\Documents\Bio500\donnees_BIO500")

#install.packages("dplyr")
library(dplyr)
#install.packages("RSQLite")
library(RSQLite)
#install.packages("targets")
library(targets)
#install.packages("igraph")
library(igraph)


noeuds_amelie<-read.csv("data/noeuds_amelie.csv", sep=";")
noeuds_anthonystp<-read.table("data/noeuds_anthonystp .txt",header = T,sep=";")
noeuds_cvl<-read.csv("data/noeuds_cvl_jl_jl_mp_xs.csv", sep=";")
noeuds_dp<-read.csv("data/noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")
noeuds_fxc<-read.table("data/noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")
noeuds_jbca<-read.table("data/noeuds_jbcaldlvjlgr.txt",header = T,sep=";")
noeuds_martineau<-read.table("data/noeuds_martineau.txt",header = T,sep=";")
noeuds_alexis<-read.table("data/etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
noeuds_ilmdph<-read.table("data/etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

cours_amelie<-read.csv("data/cours_amelie.csv", sep=";")
cours_anthonystp<-read.table("data/cours_anthonystp.txt",header = T,sep=";")
cours_cvl<-read.csv("data/cours_cvl_jl_jl_mp_xs.csv", sep=";")
cours_dp<-read.csv("data/cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")
cours_fxc<-read.table("data/cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")
cours_jbca<-read.table("data/cours_jbcaldlvjlgr.txt",header = T,sep=";")
cours_martineau<-read.table("data/cours_martineau.txt",header = T,sep=";")
cours_alexis<-read.table("data/Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
cours_ilmdph<-read.table("data/cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")

collaborations_amelie<-read.csv("data/collaborations_amelie.csv", sep=";")
collaborations_anthonystp<-read.table("data/collaborations_anthonystp.txt",header = T, sep=";")
collaborations_cvl<-read.csv("data/collaborations_cvl_jl_jl_mp_xs.csv", sep=";")
collaborations_dp<-read.csv("data/collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")
collaborations_fxc<-read.table("data/collaborations_FXC_MF_TC_LRT_WP..txt",header = T, sep="")
collaborations_jbca<-read.table("data/collaborations_jbcaldlvjlgr.txt",header = T, sep=";")
collaborations_martineau<-read.table("data/collaborations_martineau.txt",header = T, sep=";")
collaborations_alexis<-read.table("data/collaboration_Alexis_Nadya_Edouard_Penelope.txt",header = T, sep="")
collaborations_ilmdph<-read.table("data/collaborations_IL_MDH_ASP_MB_OL.txt",header = T, sep=";")

cours_cvl<-rename(cours_cvl,sigle=Sigle)
cours_fxc<-rename(cours_fxc,credits=credit)
collaborations_amelie<-rename(collaborations_amelie,sigle=cours)
collaborations_anthonystp<-rename(collaborations_anthonystp,sigle=cours)
collaborations_cvl<-rename(collaborations_cvl,sigle=cours)
collaborations_dp<-rename(collaborations_dp,sigle=cours)
collaborations_martineau<-rename(collaborations_martineau,sigle=cours)

data_noeuds<-bind_rows(noeuds_amelie,noeuds_anthonystp,noeuds_cvl,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)
data_cours<-bind_rows(cours_amelie,cours_anthonystp,cours_cvl,cours_dp,cours_fxc,cours_jbca,cours_martineau,cours_alexis,cours_ilmdph)
data_collaborations<-bind_rows(collaborations_amelie,collaborations_anthonystp,collaborations_cvl,collaborations_dp,collaborations_fxc,collaborations_jbca,collaborations_martineau,collaborations_alexis,collaborations_ilmdph)

data_collaborations<-data_collaborations[,-c(5:6)]


data_cours<-data_cours[,-c(6:8)]
data_noeuds<-data_noeuds[,-6]
  
cours<-data_cours[!duplicated(data_cours$sigle),]
cours


collaborations<-distinct(data_collaborations)
colnames(collaborations)<-c("etudiant1","etudiant2","sigle","date")

data_noeuds<-data_noeuds %>% arrange(rowSums(is.na(data_noeuds)))
noeuds<-data_noeuds[!duplicated(data_noeuds$nom_prenom),]
noeuds
  
####
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
  
  tar_target(cours_cvl_corrige,fonction_cours_cvl(cours_cvl)),
  tar_target(cours_fxc_corrige,fonction_cours_fxc(cours_fxc)),
  tar_target(collaborations_amelie_corrige,fonction_collaborations_amelie(collaborations_amelie)),
  tar_target(collaborations_anthonystp_corrige,fonction_collaborations_anthonystp(collaborations_anthonystp)),
  tar_target(collaborations_cvl_corrige,fonction_collaborations_cvl(collaborations_cvl)),
  tar_target(collaborations_dp_corrige,fonction_collaborations_dp(collaborations_dp)),
  tar_target(collaborations_martineau_corrige,fonction_collaborations_martineau(collaborations_martineau)),
  # Merge des donnes
  tar_target(data_noeuds,bind_rows(noeuds_amelie,noeuds_anthonystp,noeuds_cvl,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)),
  tar_target(data_cours,bind_rows(cours_amelie,cours_anthonystp,cours_cvl_corrige,cours_dp,cours_fxc_corrige,cours_jbca,cours_martineau,cours_alexis,cours_ilmdph)),
  tar_target(data_collaborations,bind_rows(collaborations_amelie_corrige,collaborations_anthonystp_corrige,collaborations_cvl_corrige,collaborations_dp_corrige,collaborations_fxc,collaborations_jbca,collaborations_martineau_corrige,collaborations_alexis,collaborations_ilmdph)),
  
  #Suppression des doublons
  
  tar_target(noeuds,fonction_data_noeuds(data_noeuds)),
  tar_target(cours,fonction_data_cours(data_cours)),
  tar_target(collaborations,fonction_data_collab(data_collaborations)),
  
  #Creation de tables  
  tar_target(tables,fonction_creation_table(noeuds, cours, collaborations)),
  #Creation figure1
  tar_target(graphique_base,graph_base(collaborations)),
  #Creation figure 2,3,4
  tar_target(requete_tsb303,fonction_requete_tsb303(collaborations))
  
)
  
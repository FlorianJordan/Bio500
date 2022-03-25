##### Working directory ####
#getwd()
#setwd()

#pour flo # setwd("~/Desktop/dossier_mere/universite/Session_6/method_comp/Bio500/donnees_BIO500")

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





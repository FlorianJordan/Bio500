library(targets)
library(dplyr)
source()

list(
  tar_target(noeuds_amelie,read.csv("donnees_modifs/noeuds_amelie.csv", sep=";")),
  tar_target(noeuds_anthonystp,read.table("donnees_modifs/noeuds_anthonystp .txt",header = T,sep=";")),
  tar_target(noeuds_cvl,read.csv("donnees_modifs/noeuds_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(noeuds_dp,read.csv("donnees_modifs/noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(noeuds_fxc,read.table("donnees_modifs/noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")),
  tar_target(noeuds_jbca,read.table("donnees_modifs/noeuds_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(noeuds_martineau,read.table("donnees_modifs/noeuds_martineau.txt",header = T,sep=";")),
  tar_target(noeuds_alexis,read.table("donnees_modifs/etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(noeuds_ilmdph,read.table("donnees_modifs/etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  tar_target(cours_amelie,read.csv("donnees_BIO500/cours_amelie.csv", sep=";")),
  tar_target(cours_anthonystp,read.table("donnees_BIO500/cours_anthonystp.txt",header = T,sep=";")),
  tar_target(cours_cvl,read.csv("donnees_BIO500/cours_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(cours_dp,read.csv("donnees_BIO500/cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(cours_fxc,read.table("donnees_BIO500/cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")),
  tar_target(cours_jbca,read.table("donnees_BIO500/cours_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(cours_martineau,read.table("donnees_BIO500/cours_martineau.txt",header = T,sep=";")),
  tar_target(cours_alexis,read.table("donnees_BIO500/Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(cours_ilmdph,read.table("donnees_BIO500/cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  tar_target(collaborations_amelie,read.csv("data/collaborations_amelie.csv", sep=";")),
  tar_target(collaborations_anthonystp,read.csv("data/collaborations_anthonystp.csv", sep=";")),
  tar_target(collaborations_cvl,read.csv("data/collaborations_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(collaborations_dp,read.csv("data/collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(collaborations_fxc,read.csv("data/collaborations_FXC_MF_TC_LRT_WP.csv", sep=";")),
  tar_target(collaborations_jbca,read.csv("data/collaborations_jbcaldlvjlgr.csv", sep=";")),
  tar_target(collaborations_martineau,read.csv("data/collaborations_martineau.csv", sep=";")),
  tar_target(collaborations_alexis,read.csv("data/collaboration_Alexis_Nadya_Edouard_Penelope.csv", sep=";")),
  tar_target(collaborations_ilmdph,read.csv("data/collaborations_IL_MDH_ASP_MB_OL.csv", sep=";"))
  )
  



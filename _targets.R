library(targets)
library(dplyr)
tar_option_set(packages = "dplyr")
list(
  tar_target(noeuds_amelie,read.csv("data/noeuds_amelie.csv", sep=";")),
  tar_target(noeuds_anthonystp,read.table("data/noeuds_anthonystp .txt",header = T,sep=";")),
  tar_target(noeuds_cvl,read.csv("data/noeuds_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(noeuds_dp,read.csv("data/noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(noeuds_fxc,read.table("data/noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")),
  tar_target(noeuds_jbca,read.table("data/noeuds_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(noeuds_martineau,read.table("data/noeuds_martineau.txt",header = T,sep=";")),
  tar_target(noeuds_alexis,read.table("data/etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(noeuds_ilmdph,read.table("data/etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  tar_target(cours_amelie,read.csv("data/cours_amelie.csv", sep=";")),
  tar_target(cours_anthonystp,read.table("data/cours_anthonystp.txt",header = T,sep=";")),
  tar_target(cours_cvl,read.csv("data/cours_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(cours_dp,read.csv("data/cours_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(cours_fxc,read.table("data/cours_FXC_MF_TC_LRT_WP..txt",header = T,sep="")),
  tar_target(cours_jbca,read.table("data/cours_jbcaldlvjlgr.txt",header = T,sep=";")),
  tar_target(cours_martineau,read.table("data/cours_martineau.txt",header = T,sep=";")),
  tar_target(cours_alexis,read.table("data/Cours_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")),
  tar_target(cours_ilmdph,read.table("data/cours_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")),
  
  tar_target(collaborations_amelie,read.csv("data/collaborations_amelie.csv", sep=";")),
  tar_target(collaborations_anthonystp,read.table("data/collaborations_anthonystp.txt",header = T, sep=";")),
  tar_target(collaborations_cvl,read.csv("data/collaborations_cvl_jl_jl_mp_xs.csv", sep=";")),
  tar_target(collaborations_dp,read.csv("data/collaborations_DP-GL-LB-ML-VQ_txt.csv", sep=";")),
  tar_target(collaborations_fxc,read.table("data/collaborations_FXC_MF_TC_LRT_WP.txt",header = T, sep=";")),
  tar_target(collaborations_jbca,read.table("data/collaborations_jbcaldlvjlgr.txt",header = T, sep=";")),
  tar_target(collaborations_martineau,read.table("data/collaborations_martineau.txt",header = T, sep=";")),
  tar_target(collaborations_alexis,read.table("data/collaboration_Alexis_Nadya_Edouard_Penelope.txt",header = T, sep=";")),
  tar_target(collaborations_ilmdph,read.table("data/collaborations_IL_MDH_ASP_MB_OL.txt",header = T, sep=";"))
)



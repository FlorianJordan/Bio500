library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
summ <- function(dataset) {
  summarize(dataset, mean_x = mean(x))
}

# Set target-specific options such as packages.
tar_option_set(packages = "dplyr")

# End this file with a list of target objects.
list(
  tar_target(
    noeuds_amelie,
    read.csv("noeuds_amelie.csv", sep=";")
  ),
  tar_target(
    noeuds_anthonystp,
    read.table("noeuds_anthonystp .txt",header = T,sep=";")
  ),
  tar_target(
    noeuds_cvl,
    read.csv("noeuds_cvl_jl_jl_mp_xs.csv", sep=";")
  ),
  tar_target(
    noeuds_dp,
    read.csv("noeuds_DP-GL-LB-ML-VQ_txt.csv", sep=";")
  ),
  tar_target(
    noeuds_fxc,
    read.table("noeuds_FXC_MF_TC_LRT_WP.txt",header = T,sep="")
  ),
  tar_target(
    noeuds_jbca,
    read.table("noeuds_jbcaldlvjlgr.txt",header = T,sep=";")
  ),
  tar_target(
    noeuds_martineau,
    read.table("noeuds_martineau.txt",header = T,sep=";")
  ),
  tar_target(
    noeuds_alexis,
    read.table("etudiant_Alexis_Nadya_Edouard_Penelope.txt",header = T,sep="")
  ), 
  tar_target(
    noeuds_ilmdph,
    read.table("etudiant_IL_MDH_ASP_MB_OL.txt",header = T,sep=";")
  ),
  tar_target(
    noeuds_cvl,
    noeuds_cvl<-noeuds_cvl[,-1]
  ),
  tar_target(
    data_noeuds,
    bind_rows(noeuds_amelie,noeuds_anthonystp,noeuds_cvl,noeuds_dp,noeuds_fxc,noeuds_jbca,noeuds_martineau,noeuds_alexis,noeuds_ilmdph)
  ),
  tar_target(
    noeuds,
    data_noeuds[!duplicated(data_noeuds$nom_prenom),]
  )
)
tar_manifest(fields = "command")

fonction_cours_amelie<-function(x){
  x[,-c(6:7)]
  colnames(x)<-c("sigle","credits","obligatoire","laboratoire","libre")
}
fonction_cours_anthonystp <-function(x){x[,-5]
}
fonction_collaborations_ilmdph <-function(x){
  x[,-5]
}
fonction_collaborations_dp<-function(x){
  x[,-5]
}
fonction_noeuds_cvl<-function(x){
  x[,-1]
}

fonction_cours_cvl<-rename(x,sigle=Sigle)
fonction_cours_fxc<-rename(x,credits=credit)
fonction_collaborations_amelie<-rename(x,sigle=cours)
fonction_collaborations_anthonystp<-rename(x,sigle=cours)
fonction_collaborations_cvl<-rename(x,sigle=cours)
fonction_collaborations_dp<-rename(x,sigle=cours)
fonction_collaborations_martineau<-rename(x,sigle=cours)

fonction_noeuds_amelie<-colnames(x)<-c("nom_prenom","annee_debut","session_debut","programme","coop")
fonction_collaborations_amelie<-colnames(x)<-c("etudiant1","etudiant2","sigle","date")


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
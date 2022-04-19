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

fonction_cours_cvl<-function(x){rename(x,sigle=Sigle)}
fonction_cours_fxc<-function(x){rename(x,credits=credit)}
fonction_collaborations_amelie<-function(x){rename(x,sigle=cours)
  colnames(x)<-c("etudiant1","etudiant2","sigle","date")}
fonction_collaborations_anthonystp<-function(x){rename(x,sigle=cours)}
fonction_collaborations_cvl<-function(x){rename(x,sigle=cours)}
fonction_collaborations_dp<-function(x){rename(x,sigle=cours)}
fonction_collaborations_martineau<-function(x){rename(x,sigle=cours)}

fonction_noeuds_amelie<-function(x){colnames(x)<-c("nom_prenom","annee_debut","session_debut","programme","coop")}
fonction_collaborations_amelie<-function(x){colnames(x)<-c("etudiant1","etudiant2","sigle","date")}

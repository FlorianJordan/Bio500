fonction_cours_amelie<-function(x){
  
  colnames(x)<-c("sigle","credits","obligatoire","laboratoire","libre")
x[,-c(6:7)]}
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
fonction_collaborations_amelie<-function(x){
  rename(x,sigle=cours)}
fonction_collaborations_anthonystp<-function(x){rename(x,sigle=cours)}
fonction_collaborations_cvl<-function(x){rename(x,sigle=cours)}
fonction_collaborations_dp<-function(x){rename(x,sigle=cours)}
fonction_collaborations_martineau<-function(x){rename(x,sigle=cours)}

fonction_doublons_cours<-function(x){x[!duplicated(x$sigle),]}


fonction_doublons_collaborations<-function(x){distinct(x)}

fonction_doublons_noeuds<-function(x){x %>% arrange(rowSums(is.na(x)))
  x[!duplicated(x$nom_prenom),]}

fonction_attributsdb<-dbConnect(SQLite(),dbname="attributs.db")





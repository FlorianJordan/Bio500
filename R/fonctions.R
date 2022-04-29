#### Enlever les colonnes supplémentaires ####


fonction_col_cours_amelie<-function(x){x<-x[,-c(6:7)]
x}

fonction_col_anthony<-function(x){x<-x[,-5]
x}

fonction_col_ilmdph<-function(x){x<-x[,-5]
x}

fonction_col_dp<-function(x){x<-x[,-5]
x}

fonction_col_cvl<-function(x){x<-x[,-1]
x}


#### Correction des noms de colonne ####


fonction_cours_cvl<-function(x){x<-rename(x,sigle=Sigle)
x}

fonction_cours_fxc<-function(x){x<-rename(x,credits=credit)
x}

fonction_cours_amelie<-function(x){
colnames(x)<-c("sigle","credits","obligatoire","laboratoire","libre")
x}

fonction_collaborations_amelie<-function(x){
colnames(x)<-c("etudiant1","etudiant2","sigle","date")
x}

fonction_collaborations_anthonystp<-function(x){x<-rename(x,sigle=cours)
x}

fonction_collaborations_cvl<-function(x){x<-rename(x,sigle=cours)
x}

fonction_collaborations_dp<-function(x){x<-rename(x,sigle=cours)
x}

fonction_collaborations_martineau<-function(x){x<-rename(x,sigle=cours)
x}

fonction_noeuds_amelie<-function(x){
colnames(x)<-c("nom_prenom","annee_debut","session_debut","programme","coop")
x}


#### Enlever les doublons ####


fonction_data_noeuds<-function(x){
  x<-x %>% arrange(rowSums(is.na(x))) #Placer les lignes ayant le moins de NA en haut du data frame
  x<-x[!duplicated(x$nom_prenom),] #Enlever les lignes ayant le même nom_prenom qu'une ligne supérieure
  x}

fonction_data_cours<-function(x){
  x<-x[!duplicated(x$sigle),] #Enlever les lignes contenant le même sigle qu'une ligne supérieure
  x}

fonction_data_collab<-function(x){
  x<-distinct(x) #Enlever les lignes pareilles à une ligne supérieure
  colnames(x)<-c("etudiant1","etudiant2","sigle","date")
  x<-x[,-5]
  x
}


#### Connection à SQL####


fonction_connect<-function(){
  con<-dbConnect(SQLite(), dbname = "attributs.db")
con}


#### Création des tables SQL####


fonction_creation_table<-function(con,noeuds, cours, collaborations){

con<-dbConnect(SQLite(), dbname = "attributs.db") #Connection à SQL


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
  
  con
  
  }


#### Foncion pour le graphique du réseau de base ####


graph_base<-function(x){

png(file = "results/figure1.png") #Ficher du graphique 1
m_adj<-table(x$etudiant1,x$etudiant2) #Matrice d'adjacence de tous les étudiants
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
plot(adj2, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-2,2), xlim=c(-9,12), edge.width=E(adj2)$weight*0.5, asp=0.9)

x
}


#### Fonction pour les autres réseaux ####


fonction_requete_reseau<-function(){

con<-dbConnect(SQLite(),dbname="attributs.db") #Connection à SQL


#### Figures du cours TSB303 ####


#Prélever toutes les collaborations sauf celle provenant du cours TSB303
sql_requete_nontsb <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"
collab_nontsb<-dbGetQuery(con,sql_requete_nontsb)

#Nombre de collaborations par étudiant sans les collaborations du cours TSB303
sql_requete_liens_nontsb <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
GROUP BY etudiant
ORDER BY liens
"
liens_nontsb <- dbGetQuery(con,sql_requete_liens_nontsb)

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


png(file = "results/figure2.png") #Fichier du graphique 2
par(mfrow=c(1,2))
#Création du graphique pour le réseau sans TSB303
plot(adj_nontsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_nontsb), rescale=FALSE, ylim=c(-3,3), xlim=c(-6,8), asp=0.9)


#Création du data frame de toutes les collaborations
sql_requete_adj <- "
SELECT etudiant1,etudiant2
FROM collaborations
"
collabs<-dbGetQuery(con,sql_requete_adj)

m_adj<-table(collabs$etudiant1,collabs$etudiant2) #Matrice d'adjacence de tout les étudiants


#Grapique du réseau de base mettant en évidence les collaboration du cours TSB303
adj3<-graph.adjacency(m_adj) #Création du réseau de base
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
plot(adj3, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj3), rescale=FALSE, ylim=c(-6,6), xlim=c(-4,10), asp=0.9)


#### Figure du réseau des étudiants ayant 30 collaborations et plus ####


#Nombre de collaborations par étudiant
sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens_ <- dbGetQuery(con,sql_requete)

liens30<-liens_[liens_$liens>=30,] #Liste des étudiant ayant plus de 30 collaborations


#Création du data frame contenant les collaborations entre les gens ayant plus de 30 collaborations
sql_requete30 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE (etudiant1 LIKE '%robert_penelope%' OR etudiant1 LIKE '%gregoire_simon%' OR etudiant1 LIKE '%quevillon_vincent%' OR etudiant1 LIKE '%saintpierre_anthony%' OR etudiant1 LIKE '%poulin_william%' OR etudiant1 LIKE '%prevosto_clara%' OR etudiant1 LIKE '%martineau_alexandre%' OR etudiant1 LIKE '%duchesne_marguerite%' OR etudiant1 LIKE '%jordan_florian%' OR etudiant1 LIKE '%lacroix_guillaume%' OR etudiant1 LIKE '%lepage_jeremi%' OR etudiant1 LIKE '%roy_elisabeth%' OR etudiant1 LIKE '%beland_laura%' OR etudiant1 LIKE '%beliveau_lauralie%' OR etudiant1 LIKE '%boum_laurence%' OR etudiant1 LIKE '%perron_maxime%' OR etudiant1 LIKE '%racine_gabrielle%' OR etudiant1 LIKE '%barbeau_juliette%' OR etudiant1 LIKE '%dhamelin_maili%' OR etudiant1 LIKE '%laurie_veldonjames%' OR etudiant1 LIKE '%nadonbeaumier_edouard%' OR etudiant1 LIKE '%stamant_xavier%' OR etudiant1 LIKE '%beaubien_marie%' OR etudiant1 LIKE '%langlois_claudieanne%' OR etudiant1 LIKE '%saintpierre_audreyann%' OR etudiant1 LIKE '%lalonde_daphnee%' OR etudiant1 LIKE '%lessard_martin%' OR etudiant1 LIKE '%matte_alexis%' OR etudiant1 LIKE '%tardy_nadia%' OR etudiant1 LIKE '%leclerc_olivier%' OR etudiant1 LIKE '%bergeron_amelie%' OR etudiant1 LIKE '%lefebvre_isabelle%' OR etudiant1 LIKE '%lavoie_alissandre%' OR etudiant1 LIKE '%lenneville_jordan%' OR etudiant1 LIKE '%plewinski_david%' OR etudiant1 LIKE '%dufour_melodie%' OR etudiant1 LIKE '%amyot_audreyanne%' OR etudiant1 LIKE '%berthiaume_elise%') AND (etudiant2 LIKE '%robert_penelope%' OR etudiant2 LIKE '%gregoire_simon%' OR etudiant2 LIKE '%quevillon_vincent%' OR etudiant2 LIKE '%saintpierre_anthony%' OR etudiant2 LIKE '%poulin_william%' OR etudiant2 LIKE '%prevosto_clara%' OR etudiant2 LIKE '%martineau_alexandre%' OR etudiant2 LIKE '%duchesne_marguerite%' OR etudiant2 LIKE '%jordan_florian%' OR etudiant2 LIKE '%lacroix_guillaume%' OR etudiant2 LIKE '%lepage_jeremi%' OR etudiant2 LIKE '%roy_elisabeth%' OR etudiant2 LIKE '%beland_laura%' OR etudiant2 LIKE '%beliveau_lauralie%' OR etudiant2 LIKE '%boum_laurence%' OR etudiant2 LIKE '%perron_maxime%' OR etudiant2 LIKE '%racine_gabrielle%' OR etudiant2 LIKE '%barbeau_juliette%' OR etudiant2 LIKE '%dhamelin_maili%' OR etudiant2 LIKE '%laurie_veldonjames%' OR etudiant2 LIKE '%nadonbeaumier_edouard%' OR etudiant2 LIKE '%stamant_xavier%' OR etudiant2 LIKE '%beaubien_marie%' OR etudiant2 LIKE '%langlois_claudieanne%' OR etudiant2 LIKE '%saintpierre_audreyann%' OR etudiant2 LIKE '%lalonde_daphnee%' OR etudiant2 LIKE '%lessard_martin%' OR etudiant2 LIKE '%matte_alexis%' OR etudiant2 LIKE '%tardy_nadia%' OR etudiant2 LIKE '%leclerc_olivier%' OR etudiant2 LIKE '%bergeron_amelie%' OR etudiant2 LIKE '%lefebvre_isabelle%' OR etudiant2 LIKE '%lavoie_alissandre%' OR etudiant2 LIKE '%lenneville_jordan%' OR etudiant2 LIKE '%plewinski_david%' OR etudiant2 LIKE '%dufour_melodie%' OR etudiant2 LIKE '%amyot_audreyanne%' OR etudiant2 LIKE '%berthiaume_elise%')
"
collabs30<-dbGetQuery(con,sql_requete30)


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


png(file = "results/figure3.png") #Ficher du graphique 3
par(mfrow=c(1,1))
#Création du graphique du réseau des étudiants ayant plus de 30 collaborations
plot(adj_30_2, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_30), rescale=FALSE, ylim=c(-5,5), xlim=c(-4,4), edge.width=E(adj_30_2)$weight*0.5, asp=0.9)

con

}


#### Fonction pour la création des histogrammes ####


fonction_requete_hist<-function(){

con<-dbConnect(SQLite(),dbname="attributs.db") #Connection à SQL


#Nombre de collaborations par étudiant
sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens <- dbGetQuery(con,sql_requete)


#Nombre de collaborations par étudiant sans les collaborations du cours TSB303
sql_requete_liens_nontsb <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
GROUP BY etudiant
ORDER BY liens
"
liens_nontsb <- dbGetQuery(con,sql_requete_liens_nontsb)


#Création d'un nouveau tableau contenant uniquement les collaborations différentes des étudiants
sql_requete_dif <- "
CREATE TABLE collaborations_dif AS 
  SELECT DISTINCT etudiant1,etudiant2
  FROM collaborations
"
dbExecute(con,sql_requete_dif)


#Création d'un tableau contenant toutes les collaborations sauf pour le cours TSB303
sql_requete_collab_nontsb <- "
CREATE TABLE collaborations_nontsb AS 
  SELECT etudiant1,etudiant2,sigle,date
  FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"
dbExecute(con,sql_requete_collab_nontsb)


#Création d'un tableau contenant uniquement les collaborations différentes des étudiants sans les collaborations de TSB303
sql_requete_dif_nontsb <- "
CREATE TABLE collaborations_nontsb_dif AS 
  SELECT DISTINCT etudiant1,etudiant2
  FROM collaborations_nontsb
"
dbExecute(con,sql_requete_dif_nontsb)


#Création d'un data frame des collaborations différentes par étudiant
sql_requete_liens_dif <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens_dif
  FROM collaborations_dif
  GROUP BY etudiant
  ORDER BY liens_dif
"
liens_dif <- dbGetQuery(con,sql_requete_liens_dif)


#Création d'un data frame des collaborations différentes par étudiant sans TSB303
sql_requete_liens_dif_nontsb <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens_dif
  FROM collaborations_nontsb_dif
  GROUP BY etudiant
  ORDER BY liens_dif
"
liens_nontsb_dif <- dbGetQuery(con,sql_requete_liens_dif_nontsb)


png(file = "results/figure4.png") #Fichier du graphique 4
par(mfrow=c(2,2))
#Histogrammes des collaborations totales et différentes, avec ou sans TSB303
hist(liens$liens, xlab = "Collaborations par etudiant", ylab = "Nombre d'etudiants", main = "a)")
hist(liens_dif$liens_dif, xlab = "Collaborations differentes 
     par etudiant", ylab = "Nombre d'etudiants", main = "b)")
hist(liens_nontsb$liens, xlab = "Collaborations par etudiant (sans TSB303)", ylab = "Nombre d'etudiants", main = "c)")
hist(liens_nontsb_dif$liens_dif, xlab = "Collaborations differentes 
     par etudiant (sans TSB303)", ylab = "Nombre d'etudiants", main = "d)")

con

}

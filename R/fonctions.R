####enlever les colonnes####

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

####correction nom de colonne####

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

####enlever les doublons####

fonction_data_noeuds<-function(x){
  x<-x %>% arrange(rowSums(is.na(x)))
  x<-x[!duplicated(x$nom_prenom),]
  x}

fonction_data_cours<-function(x){
  x<-x[!duplicated(x$sigle),]
  x}

fonction_data_collab<-function(x){
  x<-distinct(x)
  colnames(x)<-c("etudiant1","etudiant2","sigle","date")
  x}
fonction_data_collab_colone<-function(x){
 
  x<-x[,-c(5:6)]
  x}
fonction_data_collab_cor<-function(x){
  
  x<-x[,-5]
  x}
####tables de base sql####

function_connection_SQL <- function() {
  con <- dbConnect(SQLite(), dbname = "attributs.db")
}
fonction_creation_table<-function(con,noeuds,cours,collaborations){
  
  con<-dbConnect(SQLite(), dbname = "attributs.db")
  
  dbSendQuery(con,"DROP TABLE collaborations;")
  dbSendQuery(con,"DROP TABLE noeuds;")
  dbSendQuery(con,"DROP TABLE cours;")
  
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

graph_base<-function(x){
pdf(file = "results/figure1.pdf")
m_adj<-table(x$etudiant1,x$etudiant2)
m_adj

deg<-apply(m_adj, 2, sum) + apply(m_adj, 1, sum)
rk<-rank(deg)
col.vec<-rev(heat.colors(nrow(m_adj)))
adj<-graph.adjacency(m_adj)
V(adj)$color = col.vec[rk]
col.vec<-seq(10, 70, length.out = nrow(m_adj))
V(adj)$size = col.vec[rk]
adj2<-simplify(adj)
E(adj2)$weight = sapply(E(adj2), function(e) { 
  length(all_shortest_paths(adj, from=ends(adj2, e)[1], to=ends(adj2, e)[2])$res) } )

plot(adj2, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-2,2), xlim=c(-5,12), edge.width=E(adj2)$weight*0.5, asp=0.9)
x
}


fonction_requete_tsb303<-function(){
  con<-dbConnect(SQLite(),dbname="attributs.db")
sql_requete3 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
"

collab_nontsb<-dbGetQuery(con,sql_requete3)


sql_requete_liens <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations WHERE sigle NOT LIKE '%TSB303%'
GROUP BY etudiant
ORDER BY liens
"
liens_nontsb <- dbGetQuery(con,sql_requete_liens)

sql_requete_tsb <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle LIKE '%TSB303%'
"

collab_tsb<-dbGetQuery(con,sql_requete_tsb)


sql_requete_prog <- "
SELECT nom_prenom,programme
FROM noeuds
"

prog<-dbGetQuery(con,sql_requete_prog)
col<-data.frame(programme=unique(prog$programme),color=c("green","yellow","yellow","yellow","yellow","yellow","yellow","yellow"))
prog$color<-col$color[match(prog$programme, col$programme)]

m_adj_nontsb<-table(collab_nontsb$etudiant1,collab_nontsb$etudiant2)
m_adj_tsb<-table(collab_tsb$etudiant1,collab_tsb$etudiant2)

adj_nontsb<-graph.adjacency(m_adj_nontsb)
adj_tsb<-graph.adjacency(m_adj_tsb)

V(adj_nontsb)$color = prog$color
V(adj_nontsb)$size = 50
vertex_attr(adj_nontsb)
adj_nontsb<-simplify(adj_nontsb)
pdf(file = "results/figure2.pdf")
plot(adj_nontsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_nontsb), rescale=FALSE, ylim=c(-3,2), xlim=c(-5,12), asp=0.9)

V(adj_tsb)$color = prog$color
vertex_attr(adj_tsb)
V(adj_tsb)$size = 50
adj_tsb<-simplify(adj_tsb)
E(adj_tsb)$color = "black"
pdf(file = "results/figure3.pdf")
plot(adj_tsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_tsb), rescale=FALSE, ylim=c(-10,2), xlim=c(-10,9), edge.width = 2)

sql_requeteadj <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations 
"
collaborations_<-dbGetQuery(con,sql_requeteadj)

m_adj<-table(collaborations_$etudiant1,collaborations_$etudiant2)
m_adj
adj3<-graph.adjacency(m_adj)
V(adj3)$color = prog$color
V(adj3)$size = 50
adj3<-simplify(adj3)

edge_tsb<-as.data.frame(get.edgelist(adj_tsb))
edge_tsb$color<- "black"
edge_tsb$width<-2

edge_nontsb<-as.data.frame(get.edgelist(adj_nontsb))
edge_nontsb$color<- "gray"
edge_nontsb$width<-1
edge_tot<-as.data.frame(get.edgelist(adj3))
edge_tot<-bind_rows(edge_nontsb,edge_tsb)
edge_tot<-edge_tot %>% distinct(V1, V2, .keep_all = TRUE)

E(adj3)$color = edge_tot$color
E(adj3)$width = edge_tot$width
edge_attr(adj3)
pdf(file = "results/figure4.pdf")
plot(adj3, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj3), rescale=FALSE, ylim=c(-3,2), xlim=c(-5,12), asp=0.9)

#### Figure 30collab et +
sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens_ <- dbGetQuery(con,sql_requete)
liens30<-liens_[liens_$liens>=30,]
sql_requete4 <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE (etudiant1 LIKE '%robert_penelope%' OR etudiant1 LIKE '%gregoire_simon%' OR etudiant1 LIKE '%quevillon_vincent%' OR etudiant1 LIKE '%saintpierre_anthony%' OR etudiant1 LIKE '%poulin_william%' OR etudiant1 LIKE '%prevosto_clara%' OR etudiant1 LIKE '%martineau_alexandre%' OR etudiant1 LIKE '%duchesne_marguerite%' OR etudiant1 LIKE '%jordan_florian%' OR etudiant1 LIKE '%lacroix_guillaume%' OR etudiant1 LIKE '%lepage_jeremi%' OR etudiant1 LIKE '%roy_elisabeth%' OR etudiant1 LIKE '%beland_laura%' OR etudiant1 LIKE '%beliveau_lauralie%' OR etudiant1 LIKE '%boum_laurence%' OR etudiant1 LIKE '%perron_maxime%' OR etudiant1 LIKE '%racine_gabrielle%' OR etudiant1 LIKE '%barbeau_juliette%' OR etudiant1 LIKE '%dhamelin_maili%' OR etudiant1 LIKE '%laurie_veldonjames%' OR etudiant1 LIKE '%nadonbeaumier_edouard%' OR etudiant1 LIKE '%stamant_xavier%' OR etudiant1 LIKE '%beaubien_marie%' OR etudiant1 LIKE '%langlois_claudieanne%' OR etudiant1 LIKE '%saintpierre_audreyann%' OR etudiant1 LIKE '%lalonde_daphnee%' OR etudiant1 LIKE '%lessard_martin%' OR etudiant1 LIKE '%matte_alexis%' OR etudiant1 LIKE '%tardy_nadia%' OR etudiant1 LIKE '%leclerc_olivier%' OR etudiant1 LIKE '%bergeron_amelie%' OR etudiant1 LIKE '%lefebvre_isabelle%' OR etudiant1 LIKE '%lavoie_alissandre%' OR etudiant1 LIKE '%lenneville_jordan%' OR etudiant1 LIKE '%plewinski_david%' OR etudiant1 LIKE '%dufour_melodie%' OR etudiant1 LIKE '%amyot_audreyanne%' OR etudiant1 LIKE '%berthiaume_elise%') AND (etudiant2 LIKE '%robert_penelope%' OR etudiant2 LIKE '%gregoire_simon%' OR etudiant2 LIKE '%quevillon_vincent%' OR etudiant2 LIKE '%saintpierre_anthony%' OR etudiant2 LIKE '%poulin_william%' OR etudiant2 LIKE '%prevosto_clara%' OR etudiant2 LIKE '%martineau_alexandre%' OR etudiant2 LIKE '%duchesne_marguerite%' OR etudiant2 LIKE '%jordan_florian%' OR etudiant2 LIKE '%lacroix_guillaume%' OR etudiant2 LIKE '%lepage_jeremi%' OR etudiant2 LIKE '%roy_elisabeth%' OR etudiant2 LIKE '%beland_laura%' OR etudiant2 LIKE '%beliveau_lauralie%' OR etudiant2 LIKE '%boum_laurence%' OR etudiant2 LIKE '%perron_maxime%' OR etudiant2 LIKE '%racine_gabrielle%' OR etudiant2 LIKE '%barbeau_juliette%' OR etudiant2 LIKE '%dhamelin_maili%' OR etudiant2 LIKE '%laurie_veldonjames%' OR etudiant2 LIKE '%nadonbeaumier_edouard%' OR etudiant2 LIKE '%stamant_xavier%' OR etudiant2 LIKE '%beaubien_marie%' OR etudiant2 LIKE '%langlois_claudieanne%' OR etudiant2 LIKE '%saintpierre_audreyann%' OR etudiant2 LIKE '%lalonde_daphnee%' OR etudiant2 LIKE '%lessard_martin%' OR etudiant2 LIKE '%matte_alexis%' OR etudiant2 LIKE '%tardy_nadia%' OR etudiant2 LIKE '%leclerc_olivier%' OR etudiant2 LIKE '%bergeron_amelie%' OR etudiant2 LIKE '%lefebvre_isabelle%' OR etudiant2 LIKE '%lavoie_alissandre%' OR etudiant2 LIKE '%lenneville_jordan%' OR etudiant2 LIKE '%plewinski_david%' OR etudiant2 LIKE '%dufour_melodie%' OR etudiant2 LIKE '%amyot_audreyanne%' OR etudiant2 LIKE '%berthiaume_elise%')
"
collabs30<-dbGetQuery(con,sql_requete4)

m_adj_30<-table(collabs30$etudiant1,collabs30$etudiant2)

deg_30<-apply(m_adj_30, 2, sum) + apply(m_adj_30, 1, sum)
rk_30<-rank(deg_30)
col.vec_30<-rev(topo.colors(nrow(m_adj_30)))
adj_30<-graph.adjacency(m_adj_30)
V(adj_30)$color = col.vec_30[rk_30]
col.vec_30<-seq(30, 50, length.out = nrow(m_adj_30))
V(adj_30)$size = col.vec_30[rk_30]
V(adj_30)$label.cex = 0.6
adj_30_2<-simplify(adj_30)
E(adj_30_2)$weight = sapply(E(adj_30_2), function(e) { 
  length(all_shortest_paths(adj_30, from=ends(adj_30_2, e)[1], to=ends(adj_30_2, e)[2])$res) } )

par(mfrow=c(1,1))
pdf(file = "results/figure5.pdf")
plot(adj_30_2, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_30), rescale=FALSE, ylim=c(-4,4), xlim=c(-4,4), edge.width=E(adj_30_2)$weight*0.5, asp=0.9)

con

}


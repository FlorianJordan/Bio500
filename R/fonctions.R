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

fonction_creation_table<-function(cours,collaborations,noeuds){
    
  con<-dbConnect(SQLite(),dbname="attributs.db")
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
  
  }

fonction_requete<-function(){

sql_requete <- "
SELECT etudiant1 as etudiant, count(etudiant2) as liens
FROM collaborations
GROUP BY etudiant
ORDER BY liens
"
liens <- dbGetQuery(con,sql_requete)
liens}

fonction_requete2<-function(){

sql_requete2 <- "
SELECT etudiant1, etudiant2, count(sigle) as liens
FROM collaborations
GROUP BY etudiant1, etudiant2
ORDER BY liens DESC
"
liens_paire <- dbGetQuery(con,sql_requete2)
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

}


fonction_requete_tsb303<-function(){

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
liens_nontsb

sql_requete_tsb <- "
SELECT etudiant1,etudiant2,sigle,date
FROM collaborations WHERE sigle LIKE '%TSB303%'
"

collab_tsb<-dbGetQuery(con,sql_requete_tsb)

sql_requete_prog <- "
SELECT nom_prenom,programme
FROM noeuds
"
}
fonction_figure_tsb303<-function(){
pdf(file = "results/figure2.pdf")
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

graph_nontsb<-plot(adj_nontsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_nontsb), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), asp=0.9)

pdf(file = "results/figure3.pdf")
V(adj_tsb)$color = prog$color
vertex_attr(adj_tsb)
V(adj_tsb)$size = 50
adj_tsb<-simplify(adj_tsb)
E(adj_tsb)$color = "black"

graph_tsb<-plot(adj_tsb,vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj_tsb), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), edge.width = 2)

pdf(file = "results/figure4.pdf")
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

plot(adj3, vertex.label = NA, edge.arrow.mode = 0, layout=layout.kamada.kawai(adj), rescale=FALSE, ylim=c(-8,8), xlim=c(-8,8), asp=0.9)

}


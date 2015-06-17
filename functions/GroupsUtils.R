
# The file contains functions related to the retrieving groups information
# arguments:
# dbCon - data base connector, should be connected to database at predictioncenter.org
# casp - casp's round 
# prFormat - prediction format  
getGroupsIPs <- function(dbCon, casp="casp11", prFrmat='(\'TS\', \'RR\',\'QA\')'){
     query <- paste0("select distinct ip, g.name, g.code, p.pfrmat from ",
	casp, ".predictors pr join ", 
        casp, ".groups_predictors_relations gpr on gpr.predictors_id=pr.id join ",
	casp, ".groups g on g.id=gpr.groups_id ", 
	"join accounts a on pr.accounts_id=a.id ", 
	"join  ", casp, ".predictions p on p.groups_id=g.id ",
	"where gpr.roles_id=1  and p.pfrmat in ", prFrmat,
	sep=''
     );
     res <- dbSendQuery(con, query);
     #transform in data.frame
     as.data.frame(fetch(res, n=-1))
}



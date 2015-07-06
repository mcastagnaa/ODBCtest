rm(list =ls(all=TRUE))

perfSet <- readRDS("perfSet")
finalSet <- readRDS("riskSet_allData")

# Define top n risk contributors
n = 1

typicalPortSize <- nrow(finalSet)/nrow(perfSet)
finalSet$WBeta <- finalSet$Weight*finalSet$Beta

#change this to perform different sorting
##############################
selector <- finalSet$Beta
##############################

#order the risk contributors by date
finalSet <- finalSet[order(finalSet$pDate, selector, decreasing = T),]
#pick the top n
riskSet <- 
  finalSet[ave(selector, finalSet$pDate, FUN = seq_along) <= n, ]
#saveRDS(riskSet, file="riskSet")


#uniquePerfComp <- unique(perfSet[,c("assetName", "assetCode")])
uniqueRiskComp <- unique(riskSet[,c("AssetId", "Descr")])

perfSet[3] <- lapply(perfSet[3], as.character)

for(code in uniqueRiskComp$AssetId) {
  perfSet$assetCode[perfSet$assetCode == substr(code, 1,6)] <- code
}
  
combSet <- merge(perfSet, riskSet, by.x = "pDate" , by.y = "pDate")

combSet$Test <- combSet$assetCode == combSet$AssetId
match <- sum(combSet$Test)/nrow(perfSet)

print(match)
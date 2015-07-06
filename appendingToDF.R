library(RODBC)

rm(list =ls(all=TRUE))

date <- "2013-6-26"
fundId <- 42
assetId <- 'B1VYCH8'

finalSet <- data.frame(pDate = as.Date(character()),
                       assetId = character(), 
                       Weight = numeric(),
                       Descr = character(), 
                       stringsAsFactors=T) 
#str(finalSet)
channel <- odbcConnect("vivaldi_dBase")
#channel <- odbcConnect("SQLServerVivaldi")

for(i in seq(0, 1000, by=7)) {
  wDate <- as.character(as.Date(date)+i)
  print(wDate)
  portfDate <- as.data.frame(sqlQuery(channel, 
                                 paste("EXEC spS_GetFundsDetailsByDate_V2 '", wDate, 
                                       "', ", fundId, ", 0.1")))
  print(nrow(portfDate))
  if(nrow(portfDate)>0)  {
    Weight = 0
    Descr = ""
    if(assetId %in% portfDate$BMISCode){
      filterLine <- subset(portfDate, BMISCode == assetId, select=c(Weight, BBGTicker))
      Weight = as.numeric(filterLine$Weight)
      Descr = filterLine$BBGTicker
      #str(filterLine)
    }
      
      #print(data.frame(pDate=as.Date(wDate), 
      #               assetId, 
      #               Weight=as.numeric(filterLine$Weight),
      #               Descr = filterLine$BBGTicker))
  
    addedLine <- data.frame(pDate=as.Date(wDate), 
                          assetId, 
                          Weight,
                          Descr)
  
    finalSet <- rbind(finalSet, addedLine, make.row.names = FALSE) 
  }

}

close(channel)

saveRDS(finalSet, file="ThomasCookWeight")

#paste("EXEC spS_GetFundsDetailsByDate_V2 '", date,"', ",FundId,", 0.1")
#SpecExpSet$DetsDate <- as.Date(SpecExpSet$DetsDate)

#rm(list=ls()[ls() != "SpecExpSet"])
#save(Test, file = "TestSet.Rda")

#rm(list =ls(all=TRUE))
#load("TestSet.Rda")

plot(x = finalSet$pDate, y = finalSet$Weight, xlab = "Date", ylab = "Weight", main="A Graph to Show the Weighting of Aviva over the last 90 days")

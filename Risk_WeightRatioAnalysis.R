library(RODBC)
library(ggplot2)

rm(list =ls(all=TRUE))

date <- "2013-6-27"
fundId <- 42

finalSet <- data.frame(pDate = as.Date(character()),
                       MVaRonVaR = numeric(), 
                       Weight = numeric(),
                       Beta = numeric(),
                       AssetId = character(),
                       Descr = character(),
                       RiskByWeight = numeric(),
                       stringsAsFactors=T) 
str(finalSet)
channel <- odbcConnect("vivaldi_dBase")
#channel <- odbcConnect("SQLServerVivaldi")

for(i in seq(0, 1000, by=7)) {
  wDate <- as.character(as.Date(date)+i)
  #print(wDate)
  portfDate <- as.data.frame(sqlQuery(channel, 
                                 paste("EXEC dbo.spS_GetFundsDetailsAndRiskByDate_V2 '", wDate, 
                                       "', ", fundId, ", 0.1")))
 #print(nrow(portfDate))
  if(nrow(portfDate)>0)  {
    filterLine <- subset(portfDate, select=c(Weight, MVaRonVaR, BBGTicker, Beta, BMISCode))
    
    #print(data.frame(pDate=as.Date(wDate), 
    #                 Weight=as.numeric(filterLine$Weight),
    #                 Beta=as.numeric(filterLine$Beta),
    #                 MVaRonVaR=as.numeric(filterLine$MVaRonVaR), 
    #                 AssetId = filterLine$BMISCode, 
    #                 Descr = filterLine$BBGTicker),
    #                riskbyweight=as.numeric(filterLine$MVaRonVaR / filterLine$Weight))
  
    addedLine <- data.frame(pDate=as.Date(wDate),
                            MVaRonVaR = as.numeric(filterLine$MVaRonVaR),
                            Weight=as.numeric(filterLine$Weight),
                            Beta=as.numeric(filterLine$Beta),
                            AssetId = filterLine$BMISCode, 
                            Descr = filterLine$BBGTicker, 
                            RiskByWeight=as.numeric(filterLine$MVaRonVaR / filterLine$Weight))
  
    finalSet <- rbind(finalSet, addedLine, make.row.names = FALSE) 
    
  }
}

close(channel)

#paste("EXEC spS_GetFundsDetailsByDate_V2 '", date,"', ",FundId,", 0.1")
#SpecExpSet$DetsDate <- as.Date(SpecExpSet$DetsDate)

#rm(list=ls()[ls() != "SpecExpSet"])
#save(Test, file = "TestSet.Rda")

#rm(list =ls(all=TRUE))
#load("TestSet.Rda")


# use aggregate to create new data frame with the maxima
finalSet.agg <- aggregate(RiskByWeight ~ pDate, finalSet, max)

# then simply merge with the original
finalSet.max <- merge(finalSet.agg, finalSet)
finalSet.max$Descr <- factor(finalSet.max$Descr)
finalSet.max


x <-finalSet.max$pDate 
y <-factor(finalSet.max$Descr)

qplot(x,y)
ggplot(data.frame(x, y), aes(x,y)) + geom_point() + xlab("")+ylab("")

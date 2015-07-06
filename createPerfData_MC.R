# get the data from the file
perfData <- read.csv("performanceData.csv", 
                     header = TRUE, 
                     sep = ",", 
                     stringsAsFactors = F)
# get rid of the dates line (we really don't use it; my bad)
perfData <- perfData[-1,]
# separate the first two columns which are the same for all sets
twoCols <- perfData[,  names(perfData) %in% c("Ticker","SecurityName")]
# get the relevant data upon which we have to perform our calcs
rawdata <- perfData[, !(names(perfData) %in% c("Ticker","SecurityName"))]
#transform data in numbers (they are loaded as characters -- see str(rawdata)
rawdata <- as.data.frame(lapply(rawdata, as.numeric))

#Create a new data frame
perfSet <- data.frame(pDate = as.Date(character()),
                      assetName = character(),
                      assetId = character(), 
                      assetW = numeric(),
                      assetRet = numeric(), 
                      assetContr = numeric(),
                      stringsAsFactors=T) 

#cycle for every set of 4 columns
for(i in seq(1, ncol(rawdata), 4)){
  #add the absolute values of contributions
  absContr <- c(0,abs(rawdata[-1, i+3]))
  #find the row with that max abs contribution
  whichRow <- which(absContr==max(absContr))
  
  #work out the date from the column name
  colName = colnames(rawdata)[i]
  relevantDate <- as.Date(substr(colName,7,nchar(colName)), "%Y%m%d")
  #add all the other infos
  assetName <- twoCols[whichRow,2]
  assetCode <- twoCols[whichRow,1]
  assetW <- rawdata[whichRow, i]
  assetRet <- rawdata[whichRow, i+2]
  assetContr <- rawdata[whichRow, i+3]
  
  #create the marginal data.frame
  newLine <- data.frame(pDate = relevantDate, 
                       assetName, 
                       assetCode, 
                       assetW, 
                       assetRet,
                       assetContr)
  
  # and append it to the new set
  perfSet <- rbind(perfSet, newLine)
}
saveRDS(perfSet, file="ActualRisk")

perfData <- read.table("performanceData.csv",header=TRUE, sep=",")
str(perfData)


date <- "2013-6-27"

finalData <- data.frame(rDate = as.Date(character()),
                       Ticker = character(), 
                       AbsCont = numeric(),
                       SecurityName = character(), 
                       stringsAsFactors=T) 

columnNames <- grep("Contribution", colnames(perfData))

contrOnly <- subset(perfData, select = c(1,2,columnNames))

contrOnly <- t(contrOnly)

for(i in seq(0, 630, by=7)) {
  wDate <- as.character(as.Date(date)+i)}
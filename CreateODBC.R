library(RODBC)

rm(list =ls(all=TRUE))

channel <- odbcConnect("vivaldi_dBase")
Test <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFundsDetailsByDate_V2 '2015 Jun 29', 76, 0.1"))

SpecExpSet$DetsDate <- as.Date(SpecExpSet$DetsDate)

rm(list=ls()[ls() != "SpecExpSet"])
save(SpecExpSet, file = "SpecExpSet.Rda")



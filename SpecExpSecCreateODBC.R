library(RODBC)

rm(list =ls(all=TRUE))

channel <- odbcConnect("SQLServerVivaldi")
Spec3 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 126"))
Spec3$Fund <- as.factor("Spec3")
Spec4 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 127"))
Spec4$Fund <- as.factor("Spec4")
Spec5 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 128"))
Spec5$Fund <- as.factor("Spec5")
Spec6 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 129"))
Spec6$Fund <- as.factor("Spec6")
Spec7 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 130"))
Spec7$Fund <- as.factor("Spec7")
Spec8 <- as.data.frame(sqlQuery(channel, "EXEC spS_GetFoFTypeLoading1Y '2015 Apr 30', 131"))
Spec8$Fund <- as.factor("Spec8")
close(channel)

SpecExpSet <- rbind(Spec3, Spec4, Spec5, Spec6, Spec7, Spec8)
SpecExpSet$DetsDate <- as.Date(SpecExpSet$DetsDate)

rm(list=ls()[ls() != "SpecExpSet"])
save(SpecExpSet, file = "SpecExpSet.Rda")



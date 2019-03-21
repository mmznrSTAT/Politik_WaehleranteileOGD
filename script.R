install.packages("rjson")
install.packages("jsonlite")

install.packages("RJSONIO")


library("rjson")
library(jsonlite)
library(dplyr)
library(RJSONIO)

json_file <- "https://www.wahlen.zh.ch/wahlen2019/public/data/krw/listengde.json"
json_data <- jsonlite::fromJSON(json_file)
json_data

json_file1 <- "https://www.wahlen.zh.ch/wahlen2019/public/data/krw/listen.json"
json_data1 <- jsonlite::fromJSON(json_file1)
json_data1

##json_data_frame <- as.data.frame(json_data)
flat1 <- flatten(json_data$listen_auf_gemeindeebene)
flat2 <- flatten(json_data$listen_stadtzh)
flat3 <- flatten(json_data1$listen_auf_kantonsebene)
head(flat)


flat2$wahlkreis_nr <- NA
flat2$wahlkreis_bez <- NA
flat2$gemeinde_bfsnr <- 261
flat2$gemeinde_bez <- "Kanton Zürich"


head(flat3)


flat2$wahlkreis_nr <- NA
flat2$wahlkreis_bez <- NA
flat2$gemeinde_bfsnr <- 261
flat2$gemeinde_bez <- "Zürich"

flat1$stimmenzusatz <- NULL

flat2$sitze <- NULL
flat2$gewinn_sitze <- NULL
flat2$waehler_zr <- NULL
flat2$waehlerproz_zr <- NULL
flat2$letzte_wahl_waehlerproz_zr <- NULL
flat2$gewinn_waehlerproz_zr <- NULL
flat2$letzte_wahl_sitze <- NULL

head(flat1)
head(flat2)



flat <- rbind(flat1,flat2)

write.csv(flat, file = "Waehleranteile_KRW19_Gemeinden.csv")

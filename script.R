install.packages("rjson")
install.packages("jsonlite")

install.packages("RJSONIO")


library("rjson")
library(jsonlite)
library(dplyr)
library(RJSONIO)

#####################
##  Wähleranteile  ##
#####################
json_file <- "https://www.wahlen.zh.ch/wahlen2019/public/data/krw/listengde.json"
json_data <- jsonlite::fromJSON(json_file)

json_file1 <- "https://www.wahlen.zh.ch/wahlen2019/public/data/krw/listen.json"
json_data1 <- jsonlite::fromJSON(json_file1)




flat1 <- flatten(json_data$listen_auf_gemeindeebene)
flat2 <- flatten(json_data$listen_stadtzh)
flat3 <- flatten(json_data1$listen_auf_kantonsebene)

flat2$wahlkreis_nr <- NA
flat2$wahlkreis_bez <- NA
flat2$gemeinde_bfsnr <- 261
flat2$gemeinde_bez <- "Kanton Zürich"

flat1$stimmenzusatz <- NULL

flat2$sitze <- NULL
flat2$gewinn_sitze <- NULL
flat2$waehler_zr <- NULL
flat2$waehlerproz_zr <- NULL
flat2$letzte_wahl_waehlerproz_zr <- NULL
flat2$gewinn_waehlerproz_zr <- NULL
flat2$letzte_wahl_sitze <- NULL

flat <- rbind(flat1,flat2)

write.csv(flat, file = "Waehleranteile_KRW19_Gemeinden.csv")
write.csv(flat3, file = "Waehleranteile_KRW19_Kanton.csv")


#####################
## Wahlbeteiligung ##
#####################
json_fileWB <- "https://www.wahlen.zh.ch/wahlen2019/public/data/krw/wahlbeteiligung.json"
json_wahlbet <- jsonlite::fromJSON(json_fileWB)


#Gemeindeebene
wahlbetGem <- flatten(json_wahlbet$wahlbeteiligung_auf_gemeindeebene)

#Da nur ein Objekt für Umwandlung in data frame in string umwandeln, Liste draus machen ([]) und wieder parsen
stadt <- json_wahlbet$wahlbeteiligung_stadtzh
stadt <- toJSON(stadt)
stadt <- c("[",stadt,"]")
stadt <- jsonlite::fromJSON(stadt)

wahlbetStadtZH <- stadt
wahlbetStadtZH$gemeinde_bfsnr <- 261
wahlbetStadtZH$gemeinde_bez <- "Zürich"

wahlbetGem <- wahlbetGem %>%
    select(gemeinde_bfsnr,gemeinde_bez,wahlbeteiligung,letzte_wahl_wahlbeteiligung)

wahlbetStadtZH <- wahlbetStadtZH %>%
  select(gemeinde_bfsnr,gemeinde_bez,wahlbeteiligung,letzte_wahl_wahlbeteiligung)

wahlbetGem <- rbind(wahlbetGem,wahlbetStadtZH)


#Kantonsebene
kanton <- json_wahlbet$wahlbeteiligung_auf_kantonsebene
kanton <- toJSON(kanton)
kanton <- c("[",kanton,"]")
kanton <- jsonlite::fromJSON(kanton)

head(kanton)
head(wahlbetZH)
wahlbetZH$gemeinde_bfsnr <- 1
wahlbetZH$gemeinde_bez <- "Kanton Zürich"

wahlbetZH <- wahlbetZH %>%
  select(gemeinde_bfsnr,gemeinde_bez,wahlbeteiligung,letzte_wahl_wahlbeteiligung)

write.csv(wahlbetZH, file = "wahlbeteiligung_KRW2019_Kanton.csv")
write.csv(wahlbetGem, file = "wahlbeteiligung_KRW2019_Gemeinden.csv")



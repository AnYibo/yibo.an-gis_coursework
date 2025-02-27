#check working directory
getwd()

#improve colors for map drawing
install.packages("shinyjs")
library(shinyjs)
#improve an aesthetic visualisation
install.packages("plotly")
library(plotly)
#install further packages
install.packages("maptools")
install.packages(c("classint", "OpenStreetMap", "tmap"))
install.packages(c("RColorBrewer", "Sp", "rgeos","tmap","tmaptools", "sf", "downloader", "rgdal", "geojsonio"))
#Load Packages
library(maptools)
library(RColorBrewer)
library(classInt)
library(OpenStreetMap)
library(sp)
library(rgeos)
library(tmap)
library(tmaptools)
library(sf)
library(rgdal)
library(geojsonio)

#use New Skool Cleaning for LondonData.csv
#use tidyverse package
install.packages("tidyverse")
#clean text characters out from the numeric columns
library(tidyverse)

#wang the data in straight from the web using read_csv, skipping over the 'n/a'
LondonData <- read_csv("https://files.datapress.com/london/dataset/ward-profiles-and-atlas/2015-09-24T14:21:24/ward-profiles-excel-version.csv", na = "n/a")
#check data type
class(LondonData)
#check if data has been read in correctly; all columns that should be numbers are read in as numeric
datatypelist <- data.frame(cbind(lapply(LondonData,class)))
LondonData <- edit(LondonData)
names(LondonData)

#organise data
#select a small subset
LondonData <- data.frame(LondonData)
LondonBoroughs <- LondonData[grep("^E09",LondonData[,3]),]
head(LondonBoroughs)
#clear data featured twice
LondonBoroughs <- LondonBoroughs[2:34,]
#rename the column 1 in LondonBoroughs
names(LondonBoroughs)[1] <- c("Borough Name")

#Read shapefile
#download a GeoJson file
EW <- geojson_read("http://geoportal.statistics.gov.uk/datasets/8edafbe3276d4b56aec60991cbddda50_2.geojson", what = "sp")
#pull out london and plot
LondonMap <- EW[grep("^E09",EW@data$lad15cd),]
qtm(LondonMap)
#read the shapefile into a simple features object, and check by qtm
BoroughMapSF <- read_shape("N:/GIS/wk3/RProject1/BoundaryData/england_lad_2011.shp", as.sf = TRUE)
BoroughMapSP <- LondonMap
qtm(BoroughMapSF)
qtm(BoroughMapSP)

#convert between simple features objects and spatialPolygonsDataFrames
library(methods)
#check the class of BoroughMapSF
class(BoroughMapSF)
#check the class of BoroughMapSP
class(BoroughMapSP)
#convert the SP object into an SF object
BoroughMapSP <- as(BoroughMapSF, "Spatial")

#join attribute data to some boundaries first
#join the data with SF
BoroughDataMap <- append_data(BoroughMapSF,LondonData, key.shp = "code", key.data = "New.code", ignore.duplicates = TRUE)
#get the corresponding data row numbers and key values
over_coverage()

#do interactive maps
tmap_mode("view")
tm_shape(BoroughDataMap) +
  tm_polygons("Rate.of.JobSeekers.Allowance..JSA..Claimants...2015",
              style="jenks",
              palette="YlOrRd",
              midpoint=NA,
              title="Rate of JobSeekers",
              alpha = 0.75)

#save map as an html file
tmap_save(filename = "JobSeekers.html")

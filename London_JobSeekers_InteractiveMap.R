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

#In this part, two maps were created, including one GUI based map and one Command line generated map. ArcMap and RStudio were used in this process. Initially the two maps are about public green spaces’ accessibility in the range of UCL campus and the Job Seeker’s distribution information of London.
#When considering to compare the workflow of the two different software, firstly, the Graphic User-Interface (GUI) provides a favourable environment for people even with no experience for using the software before. Instead of making user directly facing the code and non-first language, ArcMap offers the opportunities to convert commands into simple clicks; the skeuomorphic icons and visual indicators in the working space are easy to be recognised and understood. Further, ArcMap advantages of an interface for it can provide feedback more effectively than program runs, namely the results can be quite intuitive. Accordingly, as for the operation, it is also highly visual-depended. Users with common sense and basic knowledge could probably be capable to operate such a software. The moving and control for layers, or checking attribute table, changing properties are all friendly to understand and operate; more advanced functions such as buffer analysis and spatial pattern analysis are also providing practical meaning to the real-world issue solving.
#However, it has been argued that GUIs can be made quite hard when dialogs are buried deep in a system, or moved about to different places during redesigns. Also, icons and dialog boxes are usually harder for users to script. Therefore sometimes the reproduction can be difficult because the generating processes are usually not traceable; outcomes are likely becoming one of the dominated aspects in the workflow. The simplicity and intelligibility of operating procedures could be neglected. Moreover, excepted for the model building function, making map is actually relying more on the settled approaches in ArcMap, and user experiences are often based on following the guide. Further due to the very nature of GUIs, the costs for developing and maintaining can be comparatively higher.
#Regarding for the programming-based software, in this assessment, the RStudio, it indicates an exponential study process. Unlike the GUIs, generating command-based maps took plenty time in the very beginning. It took energies for understanding the controlling language and getting familiar with the working windows. Thus for common people, it is a long way from getting started to making fancy maps. Whereas, once have the fundamental cognition and essential skills, operating became enjoyable. As well, the reproduction seems quite liable in RStudio when the code turned understandable. The command can be very various indeed, which provides sense of exploration for learners. Simple codes can facilitate multiple and interactive maps, as the figure London_JobSeekers depicted. Additionally, the working flow can be known and communicated on various platforms in a healthy environment; codes and processes can be shared and read. It is vital to mention that during utilising RStudio, packages and resources like third-party libraries are abundant. So when users working or studying, the ability for addressing issues could be largely raised.
#Based on my own experience, despite ArcMap is more new-user friendly, RStudio seems to be more sustainable. New functions for formulas are highly possible to be established. However, sometime the potential bug is not noticeable, therefore when error comes, although there is annotation, finding the source is not easy. Also it is significantly attentional that the different versions of RStudio can lead to diverse outcomes. The compatibility developing and contained packages and libraries are differ between versions; at times issue occurred because of the version is low.


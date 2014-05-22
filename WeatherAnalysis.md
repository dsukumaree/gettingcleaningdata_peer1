Analysis of outcomes from severe weather events
========================================================

# Synopsis
The U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database was used to compare outcomes from storm and severe weather events across United States. Data was analyzed for the years 1993-2011. The database tracks storm and other severe weather outcomes including when and where they occur, property and crop damage, injuries and fatalities to human population.Events were grouped into following categories for analysis : Cold/Ice, Heat/Drought/Fire, Rain/Flood/HighSeas, Convection, Lightning, Volcano/Tsunami and Dust.

For the period analyzed, the greatest number of fatalities (3293) and most number of injuries (37219) was due to Convection. Highest amount of property damage ($160.32 Billion) was due to Rain/Flood/HighSeas and highest amount of crop damage ($13 Billion) was due to Convection.

# Data Processing

## Load packages

```r
library(ggplot2)
library(data.table)
library(plyr)
library(reshape)
```

```
## 
## Attaching package: 'reshape'
## 
## The following objects are masked from 'package:plyr':
## 
##     rename, round_any
```

```r
library(xtable)
```

## Download and Read Data

**Download storm data documentation files**

[National Weather Service Storm Data Documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)  
[National Climatic Data Center Storm Events FAQ](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf)

```r
url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf"
f <- file.path(getwd(), "StormDataDoc.pdf")
download.file(url, f, mode = "wb")
url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf"
f <- file.path(getwd(), "StormEventsFAQ.pdf")
download.file(url, f, mode = "wb")
```


**Download and read data file**

```r
## Download storm data file and load into table
url <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
f <- tempfile()
## download.file(url, f) stormdata <- read.csv(bzfile(f))
stormdata <- read.csv("StormData.csv")

nrow(stormdata)
```

```
## [1] 902297
```

```r
ncol(stormdata)
```

```
## [1] 37
```


## Data Cleaning

```r
## Convert column names to lower
names(stormdata) <- tolower(names(stormdata))
## evtype column has to be cleaned of special characters and spaces for
## better grouping replace '\' or '/ ' with '/'
stormdata$evtype <- gsub("\\\\|(\\/\\s)", "/", stormdata$evtype)
## remove leading and trailing space
stormdata$evtype <- gsub("^\\s+|\\s+$", "", stormdata$evtype)
## convert to lower case
stormdata$evtype <- tolower(stormdata$evtype)
## remove punctuation
stormdata$evtype <- gsub("[[:punct:]]", " ", stormdata$evtype)
## remove duplicates after clean up
evtype1 <- data.table(unique(stormdata$evtype))
nrow(evtype1)
```

```
## [1] 860
```

```r
## add an extra column to assign event category
evtype1[, `:=`(V2, character(.N))]
```

```
##                            V1 V2
##   1:                  tornado   
##   2:                tstm wind   
##   3:                     hail   
##   4:            freezing rain   
##   5:                     snow   
##  ---                            
## 856:          lakeshore flood   
## 857: marine thunderstorm wind   
## 858:       marine strong wind   
## 859:    astronomical low tide   
## 860:         volcanic ashfall
```


## Data Transformation
**Event Categories:**  
Events were grouped into following categories for analysis:  

1. Cold/Ice  
2. Heat/Drought/Fire  
3. Rain/Flood/HighSeas   
4. Convection  
5. Lightning  
6. Volcano/Tsunami  
7. Dust  


```r
## Vectors with strings in evtype column to be used for grouping
ColdIce <- c("avalanche", "avalance", "blizzard", "chill", "cold", "cool", "glaze", 
    "hypothermia", "hyperthermia", "ice", "icy", "freez", "frost", "low temp", 
    "sleet", "snow", "wint", "fog", "vog")
HeatDroughtFire <- c("below normal precip", "dry", "drie", "drought", "fire", 
    "heat", "high temp", "hot", "warm", "smoke")
RainFloodHighSeas <- c("coast", "cstl", "current", "dam fail", "dam break", 
    "drizzle", "drown", "erosion", "erosin", "flood", "floood", "fld", "heavy shower", 
    "high water", "high waves", "lake", "landslump", "marine", "precip", "rain", 
    "rising water", "river", "rogue wave", "slide", "stream", "sea", "seiche", 
    "surf", "swell", "tide", "tidal", "torrent", "wet")
Convection = c("burst", "cloud", "depression", "floyd", "funnel", "gust", "hail", 
    "hurricane", "landspout", "storm", "southeast", "thunderstorm", "thundertsorm", 
    "thundestorm", "tornado", "torndao", "tstm", "turbulence", "typhoon", "wall", 
    "waterspout", "water spout", "wayterspout", "wind", "wnd")
Lightning <- c("lightning", "ligntning", "lighting")
VolcanoTsunami = c("tsunami", "volcan")
Dust = c("dust")
```

**Assign Category**

```r
## This function will take every evtype and find a match in the event
## category list. Category is then assigned to the 2nd column in evtype
assignCategory <- function(catlist, evtype, catname) {
    for (j in 1:nrow(evtype)) {
        for (i in 1:length(catlist)) {
            if (sum(grepl(catlist[i], evtype[j, V1]))) {
                evtype[j, 2] <- catname
            }
        }
    }
    evtype
}
## Use assignCategory to calculate Categories for each group
x <- assignCategory(ColdIce, evtype1, c("Cold/Ice"))
x <- assignCategory(HeatDroughtFire, x, c("Heat/Drought/Fire"))
x <- assignCategory(RainFloodHighSeas, x, c("Rain/Flood/HighSeas"))
x <- assignCategory(Convection, x, c("Convection"))
x <- assignCategory(Lightning, x, c("Lightning"))
x <- assignCategory(VolcanoTsunami, x, c("Volcano/Tsunami"))
x <- assignCategory(Dust, x, c("Dust"))
## Store final result in evtypeCat
evtypeCat <- x
## name columns
setnames(evtypeCat, c("evtype", "evCategory"))
## Count by category
evtypeCat[, .N, by = list(evCategory)]
```

```
##             evCategory   N
## 1:          Convection 345
## 2: Rain/Flood/HighSeas 219
## 3:            Cold/Ice 129
## 4:           Lightning  18
## 5:   Heat/Drought/Fire  60
## 6:                      75
## 7:                Dust   9
## 8:     Volcano/Tsunami   5
```

*Note:* Some EVTYPE values have no categories. These are ignored because proper classification was not possible given the values.

```r
tail(evtypeCat[evCategory == "", ], 5)
```

```
##                 evtype evCategory
## 1: summary of march 27           
## 2: summary of march 29           
## 3: monthly temperature           
## 4:   red flag criteria           
## 5:     northern lights
```

```r
evtypeCat <- evtypeCat[evCategory != "", ]
```

**Assign Property and Crop damage exponents**  

For property and crop damage amounts, alphabetical characters are used to signify magnitude include “K” for thousands, “M” for millions, and “B” for billions in the fields propdmgexp and cropdmgexp. 

```r
## Assigning exponent values to Property Damage
stormdata$propdmgexp <- gsub("K", "000", stormdata$propdmgexp)
stormdata$propdmgexp <- gsub("M", "000000", stormdata$propdmgexp)
stormdata$propdmgexp <- gsub("B", "000000000", stormdata$propdmgexp)

## Assigning exponent values to Crop Damage
stormdata$cropdmgexp <- gsub("K", "000", stormdata$cropdmgexp, ignore.case = TRUE)
stormdata$cropdmgexp <- gsub("M", "000000", stormdata$cropdmgexp)
stormdata$cropdmgexp <- gsub("B", "000000000", stormdata$cropdmgexp)
```

_note:_ Rows with invalid/no exponent value makes a very small percentage of the overall amount and hence ignored.

**Restrict data based on exponents**


```r
## subsetting stormdata that has exponential value for property damage of K,
## M and B - transformed to '000', '000000' and '000000000'
stormdata_good_prop <- stormdata[stormdata$propdmgexp %in% c("000", "000000", 
    "000000000"), ]
nrow(stormdata_good_prop)
```

```
## [1] 436035
```

```r
## subsetting stormdata that has exponential value for crop damage of K, M
## and B - transformed to '000', '000000' and '000000000'
stormdata_good_crop <- stormdata[stormdata$cropdmgexp %in% c("000", "000000", 
    "000000000"), ]
nrow(stormdata_good_crop)
```

```
## [1] 283856
```

```r
## Join stormdata's property damage subset to event category
stormdata_good_prop_ev <- join(stormdata_good_prop, evtypeCat, type = "inner")
```

```
## Joining by: evtype
```

```r
nrow(stormdata_good_prop_ev)
```

```
## [1] 436020
```

```r
## Join stormdata's crop damage subset to event category
stormdata_good_crop_ev <- join(stormdata_good_crop, evtypeCat, type = "inner")
```

```
## Joining by: evtype
```

```r
nrow(stormdata_good_crop_ev)
```

```
## [1] 283826
```

**State validation**

```r
## Restrict property damage data by state
stormdata_good_prop_ev <- stormdata_good_prop_ev[stormdata_good_prop_ev$state %in% 
    state.abb, ]
## Restrict crop damage data by state
stormdata_good_crop_ev <- stormdata_good_crop_ev[stormdata_good_crop_ev$state %in% 
    state.abb, ]
```

**Calculate Year and Damage amount**

```r
## Extract year from bgn_date
stormdata_good_prop_ev$year <- format(strptime(stormdata_good_prop_ev[, 2], 
    "%m/%d/%Y"), "%Y")
## Add exponent to property damage amount
stormdata_good_prop_ev$propdmgamt <- as.numeric(paste(stormdata_good_prop_ev$propdmg, 
    stormdata_good_prop_ev$propdmgexp, sep = ""))
## Use data after 1993 as it is more complete
stormdata_good_prop_ev <- stormdata_good_prop_ev[stormdata_good_prop_ev$year >= 
    "1993", ]
## Convert to million
stormdata_good_prop_ev$propdmgamt <- stormdata_good_prop_ev$propdmgamt/10^9
## Extract year from bgn_date
stormdata_good_crop_ev$year <- format(strptime(stormdata_good_crop_ev[, 2], 
    "%m/%d/%Y"), "%Y")
## Use data after 1993 as it is more complete
stormdata_good_crop_ev <- stormdata_good_crop_ev[stormdata_good_crop_ev$year >= 
    "1993", ]
## Add exponent to crop damage amount
stormdata_good_crop_ev$cropdmgamt <- as.numeric(paste(stormdata_good_crop_ev$cropdmg, 
    stormdata_good_crop_ev$cropdmgexp, sep = ""))
## Convert to million
stormdata_good_crop_ev$cropdmgamt <- stormdata_good_crop_ev$cropdmgamt/10^9
```

**Injuries and Fatalities**

```r
## Join stormdata to evtypeCat to get event categories
stormdata_ev <- join(stormdata, evtypeCat, type = "inner")
```

```
## Joining by: evtype
```

```r
## Limit to valid states
stormdata_ev <- stormdata_ev[stormdata_ev$state %in% state.abb, ]
stormdata_ev$year <- format(strptime(stormdata_ev[, 2], "%m/%d/%Y"), "%Y")
## Use data after 1993 as it is more complete
stormdata_ev <- stormdata_ev[stormdata_ev$year >= "1993", ]
```

# Data Aggregation
## Property and Crop Damage

```r
## Aggregate crop damage by year and event category
crop_dmg_aggregate <- ddply(stormdata_good_crop_ev, .(year, evCategory), summarize, 
    totCropDamage = sum(cropdmgamt))
## Aggregate crop damage by state and event category
crop_dmg_aggregate_state <- ddply(stormdata_good_crop_ev, .(state, evCategory), 
    summarize, totCropDamage = sum(cropdmgamt))

## Aggregate property damage by year and event category
prop_dmg_aggregate <- ddply(stormdata_good_prop_ev, .(year, evCategory), summarize, 
    totPropDamage = sum(propdmgamt))
## Aggregate property damage by state and event category
prop_dmg_aggregate_state <- ddply(stormdata_good_prop_ev, .(state, evCategory), 
    summarize, totPropDamage = sum(propdmgamt))
```

## Injuries and Fatalities

```r
## Aggregate by year and event category
health_aggregate <- ddply(stormdata_ev, .(year, evCategory), summarize, fatalities = sum(fatalities), 
    injuries = sum(injuries))
## reshape aggregate for plotting in the same plot
mhealth_aggregate <- melt(health_aggregate, id = c("year", "evCategory"))
```

# Results
**Property Damage**  
Plot property damage amount (in millions) across years. Color of each segment corresponds to event category. 
Contains data from 1993-2011

```r
g <- ggplot(data = prop_dmg_aggregate, aes(x = year, y = totPropDamage, fill = evCategory)) + 
    geom_bar(stat = "identity", colour = "black")
g <- g + xlab("Year") + ylab("Property Damage in $Billion ") + labs(title = "Property damage by year and category")
print(g)
```

![plot of chunk propplot](figure/propplot.png) 

**Crop Damage** 
Plot crop damage amount (in millions) across years. Color of each segment corresponds to event category. 
Contains data from 1993-2011

```r
g <- ggplot(data = crop_dmg_aggregate, aes(x = year, y = totCropDamage, fill = evCategory)) + 
    geom_bar(stat = "identity", colour = "black")
g <- g + xlab("Year") + ylab("Crop Damage in $Billion ") + labs(title = "Crop damage by year and category")
print(g)
```

![plot of chunk cropplot](figure/cropplot.png) 

**Injuries & Fatalities**  
Plot injuries and fatalities across years. Color of each segment corresponds to event category. 

```r
g <- ggplot(data = mhealth_aggregate, aes(x = year, y = value, fill = evCategory)) + 
    geom_bar(stat = "identity", colour = "black")
g <- g + facet_wrap(~variable, scale = "free", nrow = 2, ncol = 1)
g <- g + xlab("Year") + ylab("Fatalities Count ") + labs(title = "Injuries/Fatalities by Category by year")
g <- g + theme(text = element_text(size = 10), axis.text.x = element_text(angle = 90, 
    vjust = 1))
print(g)
```

![plot of chunk healthplot](figure/healthplot.png) 

## Top event categories
**Property Damage**

```r
prop_dmg_aggregate_top <- ddply(stormdata_good_prop_ev, .(evCategory), summarize, 
    totPropDamage = sum(propdmgamt))
## Property damage amount in Billions
arrange(prop_dmg_aggregate_top, desc(totPropDamage))
```

```
##            evCategory totPropDamage
## 1 Rain/Flood/HighSeas     1.603e+02
## 2          Convection     9.080e+01
## 3   Heat/Drought/Fire     4.463e+00
## 4            Cold/Ice     1.370e+00
## 5           Lightning     8.465e-01
## 6                Dust     5.824e-03
## 7     Volcano/Tsunami     3.762e-03
```

**Crop Damage**

```r
crop_dmg_aggregate_top <- ddply(stormdata_good_crop_ev, .(evCategory), summarize, 
    totCropDamage = sum(cropdmgamt))
## Crop damage amount in Billions
arrange(crop_dmg_aggregate_top, desc(totCropDamage))
```

```
##            evCategory totCropDamage
## 1          Convection     12.982693
## 2 Rain/Flood/HighSeas     12.535303
## 3   Heat/Drought/Fire      9.831934
## 4            Cold/Ice      2.803785
## 5           Lightning      0.008565
## 6                Dust      0.002100
## 7     Volcano/Tsunami      0.000000
```

**Injuries & Fatalities**

```r
health_aggregate_top <- ddply(stormdata_ev, .(evCategory), summarize, fatalities = sum(fatalities), 
    injuries = sum(injuries))
## Order By Fatalities
arrange(health_aggregate_top, desc(fatalities))
```

```
##            evCategory fatalities injuries
## 1          Convection       3293    37219
## 2   Heat/Drought/Fire       3206    10521
## 3 Rain/Flood/HighSeas       2348     9771
## 4            Cold/Ice        877     4477
## 5           Lightning        807     5214
## 6                Dust         24      483
## 7     Volcano/Tsunami          1        0
```

```r
print(xtable(arrange(health_aggregate_top, desc(fatalities)), digits = 0), type = "html", 
    include.rownames = FALSE)
```

```
## <!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
## <!-- Wed May 21 21:42:45 2014 -->
## <TABLE border=1>
## <TR> <TH> evCategory </TH> <TH> fatalities </TH> <TH> injuries </TH>  </TR>
##   <TR> <TD> Convection </TD> <TD align="right"> 3293 </TD> <TD align="right"> 37219 </TD> </TR>
##   <TR> <TD> Heat/Drought/Fire </TD> <TD align="right"> 3206 </TD> <TD align="right"> 10521 </TD> </TR>
##   <TR> <TD> Rain/Flood/HighSeas </TD> <TD align="right"> 2348 </TD> <TD align="right"> 9771 </TD> </TR>
##   <TR> <TD> Cold/Ice </TD> <TD align="right"> 877 </TD> <TD align="right"> 4477 </TD> </TR>
##   <TR> <TD> Lightning </TD> <TD align="right"> 807 </TD> <TD align="right"> 5214 </TD> </TR>
##   <TR> <TD> Dust </TD> <TD align="right"> 24 </TD> <TD align="right"> 483 </TD> </TR>
##   <TR> <TD> Volcano/Tsunami </TD> <TD align="right"> 1 </TD> <TD align="right"> 0 </TD> </TR>
##    </TABLE>
```




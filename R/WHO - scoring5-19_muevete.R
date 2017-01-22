#====================================================================
# WHO - Scoring
#====================================================================

#====================================================================
# Set working directory
#====================================================================

setwd("C:/Users/sa.gonzalez68/Dropbox/Ciclovia_Ni?os/Analisis/Bases de datos")
setwd("E:/Epiandes") # Manuel
setwd("C:/Users/Manuel/Dropbox/1. Mis documentos/1. Medicina/Epiandes - Scoring")

#====================================================================
# Load libraries
#====================================================================

library(haven)
library(dplyr)
library(lubridate)
library(readr)

#====================================================================
# WHo
#====================================================================

wfawho2007<-read.table("WHO_igrowup5-19\\wfawho2007.txt",header=T,sep="",skip=0)
hfawho2007<-read.table("WHO_igrowup5-19\\hfawho2007.txt",header=T,sep="",skip=0)
bfawho2007<-read.table("WHO_igrowup5-19\\bfawho2007.txt",header=T,sep="",skip=0)

source("WHO_igrowup5-19\\who2007.r")

#====================================================================
# Scoring for baseline - muevete
#====================================================================

df <- read_csv("./data/muevete0/muevete0.csv",
               col_types = cols(
                 Id_0 = col_character(),
                 Sex = col_integer(),
                 age = col_character(),
                 weight = col_double(),
                 lenhei = col_double(),
                 Oedema = col_character(),
                 Sw = col_integer(),
                 Measure = col_character()
               )) %>% 
  rename(ID_0 = Id_0,
         SEX = Sex,
         AGE_MONTHS = age,
         WEIGHT = weight,
         HEIGHT = lenhei,
         MEASURE = Measure,
         OEDEMA = Oedema,
         SW = Sw) %>%
  as.data.frame()

names(df)[1] <- "FECHA_0"

who2007(FilePath=getwd(), 
        FileLab= paste0("./output/Z-scores_muevete0_",Sys.Date()),
        mydf=df,
        sex=SEX,
        age=AGE_MONTHS,
        weight=WEIGHT, 
        height=HEIGHT,
        #measure=MEASURE,
        oedema=OEDEMA,
        sw = SW)


read_csv("./output/Z-scores_muevete0_2017-01-22_z.csv")

#====================================================================
# Scoring for .... - muevete
#====================================================================

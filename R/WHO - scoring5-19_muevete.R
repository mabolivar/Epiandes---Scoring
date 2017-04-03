#'====================================================================
#' WHO - Scoring
#'====================================================================

#'====================================================================
# Set working directory ----------------------------------------------
#'====================================================================

setwd("C:/Users/sa.gonzalez68/Dropbox/Ciclovia_Ni?os/Analisis/Bases de datos")
setwd("E:/Epiandes") # Manuel
setwd("C:/Users/Manuel/Dropbox/1. Mis documentos/1. Medicina/Epiandes - Scoring")

#'====================================================================
# Load libraries -----------------------------------------------------
#'====================================================================

library(haven)
library(dplyr)
library(lubridate)
library(readr)

#'====================================================================
# WHO ----------------------------------------------------------------
#'====================================================================

wfawho2007<-read.table("WHO_igrowup5-19\\wfawho2007.txt",header=T,sep="",skip=0)
hfawho2007<-read.table("WHO_igrowup5-19\\hfawho2007.txt",header=T,sep="",skip=0)
bfawho2007<-read.table("WHO_igrowup5-19\\bfawho2007.txt",header=T,sep="",skip=0)

source("WHO_igrowup5-19\\who2007.r")

#'===================================================================
# Scoring for baseline - muevete ------------------------------------
#'===================================================================

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

#'===================================================================
# Scoring for T1 - muevete -------------------------------------------
#'===================================================================

df_t1 <- read_csv("./data/muevete1/muevete1.csv",
               col_types = cols(
                 Id_3 = col_character(),
                 Sexo = col_integer(),
                 Dob = col_character(), # Day of birth?
                 Dom = col_character(), # Day of measure?
                 Weight_3 = col_double(),
                 Height_3 = col_double(),
                 Oedema = col_character(),
                 Sw = col_integer()
                 #Measure = col_character()
               )) %>% 
  mutate(AGE_MONTHS = time_length(mdy(Dom)-mdy(Dob),unit = "month"),
         MEASURE = "H") %>%
  select(1,Id_3,Sexo,AGE_MONTHS,Weight_3,Height_3,Oedema,Sw) %>%
  rename(ID_3 = Id_3,
         SEX = Sexo,
         WEIGHT = Weight_3,
         HEIGHT = Height_3,
         OEDEMA = Oedema,
         SW = Sw) %>%
  as.data.frame()

names(df_t1)[1] <- "FECHA_3"

who2007(FilePath=getwd(), 
        FileLab= paste0("./output/Z-scores_muevete1_",Sys.Date()),
        mydf=df_t1,
        sex=SEX,
        age=AGE_MONTHS,
        weight=WEIGHT, 
        height=HEIGHT,
        #measure=MEASURE,
        oedema=OEDEMA,
        sw = SW)


read_csv("./output/Z-scores_muevete1_2017-02-18_z.csv") %>%
  write_csv("./output/Z-scores_muevete1_2017-02-18_z.csv",na = ".")

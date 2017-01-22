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
# Carga de datos
#====================================================================

iscole <-read_sas("ciclovia_all.sas7bdat")
mara <-read_sas("mara123.sas7bdat")
muevete <-read_sas("muevete_baseline.sas7bdat")

df <- muevete %>% select(ID_0,GENERO_0, FECHA_NACIM_0, FECHA_ANTRO_0,
                   PESO1_0,PESO2_0,PESO3_0,
                   ALT1_0,ALT2_0,ALT3_0) %>% #filter(ID_0 == "044107")
  mutate_each_(funs(as.double),c("PESO1_0","PESO2_0","PESO3_0",
               "ALT1_0","ALT2_0","ALT3_0")) %>%
  mutate_each_(funs(mdy),c("FECHA_NACIM_0","FECHA_ANTRO_0")) %>% 
  filter(!(is.na(FECHA_NACIM_0) | is.na(FECHA_ANTRO_0))) %>%
  rowwise() %>%
  transmute(ID_0,
            GENERO_0 = as.integer(GENERO_0),
            AGE_MONTHS = time_length(interval(FECHA_NACIM_0,FECHA_ANTRO_0),"month"),
            WEIGHT = mean(c(PESO1_0,PESO2_0,PESO3_0),na.rm = T),
            HEIGHT = mean(c(ALT1_0,ALT2_0,ALT3_0),na.rm = T),
            MEASURE = "H", #standing height.
            OEDEMA = "N",
            SW = 1) %>% ungroup() %>% 
  filter(complete.cases(.) & AGE_MONTHS >= 12) %>%
  as.data.frame() 

#write_csv(df,"./data/MUEVETE_DF_4_WHO.csv")

df <- read_csv("./data/MUEVETE_DF_4_WHO.csv",
               col_types = cols(
                 ID_0 = col_character(),
                 GENERO_0 = col_integer(),
                 AGE_MONTHS = col_double(),
                 WEIGHT = col_double(),
                 HEIGHT = col_double(),
                 MEASURE = col_character(),
                 OEDEMA = col_character(),
                 SW = col_integer()
               )) %>% as.data.frame()
who2007(FilePath=getwd(), 
        FileLab= paste0("./output/Z-scores_MUEVETE_",Sys.Date()),
        mydf=df,
        sex=GENERO_0,
        age=AGE_MONTHS,
        weight=WEIGHT, 
        height=HEIGHT,
        #measure=MEASURE,
        oedema=OEDEMA,
        sw = SW)



read_csv("Z-scores_MUEVETE.csv_prev.csv")

mat<-cbind.data.frame(df$AGE_MONTHS,as.integer(age.vec),as.double(sex.vec),weight.x,lenhei.x,lorh.vec,lenhei.vec,oedema.vec,sw,stringsAsFactors=F)
names(mat)<-c("age","age.days","sex","weight","len.hei","l.h","clenhei","oedema","sw")


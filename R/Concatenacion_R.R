#====================================================================
# Concatenacion de bases de datos de Ciclovias-ninos
# Autores: Silvia Gonzalez
#          Manuel Bolivar
#====================================================================


#====================================================================
# Set working directory
#====================================================================

setwd("C:/Users/sa.gonzalez68/Dropbox/Ciclovia_Ni?os/Analisis/Bases de datos")
setwd("E:/Epiandes") # Manuel
setwd("C:/Users/IBM_ADMIN/Desktop/Epiandes")

#====================================================================
# Load libraries
#====================================================================

library(haven)
library(dplyr)
library(readr)

#====================================================================
# Carga de datos
#====================================================================

iscole <-read_sas("ciclovia_all.sas7bdat")
mara <-read_sas("mara123.sas7bdat")
muevete <-read_sas("muevete_baseline.sas7bdat")
zscores_muevete <- read_csv("Z-scores_MUEVETE.csv_z.csv")

#====================================================================
# Select variables
#====================================================================

# Iscole
ciclo_iscole<- iscole %>% select(PID = ID_cic,
                                 #SCHOOL_ID = SCID, 
                                 SCHOOL_ID = School_ID_cic,
                                 SEX = gendernew, 
                                 AGE = AgeAtAnthroYr, 
                                 ESTRATO=v1, 
                                 HOUSEINCOME = HouseAnnualIncome,
                                 EDUMOTHER = mother_edu8, 
                                 EDUFATHER = father_edu8, 
                                 AUTOMOBILEs= Automobiles, 
                                 MARITAL_STATUS = Marital_status, 
                                 FREQ_FATHER=v2, 
                                 FREQ_CHILD=v3,
                                 v4a, # Activity
                                 v4b,
                                 v4c,
                                 CICLOMIN=v5,
                                 ACTCICLOMIN = V6, #v6 according variables table
                                 SUNMEAN_MV_EV = SUNmean_mv_EV,
                                 SUNMEAN_V_EV = SUNmean_v_EV,
                                 SUNMEAN_M_EV = SUNmean_m_EV,
                                 SUNMEAN_L_EV = SUNmean_l_EV,
                                 SUNMEAN_S_EV = SUNmean_s_EV,
                                 CRIME = crime,
                                 #ciclovia1, # frecuencia de asistencia a la Ciclovía re-categorizada (check email)
                                 PARKS = parks2,
                                 BMIZ_WHO) %>%
  mutate(SCHOOL_ID = as.character(SCHOOL_ID),
         EDUMOTHER = as.character(EDUMOTHER),
         EDUFATHER = as.character(EDUFATHER)) %>%
  rowwise() %>%
  mutate(PID = as.character(PID),
         ACTCICLOBICI = ifelse(1 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOPAT = ifelse(2 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOCAM = ifelse(3 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOTRO = ifelse(4 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOSCO = ifelse(5 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOSKA = ifelse(6 %in% c(v4a,v4b,v4c),1,0),
         ACTCICLOX = as.character(NA),
         ACTCICLOXX = as.character(NA),
         ACTCICLOMIN = as.numeric(ACTCICLOMIN),
         SOURCE = "ISCOLE")

iscole %>% select(BMIZ_WHO, WHO1,WHO2) %>% print(n=200)


# Mara
names(mara) <- toupper(names(mara))
ciclo_mara <- mara %>% select(PID = ID, 
                              SCHOOL_ID=P60, 
                              SEX = P70,
                              AGE = P69,
                              ESTRATO = P91,
                              HOUSEINCOME = P73,
                              EDUMOTHER = P76,
                              EDUFATHER = P78,
                              AUTOMOBILEs = P74,
                              MARITAL_STATUS = P71,
                              FREQ_FATHER = P92,
                              FREQ_CHILD = V40, 
                              ACTCICLOBICI = V411,
                              ACTCICLOPAT = V412,
                              ACTCICLOCAM = V413,
                              ACTCICLOTRO = V414,
                              ACTCICLOSCO = V415,
                              ACTCICLOSKA = V416,
                              ACTCICLOX = V417,
                              ACTCICLOXX = V418,
                              CICLOMIN = V43,
                              ACTCICLOMIN = V44,
                              SUNMEAN_MV_EV,
                              SUNMEAN_V_EV,
                              SUNMEAN_M_EV,
                              SUNMEAN_L_EV,
                              SUNMEAN_S_EV,
                              CRIME = P895,
                              BMIZ_WHO = ZBMI) %>%
  mutate(PID = as.character(PID),
         SEX = SEX-1,
         SCHOOL_ID= ifelse(SCHOOL_ID=="manuelita saenz","387", 
                           ifelse(SCHOOL_ID == "montebello","386",
                                  "346")),
         ACTCICLOX = as.character(ACTCICLOX),
         SOURCE = "MARA")
mara %>% select(ZBMI)

# Muevete
names(muevete) <- toupper(names(muevete))
ciclo_muevete <- muevete %>% 
  left_join(zscores_muevete %>% 
              select(ID_0,zbfa),
            by = "ID_0") %>%
  select(PID = ID_0,
         SCHOOL_ID = COLEGIO_0,
         SEX = GENERO_0,
         AGE = EDAD_0,
         ESTRATO = ESTRATO_0,
         EDUMOTHER = EDUCMA_0,
         EDUFATHER = EDUCPA_0,
         AUTOMOBILEs = VEHIMOTO_0,
         MARITAL_STATUS = ESTCIVIL_0,
         FREQ_FATHER = CICLODIAPAD_0,
         FREQ_CHILD = CICLODIA_0,
         ACTCICLOBICI = ACTCICLOBICI_0,
         ACTCICLOPAT = ACTCICLOPAT_0,
         ACTCICLOCAM = ACTCICLOCAM_0,
         ACTCICLOTRO = ACTCICLOTRO_0,
         ACTCICLOSCO = ACTCICLOSCO_0,
         ACTCICLOSKA = ACTCICLOSKA_0,
         ACTCICLOX = ACTCICLOX_0,
         ACTCICLOXX = ACTCICLOXX_0,
         CICLOMIN = CICLOMIN_0,
         ACTCICLOMIN = ACTCICLOMIN_0,
         #SUNMEAN_MV_EV,
         #SUNMEAN_V_EV,
         #SUNMEAN_M_EV,
         #SUNMEAN_L_EV,
         #SUNMEAN_S_EV,
         #CRIME,
         BMIZ_WHO = zbfa) %>%
  mutate(SEX = as.numeric(SEX)-1,
         AGE = as.numeric(AGE),
         ESTRATO = as.numeric(ESTRATO),
         AUTOMOBILEs = as.numeric(AUTOMOBILEs),
         MARITAL_STATUS = as.numeric(MARITAL_STATUS),
         FREQ_FATHER = as.numeric(FREQ_FATHER),
         FREQ_CHILD = as.numeric(FREQ_CHILD),
         ACTCICLOBICI = as.numeric(ACTCICLOBICI),
         ACTCICLOPAT = as.numeric(ACTCICLOPAT),
         ACTCICLOCAM = as.numeric(ACTCICLOCAM),
         ACTCICLOTRO = as.numeric(ACTCICLOTRO),
         ACTCICLOSCO = as.numeric(ACTCICLOSCO),
         ACTCICLOSKA = as.numeric(ACTCICLOSKA),
         CICLOMIN = as.numeric(CICLOMIN),
         ACTCICLOMIN = as.numeric(ACTCICLOMIN),
         SOURCE = "MUEVETE")


bind_df <- ciclo_iscole %>% 
  bind_rows(ciclo_mara) %>% 
  bind_rows(ciclo_muevete %>%
              filter(!(PID %in% c("054122","054124","104309","104323")))) %>%
  mutate_each_(funs(as.numeric),
               c("SEX", "AGE", "ESTRATO", "HOUSEINCOME", "EDUMOTHER", 
                 "EDUFATHER", "AUTOMOBILEs", "MARITAL_STATUS", "FREQ_FATHER", 
                 "FREQ_CHILD", "v4a", "v4b", "v4c", "CICLOMIN", "ACTCICLOMIN", 
                 "SUNMEAN_MV_EV", "SUNMEAN_V_EV", "SUNMEAN_M_EV", "SUNMEAN_L_EV", 
                 "SUNMEAN_S_EV", "CRIME", "PARKS", "BMIZ_WHO", "ACTCICLOBICI", 
                 "ACTCICLOPAT", "ACTCICLOCAM", "ACTCICLOTRO", "ACTCICLOSCO", "ACTCICLOSKA"))


write_csv(bind_df, "iscole_mara_muevete_conc_20160727.csv")

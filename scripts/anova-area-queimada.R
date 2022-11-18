# Analise de variancia 2 way entre parques e entre periodos (el nino, la nina, neutro) com variavel dependente percentagem ou proporcao queimada
# por ano. Transformacao arcoseno para normalizar dados proporcao
library(readxl)
anova_area_queimada_parque_enso <- read_excel("dados/anova-area-queimada-parque-enso.xlsx", 
                                              col_types = c("text", "numeric", "text", 
                                                            "text", "numeric", "numeric", "numeric"))
View(anova_area_queimada_parque_enso)
parquesqueimada<- anova_area_queimada_parque_enso

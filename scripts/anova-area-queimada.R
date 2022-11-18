# Analise de variancia 2 way entre parques e entre periodos (el nino, la nina, neutro) com variavel dependente percentagem ou proporcao queimada
# por ano. Transformacao arcoseno para normalizar dados proporcao
#
usethis::use_git_config(user.name = "Roberto Cavalcanti", user.email = "rbcer10@gmail.com")
credentials::set_github_pat("YOURPATCODEHERE")
#
library(readxl)
anova_area_queimada_parque_enso <- read_excel("dados/anova-area-queimada-parque-enso.xlsx", 
                                              col_types = c("text", "numeric", "text", 
                                                            "text", "numeric", "numeric", "numeric"))
View(anova_area_queimada_parque_enso)
parquesqueimada<- anova_area_queimada_parque_enso

library(readxl)
no_missing_anova_area_queimada_parque_enso <- read_excel("dados/no-missing-anova-area-queimada-parque-enso.xlsx")
View(no_missing_anova_area_queimada_parque_enso)
parques_queima <- no_missing_anova_area_queimada_parque_enso
boxplot(percentagem~parque, data=parques_queima)
boxplot(percentagem~tipo, data=parques_queima)
boxplot(percentagem~local, data=parques_queima)
# add arcsine transform  variable n quad queimado
#https://www.statology.org/arcsine-transformation-in-r/#:~:text=An%20arcsine%20transformation%20can%20be,dealing%20with%20proportions%20and%20percentages.&text=The%20following%20examples%20show%20how%20to%20use%20this%20syntax%20in%20practice.
parqueim <- nome_int_no_missing_anova_area_queimada_parque_enso
parqueim %>% 
  mutate(arcsenquei = asin(sqrt(propqueim)))

# Analise de variancia 2 way entre parques e entre periodos (el nino, la nina, neutro) com variavel dependente percentagem ou proporcao queimada
# por ano. Transformacao arcoseno para normalizar dados proporcao
# packages used: lawstat tidyverse car readxl
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
# run two way anova parques e el nino  
#remove pe jalapao from dataframe and create dataframe parquenj
parquenj <- parqueim %>%  filter(parque!='jalapao')
#remove externals from parquenj dataframe and create dataframe parquint
parquint <- parquenj %>%  filter(local!='ext')
# agora two way anova 3 parques arcsin transform internal
parquint2 <- parquint %>% 
  mutate(arcsenquei = asin(sqrt(propqueim)))
anova2w<-aov(arcsenquei ~ parque+tipo+parque:tipo, parquint2)
summary(anova2w)
#efeito nao significativo entre parques, 6% signif efeito el nino
#agora repetir a analise incluindo as areas externas
parquenj2 <- parquenj %>% 
  mutate(arcsenquei = asin(sqrt(propqueim)))
anova2wtudo<-aov(arcsenquei ~ parque+tipo+parque:tipo, parquenj2)
summary(anova2wtudo)
interaction.plot(parquenj2$parque, parquenj2$tipo, parquenj2$arcsenquei)
#testando homoscedascidade e normalidade
shapiro.test(resid(anova2wtudo))
levene.test(parquenj2$arcsenquei, parquenj2$parque)
levene.test(parquenj2$arcsenquei, parquenj2$tipo)
#repetindo com logit transformation
parquenj3 <- parquenj %>% 
  mutate(logitquei = logit(propqueim))
anova3wtudo<-aov(logitquei ~ parque+tipo+parque:tipo, parquenj3)
summary(anova3wtudo)
interaction.plot(parquenj3$parque, parquenj3$tipo, parquenj3$percentqueim)
#testando homoscedascidade e normalidade agora sim ambos aceitos
shapiro.test(resid(anova3wtudo))
leveneTest(parquenj3$logitquei, parquenj3$parque)
leveneTest(parquenj3$logitquei, parquenj3$tipo)
#agora ver se ha efeito significativo dentro vs fora
anova2wlocal<-aov(arcsenquei ~ parque+local+parque:local, parquenj2)
summary(anova2wlocal)
#nao ha diferencas significativas interno vs externo mas sim entre parques
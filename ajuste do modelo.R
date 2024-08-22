setwd("C:/Users/gmore/OneDrive/Desktop/MCCD/stan")

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

data_stan <- list(K = 3 , # deve ser sempre 3 pois o numero de classificações dos jogos
                  G = 370 , # numero de jogos
                  T = 20 , # numero de times
                  h = treino$indice_mandante , # vetor de indice para time mandante
                  a = treino$indice_visitante , # vetor de indice de time visitante
                  R = treino$R) # vetor de resultados das partidas deve ser 1 se o time visitante, 2 se empate e 3 se vitoria time mandante

# para usar essa opção deve ter rtools configurado 
modelo<- stan_model(file = "logit_fut2.stan")

fit <- sampling(modelo, data = data_stan, cores = 2, chains = 2)
fit
shinystan::launch_shinystan(fit)
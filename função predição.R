predict <- function(fit, new_data) {
  
  # Extraindo os dados do modelo ajustado
  fit_data <- rstan::extract(fit)
  level <- fit_data$level
  c <- fit_data$c
  
  #iniciar vetor de resultados
  resultados <- vector("integer", nrow(new_data))
  
  # Loop através de cada linha do new_data
  for (g in 1:nrow(new_data)) {
    
    # Inicializa a matriz de probabilidades
    prob_jogos <- matrix(0, nrow = nrow(level), ncol = ncol(c) + 1)
    
    # Pega os valores das colunas 'h' e 'a'
    h <- new_data$h[g]
    a <- new_data$a[g]
    
    # Verifica se 'h' e 'a' estão dentro dos índices válidos
    if (h <= ncol(level) && a <= ncol(level)) {
      eta_aux <- level[, h] - level[, a]
      
      # Calcula as probabilidades
      prob_jogos[, 1] <- exp(c[, 1] + eta_aux) / (1 + exp(c[, 1] + eta_aux))
      prob_jogos[, 2] <- (exp(c[, 2] + eta_aux) / (1 + exp(c[, 2] + eta_aux))) - prob_jogos[, 1]
      prob_jogos[, 3] <- 1 - (prob_jogos[, 2] + prob_jogos[, 1])
      resultado_bruto <- vector("integer", nrow(prob_jogos))
      for (i in 1:nrow(prob_jogos)) {
        prob <- prob_jogos[i, ]
        sorteio <- sample(1:3, size = 1, prob = prob)
        resultado_bruto[i] <- sorteio
      }
      frequencias <- table(resultado_bruto)
      moda <- as.numeric(names(frequencias)[frequencias == max(frequencias)])
      resultados[g] <- moda
      
    } else {
      warning(paste("Não existe time com este indice na linha", g))
    }
  }
  
  # Adiciona os resultados ao new_data
  tabela <- cbind(new_data, R = resultados)
  return(tabela)
}

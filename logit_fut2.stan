data {
  int<lower = 2> K; //quantidade de classes, nesse caso será 3 pois é derrota, empate e vitoria 
  int<lower = 1> G; // numero de jogos modelo poisson == numero de observações do modelo logit
  int<lower = 1> T; // numero de times
  int<lower = 0,upper = T> h[G]; // time da casa do jogo G
  int<lower = 0,upper = T> a[G]; // time visitante do jogo G
  int<lower = 1 , upper = K> R[G]; //vetor de resultados dos jogos
}
parameters {
  real<lower = 0> sigma_level; //estimativa da variancia dos efeitos de ataque
  vector[T] level; //estimativa do level de ataque de cada time 
  ordered[K-1] c; //estimativa dos pontosde corte ,variavel latente
}
model {
  for(g in 1:G) {
    R[g] ~ ordered_logistic(-level[h[g]] +level[a[g]] , c);
  }
  level ~ normal(0 , sigma_level);
}


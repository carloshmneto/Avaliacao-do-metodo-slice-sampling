# Biblioteca necessária
library(MASS)

# Determinando a semente aleatória
set.seed(123)

# Função para determinar a constante do método de rejeição
determine_c <- function(f, g, min, max, n_points = 1000) {
  x_values <- seq(min, max, length.out = n_points)
  ratios <- f(x_values) / g(x_values)
  return(max(ratios, na.rm = TRUE))
}

# Função para gerar amostras usando o método de rejeição
rejection_sampling <- function(n, f, g, g_sample, min, max) {
  c <- determine_c(f, g, min, max)
  samples <- numeric(n)
  for (i in 1:n) {
    repeat {
      x <- g_sample()
      u <- runif(1)
      if (u <= f(x) / (c * g(x))) {
        samples[i] <- x
        break
      }
    }
  }
  return(samples)
}

# Função para gerar amostras usando o método de slice sampling
sliceSample = function (n, f, x.interval = c(0, 1), root.accuracy = 0.01) {
  samples = vector("numeric", n)
  x = runif(1, x.interval[1], x.interval[2]) # Define o x0.
  
  for (i in 1:n) {
    samples[i] = x
    y = runif(1, 0, f(x)) # Seleciona o y no intervalo aleatório
    
    fshift = function (x) { f(x) - y }
    roots = c()
    for (j in seq(x.interval[1], x.interval[2] - root.accuracy, by = root.accuracy)) {
      if ((fshift(j) < 0) != (fshift(j + root.accuracy) < 0)) {
        root = uniroot(fshift, c(j, j + root.accuracy))$root
        roots = c(roots, root)
      }
    }
    roots = c(x.interval[1], roots, x.interval[2])
    
    segments = matrix(ncol = 2)
    for (j in 1:(length(roots) - 1)) {
      meio = (roots[j + 1] + roots[j]) / 2.0
      if (f(meio) > y) {
        
        segments = rbind(segments, c(roots[j], roots[j + 1]))
      }
    }
    
    total = sum(sapply(2:nrow(segments), function (i) {
      segments[i, 2] - segments[i, 1]
    }))
    probs = sapply(2:nrow(segments), function (i) {
      (segments[i, 2] - segments[i, 1]) / total
    })
    
    p = runif(1, 0, 1)
    selectSegment = function (x, i) {
      if (p < x) return(i)
      else return(selectSegment(x + probs[i + 1], i + 1))
    }
    seg = selectSegment(probs[1], 1)
    
    x = runif(1, segments[seg + 1, 1], segments[seg + 1, 2])
  }
  
  return(samples)
}

## - Base de dados 1 - ##
base_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
csv_path <- file.path(base_dir, "dados", "all_seasons.csv")

data <- read.csv(csv_path)

player_height <- na.omit(as.numeric(data$player_height))

fit <- fitdistr(player_height, "normal")
fit$estimate

# Teste de Kolmogorov-Smirnov: verificar se a distribuição dos dados é normal
ks.test(player_height, "pnorm", mean = fit$estimate[1], sd = fit$estimate[2])

density_est <- density(player_height)
plot(density_est, main = "Estimativa de densidade da altura dos jogadores")

# Função de densidade alvo baseada na estimativa kernel
f <- approxfun(density_est$x, density_est$y, rule = 2)

maximo <- max(player_height)
minimo <- min(player_height)

# Definindo a função da distribuição proposta g(x)
g <- function(x) { dunif(x, min=minimo, max=maximo) }
g_sample <- function() { runif(1, min = minimo, max = maximo) }

#Rejeição Clássica
start_time <- Sys.time()

samples <- rejection_sampling(500, f, g, g_sample, minimo, maximo)
hist(samples, breaks = 30, probability = TRUE,
     xlab="Altura", ylab="Densidade", main="Método de Rejeição Clássico")
curve(f, add = TRUE, col = "red")

end_time <- Sys.time()
execution_time <- end_time - start_time
execution_time

#Slice Sampling
start_time <- Sys.time()

points = sliceSample(n = 500, f, x.interval=c(minimo, maximo))
hist(points, breaks=30, probability = TRUE,
     xlab="Altura", ylab="Densidade", main="Método de Slice Sample")
curve(f, add = TRUE, col="red")

end_time <- Sys.time()
execution_time <- end_time - start_time
execution_time

## - Base de dados 2 - ##
base_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
csv_path <- file.path(base_dir, "dados", "boxoffice.csv")

data2 <- read.csv(csv_path)

boxoffice <- na.omit(as.numeric(data2$lifetime_gross))

boxoffice_filtered <- boxoffice[boxoffice < 100000]

density_est2 <- density(boxoffice_filtered)
plot(density_est2, main = "Estimativa de densidade da bilheteria dos filmes")

# Função de densidade alvo baseada na estimativa kernel
f2 <- approxfun(density_est2$x, density_est2$y, rule = 2)

maximo2 <- max(boxoffice_filtered)
minimo2 <- min(boxoffice_filtered)

# Definindo a função da distribuição proposta g(x)
g2 <- function(x) { dunif(x, min=minimo2, max=maximo2) }
g2_sample <- function() { runif(1, min = minimo2, max = maximo2) }

#Rejeição Clássica
start_time <- Sys.time()
samples <- rejection_sampling(500, f2, g2, g2_sample, minimo2, maximo2)
hist(samples, breaks = 45, probability = TRUE,
     xlab="Bilheteria", ylab="Densidade", main="Método de Rejeição Clássico")
curve(f2, add = TRUE, col = "red")

end_time <- Sys.time()
execution_time <- end_time - start_time
execution_time

#Slice Sampling
start_time <- Sys.time()
points = sliceSample(n = 500, f2, x.interval=c(minimo2, maximo2), root.accuracy = 0.5)
hist(points, breaks=45, probability = TRUE,
     xlab="Bilheteria", ylab="Densidade", main="Método de Slice Sample")
curve(f2, add = TRUE, col="red")

end_time <- Sys.time()
execution_time <- end_time - start_time
execution_time
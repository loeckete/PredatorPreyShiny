# Independent base-R model; densities are continuous, time units are arbitrary.
simulate_pp <- function(r=.5, a=.02, b=.2, m=.2, K=100,
                        N0=40, P0=9, duration=100, logistic=FALSE, dt=.01) {
  args <- c(r,a,b,m,K,N0,P0,duration,dt)
  stopifnot(all(is.finite(args)), all(args[1:5]>0), N0>=0, P0>=0,
            duration>0, dt>0)
  present <- c(N0,P0)>0
  y <- log(pmax(c(N0,P0), 1e-300))
  rates <- function(z) {
    pop <- exp(z) * present
    if (any(!is.finite(pop)) || any(pop>1e9))
      stop('Population exceeded the plotting range. Shorten the time span or reduce growth.')
    c(r * (if (logistic) 1-pop[1]/K else 1) - a*pop[2],
      b*a*pop[1]-m) * present
  }
  times <- seq(0, duration, length.out=1001)
  out <- matrix(0, length(times), 3)
  out[1,] <- c(0,N0,P0)
  t <- 0
  steps <- 0L
  for (i in 2:length(times)) {
    while (t < times[i]-1e-12) {
      k1 <- rates(y)
      h <- min(dt, times[i]-t, .05/max(1,abs(k1)))
      k2 <- rates(y+h*k1/2)
      k3 <- rates(y+h*k2/2)
      k4 <- rates(y+h*k3)
      y <- y+h*(k1+2*k2+2*k3+k4)/6
      t <- t+h
      steps <- steps+1L
      if (steps>500000L) stop('This run is too demanding. Shorten the time span.')
    }
    out[i,] <- c(times[i],exp(y)*present)
  }
  colnames(out) <- c('time','prey','predator')
  as.data.frame(out)
}

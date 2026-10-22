source('model.R')
# Exact coexistence equilibrium for the classic model.
d <- simulate_pp(N0=50,P0=25)
stopifnot(max(abs(d$prey-50))<1e-8,max(abs(d$predator-25))<1e-8)
# Analytic boundary cases, including preservation of an absent population.
d <- simulate_pp(P0=0,duration=10)
stopifnot(max(abs(d$prey-40*exp(.5*d$time)))<1e-6,all(d$predator==0))
d <- simulate_pp(N0=0,duration=10)
stopifnot(all(d$prey==0),max(abs(d$predator-9*exp(-.2*d$time)))<1e-8)
d <- simulate_pp(P0=0,logistic=TRUE,duration=30)
exact <- 100/(1+(100/40-1)*exp(-.5*d$time))
stopifnot(max(abs(d$prey-exact))<1e-6)
# Numerical convergence and conserved LV quantity.
d <- simulate_pp(); fine <- simulate_pp(dt=.005)
stopifnot(max(abs(d$prey-fine$prey))<1e-4,
          max(abs(d$predator-fine$predator))<1e-4)
H <- .2*.02*d$prey-.2*log(d$prey)+.02*d$predator-.5*log(d$predator)
stopifnot(diff(range(H))<1e-6,all(d$prey>0),all(d$predator>0))
# Logistic coexistence and low-K predator decline.
d <- simulate_pp(logistic=TRUE,N0=50,P0=12.5)
stopifnot(max(abs(d$prey-50))<1e-8,max(abs(d$predator-12.5))<1e-8)
d <- simulate_pp(logistic=TRUE,K=25,duration=150)
stopifnot(tail(d$predator,1)<.001,abs(tail(d$prey,1)-25)<.01)
parse('app.R')
cat('All model checks passed; app.R parsed successfully.\n')

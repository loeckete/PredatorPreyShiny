library(shiny)
source('model.R', local=TRUE)

ui <- fluidPage(
  tags$head(tags$style(HTML('
    body {background:#f5f7fa;color:#193343;font-size:17px}
    .container-fluid {max-width:1250px;margin:auto}
    h1,h2,h3 {font-weight:700} .well {background:white;border-radius:12px}
    .prompt {background:#e5f3f0;border-left:5px solid #007e78;padding:16px;margin:18px 0}
    .btn-primary {background:#007e78;border-color:#007e78}
    .tab-content {background:white;padding:16px;border-radius:0 0 12px 12px}
    .help-block {color:#425967}'))),
  titlePanel('Why don’t predators eat all their prey?'),
  p('ENSCI 3120 | Predict → test → explain → revise'),
  div(class='prompt',strong('Before you run: '),
      'Predict which population will peak first. Explain your prediction to a partner. ',
      'Then test it. Change one variable at a time.'),
  sidebarLayout(
    sidebarPanel(width=3,
      selectInput('model','Prey growth model',
                  c('Unlimited resources (classic Lotka–Volterra)'='classic',
                    'Limited resources (logistic prey)'='logistic')),
      sliderInput('N0','Initial prey density (N)',0,150,40,step=1),
      sliderInput('P0','Initial predator density (P)',0,50,9,step=1),
      conditionalPanel("input.model == 'logistic'",
                       sliderInput('K','Prey carrying capacity (K)',10,250,100,step=5)),
      sliderInput('duration','Time span (arbitrary units)',20,150,100,step=10),
      tags$details(tags$summary('Explore model parameters'),
        sliderInput('r','Prey growth rate (r)',.1,1,.5,step=.05),
        sliderInput('a','Attack coefficient (a)',.005,.05,.02,step=.005),
        sliderInput('b','Conversion efficiency (b)',.1,.5,.2,step=.05),
        sliderInput('m','Predator mortality rate (m)',.05,.5,.2,step=.05)),
      actionButton('run','Run simulation',class='btn-primary'),
      br(),br(),actionButton('reset','Reset controls'),
      helpText('Press Run after changing controls. Reset restores the starting controls; press Run to apply them.'),
      helpText('Densities are illustrative, not measured animal counts. Time is not calibrated to days.')
    ),
    mainPanel(width=9,
      textOutput('settings'),
      tabsetPanel(
        tabPanel('Populations through time',
          plotOutput('series',height='430px'),
          p('Look for the order of peaks, the depth of declines, and whether cycles keep the same amplitude.'),
          downloadButton('csv','Download run data')),
        tabPanel('Predator–prey relationship',
          checkboxInput('lines','Show zero-growth lines',FALSE),
          plotOutput('phase',height='430px'),
          p('Follow the arrows forward in time. The filled point is the starting state; the open point is the final state.'),
          p('Zero-growth lines show where one population stops increasing or decreasing. Their intersection is an equilibrium, not a guarantee that the populations are currently there.')),
        tabPanel('Classroom investigations',
          h3('1 · Explain a delay'),
          p('Run the default model. Which population peaks first? Why can predators still increase after prey begin to decline? Use a specific part of the graph as evidence.'),
          h3('2 · Change the starting point'),
          p('Keep the classic model and all rates fixed. Predict what changing initial prey from 40 to 80 will do. Run it and compare the pattern with the default run. Does changing the starting density change the zero-growth thresholds?'),
          h3('3 · Bring back carrying capacity'),
          p('Reset controls. Select limited resources, with K = 100, and run. Compare with the default classic model. Then change only K to 25. Predict whether predators can persist before running.'),
          h3('4 · Evaluate the model'),
          p('Name one mechanism from the reading that this model omits. Explain which assumption it would change and predict how the result might differ.'),
          p(strong('Submit your explanations through Top Hat. This app does not collect responses.'))),
        tabPanel('Equations and assumptions',
          h3('Classic Lotka–Volterra'),
          tags$pre('dN/dt = rN − aNP\ndP/dt = baNP − mP'),
          h3('Add a limit to prey growth'),
          tags$pre('dN/dt = rN(1 − N/K) − aNP\ndP/dt = baNP − mP'),
          p('N = prey density; P = predator density; r = prey per-capita growth rate; a = attack coefficient; b = conversion efficiency; m = predator per-capita mortality rate; K = prey carrying capacity in the absence of predators.'),
          p('Both models assume a specialist predator, homogeneous mixing, no immigration, no age or body-size structure, and no predator satiation. The logistic version adds prey resource limitation only.'),
          p('These are continuous-time models. Numerical time steps approximate the equations; they are not discrete generations.'),
          p('With positive starting densities, classic Lotka–Volterra has neutral cycles around coexistence, except at equilibrium. It does not produce attraction to one unique cycle. Very small densities are not the same as modeled extinction.'),
          p('The app is a conceptual model, not a fitted forecast for zebra mussels or any particular species.'),
          p('Inspired by ',tags$a(href='https://ecoevoapps.gitlab.io/docs/articles/predator-prey-interactions.html','EcoEvoApps predator–prey teaching models'),'. Original implementation for this course.'))
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$reset, {
    updateSelectInput(session,'model',selected='classic')
    defaults <- list(N0=40,P0=9,K=100,duration=100,r=.5,a=.02,b=.2,m=.2)
    for (id in names(defaults)) updateSliderInput(session,id,value=defaults[[id]])
    updateCheckboxInput(session,'lines',value=FALSE)
  })
  run <- eventReactive(input$run, {
    p <- list(r=input$r,a=input$a,b=input$b,m=input$m,K=input$K,
              N0=input$N0,P0=input$P0,duration=input$duration,
              logistic=input$model=='logistic')
    d <- tryCatch(do.call(simulate_pp,p),error=function(e)e)
    validate(need(!inherits(d,'error'),if(inherits(d,'error')) conditionMessage(d) else ''))
    list(p=p,d=d)
  },ignoreNULL=FALSE)
  output$settings <- renderText({
    p <- run()$p
    paste0('Displayed run: ',if(p$logistic) paste0('logistic prey; K = ',p$K) else 'classic Lotka–Volterra',
           '; N₀ = ',p$N0,'; P₀ = ',p$P0,'; r = ',p$r,'; a = ',p$a,'; b = ',p$b,'; m = ',p$m,'.')
  })
  output$series <- renderPlot({
    d <- run()$d
    par(mar=c(4.5,4.5,2,1),cex=1.15)
    matplot(d$time,d[,c('prey','predator')],type='l',lty=c(1,2),lwd=3,
            col=c('#007e78','#b34f00'),xlab='Time (arbitrary units)',ylab='Population density',
            ylim=c(0,max(1,d$prey,d$predator)*1.08))
    legend('topright',c('Prey (N)','Predator (P)'),col=c('#007e78','#b34f00'),lty=c(1,2),lwd=3,bty='n')
  },alt='Time series of prey and predator densities. Exact values are available in Download run data.')
  output$phase <- renderPlot({
    d <- run()$d; p <- run()$p
    nx <- p$m/(p$b*p$a); py <- p$r/p$a
    xmax <- max(1,d$prey,if(input$lines) nx*1.1 else 0)
    ymax <- max(1,d$predator,if(input$lines) py*1.1 else 0)
    par(mar=c(4.5,4.5,2,1),cex=1.15)
    plot(d$prey,d$predator,type='l',lwd=2,col='#34495e',
         xlim=c(0,xmax*1.05),ylim=c(0,ymax*1.1),xlab='Prey density (N)',ylab='Predator density (P)')
    ix <- seq(40,960,length.out=12)
    for(j in as.integer(ix)) {
      if(abs(d$prey[j+8]-d$prey[j])+abs(d$predator[j+8]-d$predator[j])>1e-7)
        arrows(d$prey[j],d$predator[j],d$prey[j+8],d$predator[j+8],length=.08,col='#34495e')
    }
    points(d$prey[1],d$predator[1],pch=16,cex=1.5)
    points(tail(d$prey,1),tail(d$predator,1),pch=1,cex=1.8)
    if(input$lines) {
      abline(v=nx,col='#b34f00',lty=2,lwd=2)
      if(p$logistic) {
        xx <- seq(0,min(p$K,xmax*1.05),length.out=100)
        lines(xx,py*(1-xx/p$K),col='#007e78',lty=3,lwd=2)
      } else abline(h=py,col='#007e78',lty=3,lwd=2)
      legend('topright',c('Prey zero growth','Predator zero growth'),
             col=c('#007e78','#b34f00'),lty=c(3,2),lwd=2,bty='n',cex=.85)
    }
  },alt='Phase plot showing prey density on the horizontal axis and predator density on the vertical axis.')
  output$csv <- downloadHandler(filename=function() 'predator-prey-run.csv',content=function(file) {
    x <- run(); d <- x$d
    for(nm in names(x$p)) d[[nm]] <- x$p[[nm]]
    write.csv(d,file,row.names=FALSE)
  })
}
shinyApp(ui,server)

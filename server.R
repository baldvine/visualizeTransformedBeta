#
#

library(shiny)
library(ggplot2)
library(actuar)
library(magrittr)

shinyServer(function(input, output) {
    
    showMean <- reactive({input$showMean})
    paramsFromSlidersOrValues <- 
        reactive({input$paramsFromSlidersOrValues})
    zeroInflated <- reactive({input$p0Value > 1e-12})  # TRUE/FALSE
    limitDistribution <- reactive({input$limitDistribution})
    
    # Get parameters:
    parA.slider <- reactive({input$paramA.slider})
    parB.slider <- reactive({input$paramB.slider})
    parC.slider <- reactive({input$paramC.slider})
    parD.slider <- reactive({input$paramD.slider})
    parA <- reactive({input$paramA})
    parB <- reactive({input$paramB})
    parC <- reactive({input$paramC})
    parD <- reactive({input$paramD})
    
    parameterA <- reactive({
        if (paramsFromSlidersOrValues() == 'useSliders') {
            return(input$paramA.slider)
        } else return(input$paramA)
    })
    
    myP0 <- reactive({input$p0Value})
    
    maxQuantile.limited <- reactive({input$yesLimited})
    maxQuantile.notLimited <- reactive({input$notLimited})
    
    # Set x limits:
    myXlim <- reactive({
        if (input$modifyXlim) {
            return(c(0,input$xlim))
        } else {
            # Plot up to a quantile
            if (paramsFromSlidersOrValues() == 'useSliders') {
                c(0,qtrbeta(p = ifelse(limitDistribution() == 'yesLimited', 
                                       yes = maxQuantile.limited(), 
                                       no = maxQuantile.notLimited()), 
                            shape1 = parA.slider()/parC.slider(),
                            shape2 = parC.slider(),
                            shape3 = parB.slider()/parC.slider(),
                            scale = parD.slider())
                )
            } else {
                c(0,qtrbeta(p = ifelse(limitDistribution() == 'yesLimited', 
                                       yes = maxQuantile.limited(), 
                                       no = maxQuantile.notLimited()),
                            shape1 = parA()/parC(),
                            shape2 = parC(),
                            shape3 = parB()/parC(),
                            scale = parD())
                )
            }
        }
    })
    
    myLineSize <- 2
    myPointSize <- 3
    myThinLineSize <- 0.75*myLineSize
    atomLineColor <- "firebrick"

    output$trbPlot <- renderPlot({
        
        # Compute the mean:
        if (paramsFromSlidersOrValues() == 'useSliders') {
            myMean <- 
                mtrbeta(order = 1, 
                        shape1 = parA.slider()/parC.slider(),
                        shape2 = parC.slider(),
                        shape3 = parB.slider()/parC.slider(),
                        scale = parD.slider())
        } else { 
            myMean <- 
                mtrbeta(order = 1, 
                        shape1 = parA()/parC(),
                        shape2 = parC(),
                        shape3 = parB()/parC(),
                        scale = parD())
        }
        
        myPlotLabel <- paste0("Density function of a ",
                              ifelse(zeroInflated() == TRUE,
                                     yes = "zero-inflated ",
                                     no = ""),
                              ifelse(limitDistribution() == 'yesLimited', 
                                     yes = "limited ", no = ""),
                              "transformed beta")
        
        myPlot <- 
            ggplot(data = data.frame(x = 0, y = 0), mapping = aes(x,y)) +
            ggtitle(label = myPlotLabel,
                    subtitle = paste0("Mean value (FIX!): ", format(myMean, digits = 5, nsmall = 5))) +
            scale_x_continuous(name = "x") +  # , expand = c(0, 0)
            scale_y_continuous(name = "Density", limits = c(0, NA),
                               expand = c(0, 0)) +
            coord_cartesian(clip = 'off') +
            theme(plot.title = element_text(hjust = 0.5, size = 18),
                  plot.subtitle = element_text(hjust = 0.5, size = 16),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 14),
                  axis.line = element_line(color = 'black'),
                  panel.background = element_blank(),
                  panel.border = element_blank(),
                  panel.grid = element_blank())

        if (paramsFromSlidersOrValues() == 'useSliders') {
            myPlot <- myPlot +
                stat_function(fun = function(x){
                    (1-myP0())*dtrbeta(x, 
                                       shape1 = parA.slider()/parC.slider(),
                                       shape2 = parC.slider(),
                                       shape3 = parB.slider()/parC.slider(),
                                       scale = parD.slider())
                },
                xlim = myXlim(), n = 2000,
                color = 'black', size = 1.5)
        } else {
            myPlot <- myPlot +
                stat_function(fun = function(x){
                    (1-myP0())*dtrbeta(x,
                                       shape1 = parA()/parC(),
                                       shape2 = parC(),
                                       shape3 = parB()/parC(),
                                       scale = parD())
                },
                xlim = myXlim(), n = 2000,
                color = 'black', size = 1.5)
        }
        
        if (limitDistribution() == 'yesLimited') {
            myPlot <- myPlot +
                geom_segment(aes(x = max(myXlim()), xend = max(myXlim()), 
                             y = 0, yend = (1 - myP0())*(1 - maxQuantile.limited())), 
                         size = myThinLineSize, color = atomLineColor) +
                geom_point(data = data.frame(x = max(myXlim()), 
                                             y = (1 - myP0())*(1 - maxQuantile.limited())), 
                           size = myPointSize, 
                           color = "black")
        }
        
        if (zeroInflated()) {
            myPlot <- myPlot +
                geom_segment(aes(x = 0, xend = 0, 
                                 y = 0, yend = myP0()), 
                             size = myThinLineSize, color = atomLineColor) +
                geom_point(data = data.frame(x = 0, y = myP0()), 
                           size = myPointSize, 
                           color = "black")
        }
                
        if (showMean()) {
            # Add to plot:
            myPlot <- myPlot +
                geom_vline(xintercept = myMean, color = "red", size = 1.5)
        }
        
        return(myPlot)        
    })
    
})


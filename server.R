#
#

library(shiny)
library(ggplot2)
library(actuar)
library(magrittr)

shinyServer(function(input, output) {
    
    showMean <- reactive({input$showMean})
    paramsFromSliders <- 
        reactive({input$paramsFromSliders})
    
    # Get parameters:
    parA.slider <- reactive({input$paramA.slider})
    parB.slider <- reactive({input$paramB.slider})
    parC.slider <- reactive({input$paramC.slider})
    parD.slider <- reactive({input$paramD.slider})
    parA <- reactive({input$paramA})
    parB <- reactive({input$paramB})
    parC <- reactive({input$paramC})
    parD <- reactive({input$paramD})
    
    # Set x limits:
    myXlim <- reactive({
        if (input$modifyXlim) {
            return(c(0,input$xlim))
        } else {
            # Plot up to the 99th percentile
            if (paramsFromSliders()) {
                c(0,qtrbeta(p = 0.99, 
                            shape1 = parA.slider()/parC.slider(),
                            shape2 = parC.slider(),
                            shape3 = parB.slider()/parC.slider(),
                            scale = parD.slider())
                )
            } else {
                c(0,qtrbeta(p = 0.99,
                            shape1 = parA()/parC(),
                            shape2 = parC(),
                            shape3 = parB()/parC(),
                            scale = parD())
                )
            }
        }
    })

    output$trbPlot <- renderPlot({
        
        # Compute the mean:
        if (paramsFromSliders()) {
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
        
        myPlot <- 
            ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
            ggtitle(label = "Density function of a transformed beta",
                    subtitle = paste0("Mean value: ", format(myMean, digits = 5, nsmall = 5))) +
            xlab("x") + ylab("Density") +
            ylim(c(0, NA)) +
            theme(plot.title = element_text(hjust = 0.5, size = 18),
                  plot.subtitle = element_text(hjust = 0.5, size = 16),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 14),
                  axis.line = element_line(color = 'black'),
                  panel.background = element_blank(),
                  panel.border = element_blank(),
                  panel.grid = element_blank())

        if (paramsFromSliders()) {
            myPlot <- myPlot +
                stat_function(fun = dtrbeta,
                              args = list(shape1 = parA.slider()/parC.slider(),
                                          shape2 = parC.slider(),
                                          shape3 = parB.slider()/parC.slider(),
                                          scale = parD.slider()),
                              xlim = myXlim(),
                              color = 'blue', size = 1)
        } else {
            myPlot <- myPlot +
                stat_function(fun = dtrbeta,
                              args = list(shape1 = parA()/parC(),
                                          shape2 = parC(),
                                          shape3 = parB()/parC(),
                                          scale = parD()),
                              xlim = myXlim(),n = 1000,
                              color = 'blue', size = 1)
        }
                
        if (showMean()) {
            # Add to plot:
            myPlot <- myPlot +
                geom_vline(xintercept = myMean, color = "red")
        }
        
        return(myPlot)        
    })
    
})


#
#

library(shiny)
library(ggplot2)
library(actuar)
library(magrittr)

shinyServer(function(input, output) {
    
    
    # Set x limits:
    myXlim <- reactive({
        if (input$modifyXlim) {
            return(c(0,input$xlim))
        } else {
            return(c(0,1))
        }
    })
    
    showMean <- reactive({input$showMean})
    
    # Get parameters:
    parA <- reactive({input$paramA})
    parB <- reactive({input$paramB})
    parC <- reactive({input$paramC})
    parD <- reactive({input$paramD})
    

    output$trbPlot <- renderPlot({
        
        myMean <- 
            mtrbeta(order = 1, 
                    shape1 = parA()/parC(),
                    shape2 = parC(),
                    shape3 = parB()/parC(),
                    scale = parD())
        
        myPlot <- 
            ggplot(data = data.frame(x = 0), mapping = aes(x = x)) + 
            stat_function(fun = dtrbeta,
                          args = list(shape1 = parA()/parC(),
                                      shape2 = parC(),
                                      shape3 = parB()/parC(),
                                      scale = parD()),
                          xlim = myXlim(),
                          color = 'blue', size = 1) +
            # stat_function(fun = dtrbeta,
            #               args = list(shape1 = 0.160087257143, 
            #                           shape2 = 9.21320538026, 
            #                           shape3 = 0.0887449063835, 
            #                           scale = 0.0252976710394), 
            #               #xlim = c(0,0.612035560576), 
            #               color = 'blue', size = 1) + 
            ggtitle(label = "Density function of a transformed beta",
                    subtitle = paste0("Mean value: ", format(myMean, digits = 5, nsmall = 5))) +
            xlab("x") + ylab("Density") +
            theme(plot.title = element_text(hjust = 0.5, size = 18),
                  plot.subtitle = element_text(hjust = 0.5, size = 16),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 14))
        
        if (showMean()) {
            myPlot <- myPlot +
                geom_vline(xintercept = myMean, color = "red")
        }
        
        return(myPlot)        
    })
    
})


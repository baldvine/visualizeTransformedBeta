#
#

library(shiny)
library(ggplot2)
library(actuar)
library(magrittr)

shinyServer(function(input, output) {
    
    # observeEvent(input$paramsFromSliders, {
    #     insertUI(
    #         selector = "#paramsFromSliders",
    #         where = "afterEnd",
    #         ui = textInput(paste0("txt", input$paramsFromSliders),
    #                        "Insert some text")
    #     )
    # })
    
    # Set x limits:
    myXlim <- reactive({
        if (input$modifyXlim) {
            return(c(0,input$xlim))
        } else {
            return(c(0,1))
        }
    })
    
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
    

    output$trbPlot <- renderPlot({
        
        myMean <- 
            mtrbeta(order = 1, 
                    shape1 = parA()/parC(),
                    shape2 = parC(),
                    shape3 = parB()/parC(),
                    scale = parD())
        
        myPlot <- 
            ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
            ggtitle(label = "Density function of a transformed beta",
                    subtitle = paste0("Mean value: ", format(myMean, digits = 5, nsmall = 5))) +
            xlab("x") + ylab("Density") +
            theme(plot.title = element_text(hjust = 0.5, size = 18),
                  plot.subtitle = element_text(hjust = 0.5, size = 16),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 14))

        if (paramsFromSliders()) {
            myPlot <- myPlot +
                stat_function(fun = dtrbeta,
                              args = list(shape1 = parA.slider()/parC.slider(),
                                          shape2 = parC.slider(),
                                          shape3 = parB.slider()/parC.slider(),
                                          scale = parD()),
                              xlim = myXlim(),
                              color = 'blue', size = 1)
        } else {
            myPlot <- myPlot +
                stat_function(fun = dtrbeta,
                              args = list(shape1 = parA()/parC(),
                                          shape2 = parC(),
                                          shape3 = parB()/parC(),
                                          scale = parD()),
                              xlim = myXlim(),
                              color = 'blue', size = 1)
        }
                
        if (showMean()) {
            myPlot <- myPlot +
                geom_vline(xintercept = myMean, color = "red")
        }
        
        return(myPlot)        
    })
    
})


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
    parameterA <- reactive({
        if (paramsFromSlidersOrValues() == 'useSliders') {
            input$paramA.slider
        } else input$paramA
    })
    parameterB <- reactive({
        if (paramsFromSlidersOrValues() == 'useSliders') {
            input$paramB.slider
        } else input$paramB
    })
    parameterC <- reactive({
        if (paramsFromSlidersOrValues() == 'useSliders') {
            input$paramC.slider
        } else input$paramC
    })
    parameterD <- reactive({
        if (paramsFromSlidersOrValues() == 'useSliders') {
            input$paramD.slider
        } else input$paramD
    })
    
    # Get value of p0 (possibly zero):
    myP0 <- reactive({input$p0Value})
    
    # Get quantile percent, either just to plot or to limit at:
    maxQuantile <- reactive({
        ifelse(limitDistribution() == 'yesLimited', 
               yes = input$quantile.yesLimited, 
               no = input$quantile.notLimited)
    })

    # Set x limits:
    myXlim <- reactive({
        c(0,qtrbeta(p = maxQuantile(), 
                    shape1 = parameterA()/parameterC(),
                    shape2 = parameterC(),
                    shape3 = parameterB()/parameterC(),
                    scale = parameterD())
        )
    })
    
    # Compute the mean of the TRB distribution without any modifications:
    trbMoment <- reactive({
        mtrbeta(order = 1, 
                shape1 = parameterA()/parameterC(),
                shape2 = parameterC(),
                shape3 = parameterB()/parameterC(),
                scale = parameterD())
    })
    # Compute the actual mean:
    myMean <- reactive({
        # First, the possibly limited mean:
        if (limitDistribution() == 'yesLimited') {
            nonZeroInflatedMean <- 
                trbMoment() *
                pbeta(q = (max(myXlim())/parameterD())^parameterC()/
                          (1 + (max(myXlim())/parameterD())^parameterC()), 
                      shape1 = parameterB()/parameterC() + 1/parameterC(), 
                      shape2 = parameterA()/parameterC() - 1/parameterC()) +
                max(myXlim()) * (1 - maxQuantile())
        } else {
            nonZeroInflatedMean <- trbMoment()
        }
        return((1 - myP0()) * nonZeroInflatedMean)
    })
    
    # Some plotting stuff:
    myLineSize <- 2
    myThinLineSize <- 0.75*myLineSize
    myPointSize <- 4
    atomLineColor <- "firebrick"

    
    # The main plot:
    output$trbPlot <- renderPlot({
        
        myPlotLabel <- paste0("A ",
                              ifelse(zeroInflated() == TRUE,
                                     yes = "zero-inflated ",
                                     no = ""),
                              ifelse(limitDistribution() == 'yesLimited', 
                                     yes = "limited ", no = ""),
                              "transformed beta")
        myYAxisName <- 
            ifelse(zeroInflated() == TRUE | 
                       limitDistribution() == 'yesLimited',
                   yes = "Density, Probability",
                   no = "Density")
                   
        myPlot <- 
            ggplot(data = data.frame(x = 0, y = 0), mapping = aes(x,y)) +
            ggtitle(label = myPlotLabel,
                    subtitle = paste0("Mean value: ", format(myMean(), digits = 5, nsmall = 5))) +
            scale_x_continuous(name = "x") +  # , expand = c(0, 0)
            scale_y_continuous(name = myYAxisName, limits = c(0, NA),
                               expand = c(0, 0)) +
            coord_cartesian(clip = 'off') +
            stat_function(fun = function(x){
                (1-myP0())*dtrbeta(x, 
                                   shape1 = parameterA()/parameterC(),
                                   shape2 = parameterC(),
                                   shape3 = parameterB()/parameterC(),
                                   scale = parameterD())
                },
                xlim = myXlim(), n = 5000,
                color = 'black', size = myLineSize) +
            theme(plot.title = element_text(hjust = 0.5, size = 18),
                  plot.subtitle = element_text(hjust = 0.5, size = 16),
                  axis.title = element_text(size = 16),
                  axis.text = element_text(size = 14),
                  axis.line = element_line(color = 'black'),
                  panel.background = element_blank(),
                  panel.border = element_blank(),
                  panel.grid = element_blank())

        if (limitDistribution() == 'yesLimited') {
            myPlot <- myPlot +
                geom_segment(aes(x = max(myXlim()), xend = max(myXlim()), 
                             y = 0, yend = (1 - myP0())*(1 - maxQuantile())), 
                         size = myThinLineSize, color = atomLineColor) +
                geom_point(data = data.frame(x = max(myXlim()), 
                                             y = (1 - myP0())*(1 - maxQuantile())), 
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
                geom_vline(xintercept = myMean(), color = "forestgreen", 
                           size = myThinLineSize)
        }
        
        return(myPlot)        
    })
    
})


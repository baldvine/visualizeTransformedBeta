#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(actuar)  # For the trb distribution functions

# Define UI for application. This is where the input is determined
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Transformed beta distributions"),
    
    # Sidebar with a slider input for various parameters 
    sidebarLayout(
        
        sidebarPanel(
            h4("Plot characteristics:"),
            checkboxInput(inputId = "showMean", 
                          label = "Show distribution mean", 
                          value = FALSE),
            numericInput(inputId = "p0Value",
                         label = "Set zero-inflation, if any:",
                         value = 0, min = 0.000, max = 0.9999,
                         step = 0.0001),
            radioButtons(inputId = "limitDistribution",
                         label = "Limit the distribution:",
                         choices = c("No" = "notLimited",
                                     "Yes" = "yesLimited"),
                         selected = "notLimited",
                         inline = TRUE),
            conditionalPanel(
                condition = "input.limitDistribution == 'notLimited'",
                numericInput(inputId = "quantile.notLimited",
                            label = "Set probability of maximum TRB quantile to plot:",
                            value = 0.95, min = 0.01, max = 0.9999,
                            step = 0.0001)
            ),
            conditionalPanel(
                condition = "input.limitDistribution == 'yesLimited'",
                numericInput(inputId = "quantile.yesLimited",
                            label = div(HTML("Limit, <em>l</em>, as quantile of TRB. Set probability:")),
                            value = 0.95, min = 0.01, max = 0.9999,
                            step = 0.0001)
            ),
            radioButtons(inputId = "paramsFromSlidersOrValues",
                         label = "Parameters source:",
                         choices = c("Sliders" = "useSliders", 
                                     "Values" = "useValues"),
                         selected = "useSliders", 
                         inline = TRUE),
            conditionalPanel(
                condition = "input.paramsFromSlidersOrValues == 'useValues'",
                numericInput(inputId = "paramA", 
                             label = "Parameter a",
                             value = 3, min = 1, max = 50,
                             step = 0.01),
                numericInput(inputId = "paramB", 
                             label = "Parameter b",
                             value = 2.5, min = 0, max = 20,
                             step = 0.01),
                numericInput(inputId = "paramC", 
                             label = "Parameter c",
                             value = 1, min = 0, max = 20,
                             step = 0.01),
                numericInput(inputId = "paramD", 
                             label = "Parameter d",
                             value = 1.2, min = 0, max = 8,
                             step = 0.001)
            ),
            conditionalPanel(
                condition = "input.paramsFromSlidersOrValues == 'useSliders'",
                sliderInput(inputId = "paramA.slider",
                            label = "Parameter a",
                            value = 3, min = 1, max = 12,
                            step = 0.001),
                sliderInput(inputId = "paramB.slider",
                            label = "Parameter b",
                            value = 2.5, min = 0, max = 10,
                            step = 0.001),
                sliderInput(inputId = "paramC.slider",
                            label = "Parameter c",
                            value = 1, min = 0, max = 15,
                            step = 0.001),
                sliderInput(inputId = "paramD.slider",
                            label = "Parameter d",
                            value = 1.2, min = 0, max = 8,
                            step = 0.001)
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h2("Visualization of transformed beta and its modifications"),
            h2("Baldvin Einarsson, Ph.D."),
            helpText(a("See github page for details and references (and code)",
                       href = "https://github.com/baldvine/visualizeTransformedBeta",
                       target = "_blank")
            ),
            plotOutput("trbPlot")
        )
        
    ) # sidebarLayout(
))

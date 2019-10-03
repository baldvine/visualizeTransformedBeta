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
            h4("Parameters"),
            checkboxInput(inputId = "showMean", 
                          label = "Show mean", 
                          value = TRUE),
            checkboxInput(inputId = "paramsFromSliders",
                          label = "Use parameters from sliders",
                          value = TRUE),
            conditionalPanel(
                condition = "input.paramsFromSliders == false",
                numericInput(inputId = "paramA", 
                             label = "Parameter a",
                             value = 3, min = 1, max = 50,
                             step = 0.001),
                numericInput(inputId = "paramB", 
                             label = "Parameter b",
                             value = 1, min = 0, max = 20,
                             step = 0.001),
                numericInput(inputId = "paramC", 
                             label = "Parameter c",
                             value = 1, min = 0, max = 20,
                             step = 0.001),
                numericInput(inputId = "paramD", 
                             label = "Parameter d",
                             value = 0.2, min = 0, max = 6,
                             step = 0.0001)
            ),
            conditionalPanel(
                condition = "input.paramsFromSliders == true",
                sliderInput(inputId = "paramA.slider",
                            label = "Parameter a",
                            value = 3, min = 1, max = 10,
                            step = 0.01),
                sliderInput(inputId = "paramB.slider",
                            label = "Parameter b",
                            value = 1, min = 0, max = 10,
                            step = 0.01),
                sliderInput(inputId = "paramC.slider",
                            label = "Parameter c",
                            value = 1, min = 0, max = 8,
                            step = 0.01),
                sliderInput(inputId = "paramD.slider",
                            label = "Parameter d",
                            value = 0.2, min = 0, max = 2,
                            step = 0.01)
            ),
            checkboxInput(inputId = "modifyXlim", 
                          label = "Alter x limit", 
                          value = FALSE),
            conditionalPanel(
                condition = "input.modifyXlim == true",
                sliderInput(inputId = "xlim", 
                            label = "Upper x limit",
                            value = 1, min = 0, max = 10,
                            step = 0.01)
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h2("Baldvin Einarsson, PhD"),
            h2("Visualization of transformed beta"),
            helpText(a("See github page for details and references (and code!)",
                       href = "https://github.com/baldvine/visualizeTransformedBeta",
                       target = "_blank")
            ),
            plotOutput("trbPlot")
        )
        
    ) # sidebarLayout(
))

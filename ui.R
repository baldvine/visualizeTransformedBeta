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
            # radioButtons(inputId = "zeroInflate",
            #              label = "Zero-inflate the distribution:",
            #              choices = c("No" = "notZeroInflate",
            #                          "Yes" = "yesZeroInflate"),
            #              selected = "notZeroInflate",
            #              inline = TRUE),
            # conditionalPanel(
            #     condition = "input.zeroInflate == 'notZeroInflate'",
            #     numericInput(inputId = "notZeroInflate",
            #                  label = "asdf:",
            #                  value = 0.0, min = 0.0, max = 0.0,
            #                  step = 0.0001)
            # ),
            # conditionalPanel(
            #     condition = "input.zeroInflate == 'yesZeroInflate'",
            #     numericInput(inputId = "yesZeroInflate",
            #                  label = div(HTML("Set limit <em>l</em> as quantile:")),
            #                  value = 0.1, min = 0.0001, max = 0.9999,
            #                  step = 0.0001)
            # ),
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
                numericInput(inputId = "notLimited",
                            label = "Maximum quantile plotted:",
                            value = 0.95, min = 0.01, max = 0.9999,
                            step = 0.0001)
            ),
            conditionalPanel(
                condition = "input.limitDistribution == 'yesLimited'",
                numericInput(inputId = "yesLimited",
                            label = div(HTML("Set limit <em>l</em> as quantile:")),
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
                             value = 0.2, min = 0, max = 8,
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
                            value = 0.2, min = 0, max = 8,
                            step = 0.001)
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

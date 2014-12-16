# To Deploy
# library(shinyapps)
# deployApp()

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("mtcars Linear Modeller"),
  
  sidebarPanel( 
    checkboxGroupInput('factors',  label='Factors', choices=colnames(cars)[-1],
                       selected='wt')
    , width=2
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Welcome",
               h2("Welcome to the mtcars Linear Modeler"),
               helpText(p("This modeler allows you to select which coefficients you would like to 
                        include in your linear model and will automatically refresh the various tabs
                        in this notebook to reflect your changes."),
                        p("One useful way to use this tool is to select the tab you want to have open
                        and watch while you change the factors to be fitted, then watch that tab change 
                        in response to you adding and removing explanatory factors."),
                        p("The tabs here provide:")),
               withTags({
                 dl(
                    dt("Summary"), dd("The R 'summary' of the model"),
                    dt("Coefficients"), dd("The Calculated Coefficients extracted from the summary,
                                           and displayed in a table that allows for easy sorting.
                                           (E.g. you may want to sort by p-value to see which coefficients
                                           have the highest confidence.)"),
                    dt("Conf Int"), dd("95% Confidence intervals for the coefficients"),
                    dt("Diagnostic Plots"), dd("Choose between:",
                                              ol(
                                                li("Residuals"),
                                                li("Normal Q-Q"),
                                                li("Scale Location"),
                                                li("Cook's Distance")
                                                )),
                    dt("Raw Data"), dd("The mtcars data in a sort-able table for sniffing out 'odd' samples"),
                    dt("Diagnostic Data"), dd("Table of cars showing, for the current model:",
                                              ul(
                                                li("rstudent"),
                                                li("hatvalues"),
                                                li("dffits"),
                                                li("dfbetas"),
                                                li("cooks.distance"),
                                                li("PRESS : i.e. resid / (1 - hatvalues)")
                                                )),
                    dt("Custom Plot"), dd("Provides an area to define an arbitrary ggplot or base plot graphics for
                                          further analysis.  The model itself is available as 'fit()' if you wish to
                                          plot data off of the model itself.")
                 )})
               ),
      tabPanel("Summary", verbatimTextOutput('summary')),
      tabPanel("Coefficients",dataTableOutput('coef')),
      tabPanel("Conf Int",htmlOutput('confint')),
      tabPanel("Diagnostic Plots",
               selectInput('plotidx', 'Select Plot:', selected=1, 
                           choices=list(Resuduals=1, `Normal Q-Q`=2, `Scale Location`=3, `Cook's Distance`=4)),
               plotOutput('plot')),
      
      tabPanel("Raw Data"
               , dataTableOutput('rawtable')),
      
      tabPanel("Diagnostic Data"
               , checkboxInput('abs','Use Absolute Values for Diagnostic Measures', value=TRUE)
               , dataTableOutput('diagtable')),
      
      tabPanel("Custom Plot"
              , h3('Plot Definition')
              , tags$textarea(id="custplotdefn", rows=5, cols=200, 
"qplot(
  x=wt,
  y=mpg,
  colour=transmission,
  data=cars,
  geom=c('point','smooth')
)"
                            
                            )
                  ,actionButton('doplot',"Submit Plot")
                  ,plotOutput('custplot')
      )
    )
  )
))
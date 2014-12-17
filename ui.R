# To Deploy
# devtools::install_github("rstudio/shinyapps")
# library(shinyapps)
# shinyapps::deployApp(appName="mtcars-Linear-Modeler")

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("mtcars Linear Modeler"),
  
  sidebarPanel( 
    checkboxGroupInput('factors',  label='Factors', choices=colnames(cars)[-1],
                       selected='wt')
    , width=2
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Welcome", includeHTML("README.html")),
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
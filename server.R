library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  fit <- reactive({
    form <- as.formula(paste("mpg ~ ", paste(input$factors, collapse= "+")))
    lm(form, data=cars)
  })
  
  output$summary <- renderPrint({summary(fit())})
  
  output$coef <- renderDataTable({
    t <- summary(fit())$coefficients
    t <- signif(t,4)
    cbind(rownames(t),t)
  }, options = list(paging = FALSE, searching=FALSE))
  
  output$confint <- renderTable({confint(fit())})
  output$plot <- renderPlot({plot(fit(),strtoi(input$plotidx,10))})
  
  output$rawtable <- renderDataTable({cbind(Cars=rownames(cars),cars)},
                                  options = list(paging = FALSE, searching=FALSE))
  
  
  output$diagtable <- renderDataTable({
    oabs <- ifelse(input$abs == TRUE, abs, identity)
    fmt <- function(i) signif(oabs(i),3)
    cbind(Cars=rownames(cars)
          ,rstudent=fmt(rstudent(fit()))
          ,hatvalues=fmt(hatvalues(fit()))
          ,dffits=fmt(dffits(fit()))
          ,dfbetas=fmt(dfbetas(fit()))
          ,cooks.distance=fmt(cooks.distance(fit()))
          ,PRESS =fmt(resid(fit()) / (1 - hatvalues(fit())))
    )},
    options = list(paging = FALSE, searching=FALSE))
  
  output$custplot <- renderPlot({
    input$doplot
    if (input$custplotdefn == '') return
    isolate({
      eval(parse(text=input$custplotdefn))
    })
  })
  
  # output$debug <- renderPrint(input$plotidx)
})
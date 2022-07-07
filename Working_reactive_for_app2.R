
library(shinyjs)
library(shiny)

ui <- 
  fluidPage(
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  fluidRow(
    column(width = 12,
           sliderInput("select", "Choose Range", min = 0, max = 12, value = 3)
    )
  ),
  fluidRow(
    column(
      width = 6,
      uiOutput("range")
      # lapply(
      #   X = 1:12,
      #   FUN = function(i) {
      #     sliderInput(inputId = paste0("d", i), label = i, min = 0, max = 10, value = i)
      #   }
      # )
    ),
    column(
      width = 6,
      verbatimTextOutput(outputId = "test"),
      textOutput("text"),
      dataTableOutput("table")
      
    )
  )
)

server <- function(input, output){
  
  
  # data <- eventReactive(lapply(grep(pattern = "d+[[:digit:]]", x = names(input), value = TRUE), function(x) input[[x]]), {
  #   list <- 0
  #   list <- sapply(grep(pattern = "d+[[:digit:]]", x = names(input), value = TRUE), function(x) input[[x]])
  #   sapply(list, sum)
  # })
  # 
  input_list <- eventReactive(input$select, {
    lapply(
      X = 1:input$select,
      FUN = function(i) {
        input = paste0('dog', i)
      }
    )
  })
  
  
  sum_value <- reactive({
    sum_list <- data.frame()
    for(x in 1:length(input_list())){
      
      input_name <- paste(input_list()[x])
      val <- input[[paste(input_list()[[x]])]]
      
      sum_list <- rbind(sum_list, data.frame(input_name, val))
    }
    return(as.data.frame(sum_list))
    
    # sum(sum_list$val)
    
  })
  
  output$text <- renderText ({
    paste0(round(sum(sum_value()$val)/(input$select * 17)*100,2), "% Shade")
    
  })
 
  output$table <- renderDataTable({
    req(sum_list)
  })

  
  
  # output$test <- renderPrint({
  #   sum_list <- data.frame()
  #   for(x in 1:length(input_list())){
  #     
  #     # input <- paste(input[[x]]),
  #     val <- input[[paste(input_list()[[x]])]]
  #     
  #     sum_list <- rbind(sum_list, data.frame(val))
  #   }
  #   sum(sum_list$val)
  # })
  
  output$range <- renderUI({
    lapply(
      X = 1:input$select,
      FUN = function(i) {
        sliderInput(inputId = paste0("dog", i), label = i, min = 0, max = 17, value = i)
      }
    )
  })
  
}
shinyApp(ui = ui, server = server)



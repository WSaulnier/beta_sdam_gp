source('global.R')
source('R/sno.R')
source('R/nosno.R')
ui <- fluidPage(
  fluidRow(
    column(
      12,
      headerPanel("This is where we can put the banner image")
    )
  ),
  fluidRow(
    column(
      12,
      tabsetPanel(
        id = "tabs",
        tabPanel(
          "Background",
          "Lorem ipsum"
        ),
        # Overview -----------------------------------------------------
        tabPanel(
          "Overview", 
          br(),
          fluidRow(column(12, h4("Enter coordinates in decimal degrees"))),
          fluidRow(
            column(
              5, 
              fluidRow(
                column(4,numericInput("lat", label = NULL,value = 46.9652)),
                column(4, h5("Latitude"))
              ),
              fluidRow(
                column(4,numericInput("lon", label = NULL, value = -109.533691)),
                column(4, h5("Longitude"))
              )
            ),
            column(
              5, 
              br(),
              actionButton("snobutton", label="Assess Snow Dominance")
            ),
            column(
              2, 
              ""
            )
          ),
          fluidRow(
            column(
              12,
              uiOutput('paramsui')
            )
          )
        ),
        tabPanel(
          "Generate Report",
          "Coming Soon"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  testnumber <- reactive({
    input$testin + 5 
  })
  
  sno <- eventReactive(
    input$snobutton, 
    {
      snowdom(input$lat, input$lon)
    }
  )
  
  # paramsui = params ui, ui that displays more inputs to grab more parameters
  output$paramsui <- renderUI({
    sno <- sno()
    
  
    if (tolower(sno) == 'snow-dominated') { 
      # display the snow dominated parameters user interface
      fluidRow(
        column(
          12,
          fluidRow(
            column(12, h4(HTML(glue::glue('<p>This site is <strong>{sno}</strong></p><hr>'))))
          ),
          fluidRow(
            column(
              12, 
              h4("Enter indicator metric values")
            )
          ),
          snoparams_ui
        )
      )
    } else {
      # display the snow dominated parameters user interface
      fluidRow(
        column(
          12,
          fluidRow(
            column(12, h4(HTML(glue::glue('<p>This site is <strong>{sno}</strong></p><hr>'))))
          ),
          fluidRow(
            column(
              12, 
              h4("Enter indicator metric values")
            )
          ),
          nosnoparams_ui
        )
      )
    }
  })
  
  # classification
  classify <- eventReactive(input$runmodel, {
    Beta_SDAM_WM(
      user_lat=input$lat, 
      user_lon=input$lon, 
      user_TotalAbundance=input$user_TotalAbundance, 
      user_perennial_abundance=input$user_perennial_abundance, 
      user_perennial_taxa=input$user_perennial_taxa, 
      user_mayfly_abundance=input$user_mayfly_abundance, 
      user_fishabund_score2=input$user_fishabund_score2,
      user_alglivedead_cover_score=input$user_alglivedead_cover_score, 
      user_DifferencesInVegetation_score=input$user_DifferencesInVegetation_score, 
      user_BankWidthMean=input$user_BankWidthMean, 
      user_Sinuosity_score=input$user_Sinuosity_score, 
      user_hydric=input$user_hydric
    )
  })
  
  output$final_class <- renderUI({HTML(glue::glue("<h5>This reach is classified as: <strong>{classify()}</strong></h5>"))})
  
  
  
  
  
}

shinyApp(ui=ui, server=server)
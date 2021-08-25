source('global.R')
ui <- basicPage(
  tabsetPanel(id = "tabs",
     
    # Overview -----------------------------------------------------
    tabPanel(
      "Overview", 
      numericInput("lat", label = h3("Latitude"), value = 46.9652),
      numericInput("lon", label = h3("Longitude"), value = -109.533691),
      actionButton("snobutton", label="Assess Snow Domination"),
      uiOutput('paramsui'),
      actionButton('runmodel', 'Run Model'),
      textOutput('final_class')
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
    
  
    if (sno == 'Snow-Dominated') { 
      tagList(
          h5(glue::glue('This site is {sno}')),
          fluidRow(
            column(
              12, 
              sliderInput("user_perennial_taxa", "Perennial Taxa", 0, 10, 1),
              sliderInput("user_alglivedead_cover_score", "Algae Alive dead Cover Score", 0, 10, 1),
              sliderInput("user_perennial_abundance", "Perennial Abundance", 0, 10, 1),
              sliderInput("user_BankWidthMean", "Bank Width Mean", 0, 10, 1),
              sliderInput("user_TotalAbundance", "Total Abundance", 0, 10, 1)
            )
          )
        )
    } else {
      tagList(
        h2(glue::glue('This site is {sno}')),
        fluidRow(
          column(
            12, 
            sliderInput("user_perennial_taxa", "Perennial Taxa", 0, 10, 1),
            sliderInput("user_alglivedead_cover_score", "Algae Alive dead Cover Score", 0, 10, 1),
            sliderInput("user_fishabund_score2", "Fish Abundance Score 2", 0, 10, 1),
            sliderInput("user_mayfly_abundance", "Mayfly Abundance", 0, 50, 1),
            sliderInput("user_DifferencesInVegetation_score", "Differences in Vegetation Score", 0, 10, 1),
            sliderInput("user_Sinuosity_score", "Sinuosity Score", 0, 10, 1),
            sliderInput("user_hydric", "Hydric", 0, 10, 1)
          )
        )
      )
    }
    
         
      
  })
  
  # classification
  classif <- eventReactive(input$runmodel, {
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
  
  output$final_class <- renderText({classif()})
  
  
  
  
  
}

shinyApp(ui=ui, server=server)
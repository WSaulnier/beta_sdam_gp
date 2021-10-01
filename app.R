source('global.R')
source('R/sno.R')
source('R/nosno.R')
ui <- fluidPage(
  titlePanel(
    div(
      class="jumbotron",
      h2(HTML(
        "Beta Streamflow Duration Assessment Method for Western Mountain Region
        ")
      ),
      h4(HTML("<p>Version <a href=\"https://github.com/SCCWRP/beta_sdam_wm\">1.0.0</a> Release date: Oct 6 2021 </p>")),
      img(src="wmtitle1.png"),
      img(src="wmtitle2.png"),
      img(src="wmtitle3.png"),
      img(src="wmtitle4.png")
    ),
    "SDAM Western Mountains"
  ),
  fluidRow(
    column(
      12,
      tabsetPanel(
        id = "tabs",
        tabPanel(
          "Background Info",
          bkgrnd
        ),
        # Overview -----------------------------------------------------
        tabPanel(
          "Enter Data", 
          br(),
          fluidRow(column(12, h4("Enter coordinates in decimal degrees"))),
          fluidRow(
            column(
              5, 
              fluidRow(
                column(4,numericInput("lat", label = NULL,value = 39.9838)),
                column(4, h5("Latitude (N)"))
              ),
              fluidRow(
                column(4,numericInput("lon", label = NULL, value = -123.2881)),
                column(4, h5("Longitude (E)"))
              )
            ),
            column(
              5, 
              br(),
              actionButton("snobutton", label="Assess Snow Influence")
            ),
            column(
              2,
              ""
            )
          ),
          fluidRow(
            column(
              12,
              uiOutput('snomsg')
            )
          ) ,
          fluidRow(
            column(
              12,
              uiOutput('params')
            )
          )
        ),
        tabPanel(
          "Generate Report",
          
          #------- General Information
          h2(HTML(
            "General Information")
          ),
          br(),
          textInput("projectname", label = "Project Name or Number:" , value = "", width = NULL, placeholder = NULL),
          br(),
          textInput("sidecode", label = "Site Code or Identifier:" , value = "", width = NULL, placeholder = NULL),
          br(),
          textInput("assessors", label = "Assessor(s):" , value = "", width = NULL, placeholder = NULL),
          br(),
          textInput("waterwayname", label = "Waterway Name:" , value = "", width = NULL, placeholder = NULL),
          br(),
          textInput("visitdate", label = "Visit Date:" , value = "", width = NULL, placeholder = NULL),
          br(),
          radioButtons(inputId = "currentweathercondition",
                       label = "Current Weather Conditions (check one):",
                       
                       choices = c("Storm/Heavy Rain" = 'heavyrain',
                                   "Steady Rain" = 'steadyrain',
                                   "Intermitten Rain" = 'intermittenrain',
                                   "Snowing" = 'snowing',
                                   "Cloudy" = 'cloudy',
                                   "Clear/Sunny" = 'clearsunny'
                                   ),
                       selected = "heavyrain"),
          br(),
          textInput("notes_currentweather", 
                    label = "Notes on current or recent weather conditions:" , 
                    value = "", 
                    width = NULL, 
                    placeholder = NULL
          ),
          br(),
          radioButtons(inputId = "surrounding_landuse",
                       label = "Surrounding land-use within 100 m (check one or two):",
                       choices = c("Urban, industrial, or residential" = 'urban',
                                   "Agricultural" = 'agricultural',
                                   "Developed open-space " = 'openspace',
                                   "Forested" = 'forested',
                                   "Other Natural" = 'othernatural',
                                   "Other" = 'other'
                       ),
                       selected = "urban"),
          br(),
          textInput(inputId = "describe_reach_boundaries", 
                    label = "Describe reach boundaries:" , 
                    value = "", 
                    width = NULL, 
                    placeholder = NULL
          ),
          br(),
          numericInput(
            inputId = "assessment_reach_length",
            label = "Assessment reach length(m):",
            value = "",
            min = 0,
          ),
          br(),
          radioButtons(inputId = "difficult_conditions",
                       label = "Disturbed or difficult conditions (check all that apply):",
                       choices = c("Recent flood or debris flow" = 'flood',
                                   "Stream modifications (e.g., channelization)" = 'stream_modifications',
                                   "Diversions" = 'diversions',
                                   "Discharges" = 'discharges',
                                   "Drought" = 'drought',
                                   "Vegetation removal/limitations" = 'vegetation',
                                   "Other (explain in notes)" = 'other',
                                   "None" = 'none'
                       ),
                       selected = "flood"),
          textInput(inputId = "site_difficulties", 
                    label = "Site disturbances/difficulties::" , 
                    value = "", 
                    width = NULL, 
                    placeholder = NULL
          ),
          
          #------- Observed Hydrology
          h2(HTML(
            "Observed Hydrology")
          ),
          br(),
          numericInput(
            inputId = "pctreach_surface_flow",
            label = "Percent of reach with surface flows:",
            value = "",
            min = 0,
          ),
          br(),
          numericInput(
            inputId = "pctreach_subsurface_flow",
            label = "Percent of reach with surface and sub-surface flows:",
            value = "",
            min = 0,
          ),
          br(),
          numericInput(
            inputId = "num_isolated_pools",
            label = "Number of isolated pools:",
            value = "",
            min = 0,
          ),
          br(),
          textInput(inputId = "comments_observed_hydrology", 
                    label = "Comments on observed hydrology:", 
                    value = "", 
                    width = NULL, 
                    placeholder = NULL
          ),
          br(),
          
          #------- Site Photos
          h2(HTML("Site Photos")),
          br(),
          
          
          
        
        
          
          
          
        
          
          
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  
  sno <- eventReactive(
    input$snobutton, 
    {
      snowdom(input$lat, input$lon)
    }
  )
  
  # paramsui = params ui, ui that displays more inputs to grab more parameters
  output$snomsg <- renderUI({
    sno <- sno()
    
    if (sno$canrun) {
      fluidRow(
        column(
          12,
          fluidRow(
            column(12, h4(HTML(glue::glue('<p>{sno$msg}</p>'))))
          ),
          fluidRow(
            column(
              12, 
              radioButtons(
                "paramchoice", 
                "Choose model",
                c(
                  "Snow Influenced" = 'sno',
                  "Non Snow Influenced" = 'nosno'
                ),
                selected = character(0),
                inline = T
              )
            )
          )
        )
      )
    } else {
      fluidRow(
        column(
          12,
          fluidRow(
            column(12, h4(HTML(glue::glue('<p>{sno$msg}</p><hr>'))))
          )
        )
      )
    }
  })
  
  
  output$params <- renderUI({
    if (!is.null(input$paramchoice)) {
      if (input$paramchoice == 'sno') {
        return(snoparams_ui)
      } else {
        return(nosnoparams_ui)
      }
    } else {
      return('')
    }
  })
  
  # classification
  classify <- eventReactive(input$runmodel, {
    Beta_SDAM_WM(
      user_model_choice=input$paramchoice,
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
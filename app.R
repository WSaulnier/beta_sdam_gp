source('global.R')
source('R/sno.R')
source('R/nosno.R')
source('R/additionalinfo.R')
### Maybe needed?
# install.packages('rmarkdown')
# install.packages('tinytex')
# tinytex::install_tinytex()  # install TinyTeX
###
ui <- fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
        input[type=number] {
              -moz-appearance:textfield;
        }
        input[type=number]::{
              -moz-appearance:textfield;
        }
        input[type=number]::-webkit-outer-spin-button,
        input[type=number]::-webkit-inner-spin-button {
              -webkit-appearance: none;
              margin: 0;
        }
    "))
  ),
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
          fluidRow(column(12, h4("Step 1: Enter coordinates"), 
          div('Enter coordinates in decimal degrees to assess snow influence and calculate geospatial indicator metrics.'))),
          
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
          ),
          conditionalPanel(
            'input.runmodel == 1',
            
            #------- General Information
            h4(HTML(
              "Step 4: Enter additional information (optional)")
            ),
            h5('Enter information about the assessment. Indicators required for classification are filled in from entries above'),
            br(),
            h4(HTML(
              "<b>General Site Information</b>")
            ),
            textInput(
              "project", 
              label = "Project Name or Number:" , 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            textInput(
              "code", 
              label = "Site Code or Identifier:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            textInput(
              "assessor", 
              label = "Assessor(s):", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            textInput(
              "waterway", 
              label = "Waterway Name:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            textInput(
              "date", 
              label = "Visit Date:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            radioButtons(
              inputId = "radio_weather",
              label = "Current Weather Conditions (check one):",
              choices = c(
                "Storm/Heavy Rain" = 'heavyrain',
                "Steady Rain" = 'steadyrain',
                "Intermitten Rain" = 'intermittenrain',
                "Snowing" = 'snowing',
                "Cloudy" = 'cloudy',
                "Clear/Sunny" = 'clearsunny'
              ),
              selected = NULL
            ),
            textInput(
              "weather", 
              label = "Notes on current or recent weather conditions:" , 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            checkboxGroupInput(
              inputId = "check_use",
              label = "Surrounding land-use within 100 m (check one or two):",
              choices = c(
                "Urban, industrial, or residential" = 'urban',
                "Agricultural" = 'agricultural',
                "Developed open-space " = 'openspace',
                "Forested" = 'forested',
                "Other Natural" = 'othernatural',
                "Other" = 'other'
              ),
              selected = NULL
            ),
            textInput(
              inputId = "boundary", 
              label = "Describe reach boundaries:" , 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            numericInput(
              inputId = "actreach",
              label = "Assessment reach length (m):",
              value = "",
              min = 0,
            ),
            checkboxGroupInput(
              inputId = "radio_situation",
              label = "Disturbed or difficult conditions (check all that apply):",
              choices = c(
                "Recent flood or debris flow" = 'flood',
                "Stream modifications (e.g., channelization)" = 'stream_modifications',
                "Diversions" = 'diversions',
                "Discharges" = 'discharges',
                "Drought" = 'drought',
                "Vegetation removal/limitations" = 'vegetation',
                "Other (explain in notes)" = 'other',
                "None" = 'none'
              ),
              selected = NULL
            ),
            textInput(
              inputId = "situation", 
              label = "Site disturbances/difficulties::" , 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            #------- Site Photos
            h4(HTML("<b>Site Photos</b>")),
            fileInput(
              "tld", 
              "Top of reach looking downstream:", 
              accept = c('image/png', 'image/jpeg')
            ),
            
            fileInput(
              "mlu", 
              "Middle of reach looking upstream:", 
              accept = c('image/png', 'image/jpeg')
            ),
            
            fileInput(
              "mld", 
              "Middle of reach looking downstream:", 
              accept = c('image/png', 'image/jpeg')
            ),
            
            fileInput(
              "blu", 
              "Bottom of reach looking upstream:", 
              accept = c('image/png', 'image/jpeg')
            ),
            
            fileInput(
              "sketch", 
              "Site Sketch:", 
              accept = c('image/png', 'image/jpeg')
            ),
            
            #------- Observed Hydrology
            h4(HTML(
              "<b>Observed Hydrology</b>")
            ),
            numericInput(
              inputId = "surfflow",
              label = "Percent of reach with surface flows:",
              value = "",
              min = 0,
            ),
            numericInput(
              inputId = "subflow",
              label = "Percent of reach with surface and sub-surface flows:",
              value = "",
              min = 0,
            ),
            numericInput(
              inputId = "pool",
              label = "Number of isolated pools:",
              value = "",
              min = 0,
            ),
            textInput(
              inputId = "notes_observed_hydrology", 
              label = "Comments on observed hydrology:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            br(),
            #------- Indicators
            h4(HTML("<b>Enter non-required indicators and supplemental information</b>")),
            helpText("Indicators required for classification are filled in from entries above. 
                   Other indicators measured during the assessment may be added here."),
            h4(HTML("<b>Aquatic Invertebrates</b>")),
            # numericInput(
            #   inputId = "aqua_inv",
            #   label = "Total abundance of aquatic invertebrates : ",
            #   value = ""
            # ),
            # numericInput(
            #   inputId = "may_flies",
            #   label = "Total abundance of mayflies: ",
            #   value = ""
            # ),
            # numericInput(
            #   inputId = "indicator_taxa",
            #   label = "Total abundance of perennial indicator taxa:",
            #   value = ""
            # ),
            # numericInput(
            #   inputId = "indicator_families",
            #   label = "Total number of perennial indicator families:",
            #   value = ""
            # ),
            textInput(
              inputId = "notes", 
              label = "Notes about aquatic invertebrates:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "inv1", 
              HTML("Invertebrate Photo #1<br /> <span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "inv1_cap", 
              label = HTML("<span style='font-weight:normal'> Invertebrate Photo #1 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "inv2", 
              HTML("Invertebrate Photo #2<br /> <span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "inv2_cap", 
              label = HTML("<span style='font-weight:normal'>Invertebrate Photo #2 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "inv3", 
              HTML("Invertebrate Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            
            textInput(
              inputId = "inv3_cap", 
              label = HTML("<span style='font-weight:normal'>Invertebrate Photo #3 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            #------- Algae Cover
            h4(HTML("<b>Algae Cover</b>")),
            # radioButtons(
            #   inputId = "algae_streambed",
            #   label = "Algae cover on the streambed:",
            #   choices = c(
            #     "None Detected" = 'none',
            #     "< 2%" = 'lessthan2',
            #     "2% to 10%" = '2to10',
            #     "10% to 40%" = '10to40',
            #     "40% and above" = 'morethan40'
            #   ),
            #   selected = NULL,
            #   inline = T
            # ),
            textInput(
              inputId = "notes_algaecover", 
              label = "Notes about algae cover:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "alg1", 
              HTML("Algae Photo #1<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "alg1_cap", 
              label = HTML("<span style='font-weight:normal'>Algae Photo #1 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "alg2", 
              HTML("Algae Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "alg2_cap", 
              label = HTML("<span style='font-weight:normal'>Algae Photo #2 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "alg3", 
              HTML("Algae Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            
            textInput(
              inputId = "alg3_cap", 
              label = HTML("<span style='font-weight:normal'>Algae Photo #3 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            #------- Fish Abundance
            h4(HTML("<b>Fish Abundance</b>")),
            # br(),
            # radioButtons(
            #   inputId = "fish_abundance",
            #   label = HTML("<b><i>Fish abundance (other than mosquitofish)</b></i>"),
            #   choices = c(
            #     "0 (Poor)" = 'poor',
            #     "0.5" = 'poor2',
            #     "1 (Weak)" = 'weak',
            #     "1.5" = 'weak2',
            #     "2 (Moderate)" = 'moderate',
            #     "2.5" = 'moderate2',
            #     "3 (Strong)" = 'strong'
            #   ),
            #   selected = NULL,
            #   inline = T
            # ),

            textInput(
              inputId = "notes_fish_abundance", 
              label = "Notes about fish abundance:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "fish1", 
              HTML("Fish Photo #1<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "fish1_cap", 
              label = HTML("<span style='font-weight:normal'>Fish Photo #1 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "fish2", 
              HTML("Fish Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "fish2_cap", 
              label = HTML("<span style='font-weight:normal'>Fish Photo #2 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "fish3", 
              HTML("Fish Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "fish3_cap", 
              label = HTML("<span style='font-weight:normal'>Fish Photo #3 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            #------- Differences in vegetation
            h4(HTML("<b>Differences in vegetation</b>")),
            # radioButtons(
            #   inputId = "vegetation_score",
            #   label = "Differences in vegetation score:",
            #   choices = c(
            #     "0 (Poor)" = 'poor',
            #     "0.5" = 'poor2',
            #     "1 (Weak)" = 'weak',
            #     "1.5" = 'weak2',
            #     "2 (Moderate)" = 'moderate',
            #     "2.5" = 'moderate2',
            #     "3 (Strong)" = 'strong'
            #   ),
            #   selected = NULL,
            #   inline = T
            # ),
            textInput(
              inputId = "notes_differences_vegetation", 
              label = "Notes about differences in vegetation:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "veg1", 
              HTML("Vegetation Photo #1<br/><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "veg1_cap", 
              label = HTML("<span style='font-weight:normal'>Vegetation Photo #1 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "veg2", 
              HTML("Vegetation Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "veg2_cap", 
              label = HTML("<span style='font-weight:normal'>Vegetation Photo #2 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "veg3", 
              HTML("Vegetation Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "veg3_cap", 
              label = HTML("<span style='font-weight:normal'>Vegetation Photo #3 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            #------- Sinuosity
            h4(HTML("<b>Sinuosity</b>")),
            # radioButtons(
            #   inputId = "sinuosity",
            #   label = "Sinuosity score:",
            #   choices = c(
            #     "0 (Poor)" = 'poor',
            #     "0.5" = 'poor2',
            #     "1 (Weak)" = 'weak',
            #     "1.5" = 'weak2',
            #     "2 (Moderate)" = 'moderate',
            #     "2.5" = 'moderate2',
            #     "3 (Strong)" = 'strong'
            #   ),
            #   selected = "strong",
            #   inline = T
            # ),
            textInput(
              inputId = "notes_sinuosity", 
              label = "Notes about sinuosity:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "sinu1", 
              HTML("Sinuosity Photo #1<br /> <span style='font-weight:normal'>Upload photo file here: </span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "sinu1_cap", 
              label = HTML("<span style='font-weight:normal'>Sinuosity Photo #1 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "sinu2", 
              HTML("Sinuosity Photo #2<br /> <span style='font-weight:normal'> Upload photo file here: </span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "sinu2_cap", 
              label = HTML("<span style='font-weight:normal'>Sinuosity Photo #2 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            fileInput(
              "sinu3", 
              HTML("Sinuosity Photo #3<br /> <span style='font-weight:normal'>Upload photo file here:</span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            
            textInput(
              inputId = "sinu3_cap", 
              label = HTML("<span style='font-weight:normal'>Sinuosity Photo #3 caption:</span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            #------- Supplemental Information
            h4(HTML("<b>Supplemental Information</b>")),
            HTML(
              "If observed, note the presence of the aquatic life stages of amphibians, 
             snakes, or turtles; iron-oxidizing bacteria and fungi; etc."
            ),
            textInput(
              inputId = "notes_supplemental_information", 
              label = "Additional notes about the assessment:", 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "add1", 
              HTML("Additional Photo #1<br/> <span style='font-weight:normal'>Upload photo file here: </span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "add1_cap", 
              label = HTML("<span style='font-weight:normal'>Additional Photo #1 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            fileInput(
              "add2", 
              HTML("Additional Photo #2<br/> <span style='font-weight:normal'>Upload photo file here: </span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            textInput(
              inputId = "add2_cap", 
              label = HTML("<span style='font-weight:normal'>Additional Photo #2 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            
            
            fileInput(
              "add3", 
              HTML("Additional Photo #3<br /> <span style='font-weight:normal'>Upload photo file here: </span>"), 
              accept = c('image/png', 'image/jpeg')
            ),
            
            textInput(
              inputId = "add3_cap", 
              label = HTML("<span style='font-weight:normal'>Additional Photo #3 caption: </span>"), 
              value = "", 
              width = NULL, 
              placeholder = NULL
            ),
            downloadButton("report", "Generate report"),
            br(),
            br(),
            br()
          )  
          
        ),
        tabPanel(
          "Additional Resources",
          addinfo
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
    all_msg <- qdapRegex::ex_between(sno$msg, "<p>", "</p>")[[1]]
    print("all_msg")
    print(all_msg)
    session$userData$snow_or_no <- qdapRegex::ex_between(all_msg[1], "<strong>", "</strong>")[[1]]
    session$userData$snow_persistence <- all_msg[2]
    session$userData$oct_precip <-  all_msg[3]
    session$userData$may_precip <-  all_msg[4]
    session$userData$mean_temp <-  all_msg[5]
    
    

    
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
                h4(HTML("Step 2: Select Model")),
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
      user_fishabund_score2= case_when(
        input$fish_abundance_checkbox == TRUE ~ "0",
        input$fish_abundance_checkbox == FALSE ~ input$user_fishabund_score2
      ),
      user_alglivedead_cover_score=case_when(
        input$algae_checkbox == TRUE ~ "0",
        input$algae_checkbox == FALSE ~ input$user_alglivedead_cover_score
      ),
      user_DifferencesInVegetation_score=input$user_DifferencesInVegetation_score,
      user_BankWidthMean=input$user_BankWidthMean,
      user_Sinuosity_score=input$user_Sinuosity_score,
      user_hydric=input$user_hydric
    )
  })

  output$final_class <- renderUI({
    print("input$fish_abundance_checkbox")
    print(input$user_fishabund_score2)
    #Storing variables in session to use in the report
    session$userData$class <- classify() %>% as.character()
    session$userData$classmsg <- glue::glue(
      "The {case_when(
        input$paramchoice == 'sno' ~ 'snow influenced', 
        input$paramchoice == 'nosno' ~ 'non-snow influenced'
      )} model was applied to {session$userData$snow_or_no} site."
    )
    session$userData$modelused <- input$paramchoice
    session$userData$bankwidth <- input$user_BankWidthMean
    
    session$userData$user_fishabund_score2 <- input$user_fishabund_score2
    session$userData$user_Sinuosity_score <- input$user_Sinuosity_score
    session$userData$user_DifferencesInVegetation_score <- input$user_DifferencesInVegetation_score
    session$userData$user_alglivedead_cover_score <- input$user_alglivedead_cover_score
    
    
    HTML(glue::glue("<h5>This reach is classified as: <strong>{classify()}</strong></h5>"))})
  
  #------------ Report Tab
  
  # Need to process figures separately.
  
  # Site photos
  fig1 <- reactive({gsub("\\\\", "/", input$blu$datapath)})
  fig2 <- reactive({gsub("\\\\", "/", input$mld$datapath)})
  fig3 <- reactive({gsub("\\\\", "/", input$mlu$datapath)})
  fig4 <- reactive({gsub("\\\\", "/", input$tld$datapath)})
  fig5 <- reactive({gsub("\\\\", "/", input$sketch$datapath)})
  
  #Invertebrate photos
  fig6 <- reactive({gsub("\\\\", "/", input$inv1$datapath)})
  fig7 <- reactive({gsub("\\\\", "/", input$inv2$datapath)})
  fig8 <- reactive({gsub("\\\\", "/", input$inv3$datapath)})
  
  # Algae photos
  fig9 <- reactive({gsub("\\\\", "/", input$alg1$datapath)})
  fig10 <- reactive({gsub("\\\\", "/", input$alg2$datapath)})
  fig11 <- reactive({gsub("\\\\", "/", input$alg3$datapath)})
  
  # Fish photos
  fig12 <- reactive({gsub("\\\\", "/", input$fish1$datapath)})
  fig13 <- reactive({gsub("\\\\", "/", input$fish2$datapath)})
  fig14 <- reactive({gsub("\\\\", "/", input$fish3$datapath)})
  
  # Differences in vegetation photos
  fig15 <- reactive({gsub("\\\\", "/", input$veg1$datapath)})
  fig16 <- reactive({gsub("\\\\", "/", input$veg2$datapath)})
  fig17 <- reactive({gsub("\\\\", "/", input$veg3$datapath)})
  
  # Sinuosity photos
  fig18 <- reactive({gsub("\\\\", "/", input$sinu1$datapath)})
  fig19 <- reactive({gsub("\\\\", "/", input$sinu2$datapath)})
  fig20 <- reactive({gsub("\\\\", "/", input$sinu3$datapath)})
  
  # Supplemental Info photos
  fig21 <- reactive({gsub("\\\\", "/", input$add1$datapath)})
  fig22 <- reactive({gsub("\\\\", "/", input$add2$datapath)})
  fig23 <- reactive({gsub("\\\\", "/", input$add3$datapath)})
  
  
  # Populate the some of the widgets in the Report tab from the EnterData tab
  observeEvent(input$runmodel, {
    print("input$user_TotalAbundance")
    print(input$user_TotalAbundance)
    print("input$user_mayfly_abundance")
    print(input$user_mayfly_abundance)
    print("input$user_perennial_abundance")
    print(input$user_perennial_abundance)
    
    updateNumericInput(
      session,
      "aqua_inv",
      value = input$user_TotalAbundance
    )
    if (!is.null(input$user_mayfly_abundance) ){
      updateNumericInput(
        session,
        "may_flies",
        value = input$user_mayfly_abundance
      )
    }
    updateNumericInput(
      session,
      "indicator_taxa",
      value = input$user_perennial_abundance
    )
    updateNumericInput(
      session,
      "indicator_families",
      value = input$user_perennial_taxa
    )
    
    updateNumericInput(
      session,
      "vegetation_score",
      value = input$user_DifferencesInVegetation_score
    )
    
    updateNumericInput(
      session,
      "sinuosity",
      value = input$user_Sinuosity_score
    )
    
    # Update the radio buttons for Indicators
    print("RadioButtons")
    print(input$user_alglivedead_cover_score)
    print(input$user_fishabund_score2)
    print(input$user_DifferencesInVegetation_score)
    print(input$user_Sinuosity_score)
    print("----")
    
    # updateRadioButtons(
    #   session,
    #   "algae_streambed",
    #   selected = case_when(
    #     input$user_alglivedead_cover_score == "0" ~ "none",
    #     input$user_alglivedead_cover_score == "1" ~ "lessthan2",
    #     input$user_alglivedead_cover_score == "5" ~ "2to10",
    #     input$user_alglivedead_cover_score == "35" ~ "10to40",
    #     input$user_alglivedead_cover_score == "50" ~ "morethan40",
    #     
    #   )
    # )
    # 
    # updateRadioButtons(
    #   session,
    #   "fish_abundance",
    #   selected = case_when(
    #     input$user_fishabund_score2 == "0" ~ "poor",
    #     input$user_fishabund_score2 == "0.5" ~ "poor2",
    #     input$user_fishabund_score2 == "1" ~ "weak",
    #     input$user_fishabund_score2 == "1.5" ~ "weak2",
    #     input$user_fishabund_score2 == "2" ~ "moderate",
    #     input$user_fishabund_score2 == "2.5" ~ "moderate2",
    #     input$user_fishabund_score2 == "3" ~ "strong",
    #     
    #   )
    # )
    # 
    # updateRadioButtons(
    #   session,
    #   "vegetation_score",
    #   selected = case_when(
    #     input$user_DifferencesInVegetation_score == "0" ~ "poor",
    #     input$user_DifferencesInVegetation_score == "0.5" ~ "poor2",
    #     input$user_DifferencesInVegetation_score == "1" ~ "weak",
    #     input$user_DifferencesInVegetation_score == "1.5" ~ "weak2",
    #     input$user_DifferencesInVegetation_score == "2" ~ "moderate",
    #     input$user_DifferencesInVegetation_score == "2.5" ~ "moderate2",
    #     input$user_DifferencesInVegetation_score == "3" ~ "strong",
    #     
    #   )
    # )
    # 
    # updateRadioButtons(
    #   session,
    #   "sinuosity",
    #   selected = case_when(
    #     input$user_Sinuosity_score == "0" ~ "poor",
    #     input$user_Sinuosity_score == "0.5" ~ "poor2",
    #     input$user_Sinuosity_score == "1" ~ "weak",
    #     input$user_Sinuosity_score == "1.5" ~ "weak2",
    #     input$user_Sinuosity_score == "2" ~ "moderate",
    #     input$user_Sinuosity_score == "2.5" ~ "moderate2",
    #     input$user_Sinuosity_score == "3" ~ "strong",
    #     
    #   )
    # )

    
  })
  output$report <- downloadHandler(
    
    filename = glue::glue("Western Mountain Report ({format(Sys.time(), '%B %d, %Y')}).pdf"),
    content = function(file) {
      tryCatch({
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      # print(input[["final_class"]])
      # 
      # 
      # 
      showModal(modalDialog("Please wait while the report is being generated.....", footer=NULL))
      tempReport <- file.path("markdown/report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      print("fig6")
      print(fig6())
      print("input$algae_streambed")
      print(input$algae_streambed)
      # Set up parameters to pass to Rmd document
      params <- list(
        # -------------------Classification
        class_wm = session$userData$class,
        class_wm_msg = session$userData$classmsg,

        # -------------------General Site Information
        a = input$project,
        b = input$assessor,
        c = input$code,
        d = input$waterway,
        e = input$date,
        bm = case_when(input$radio_weather == 'heavyrain' ~ "Storm/heavy rain",
                       input$radio_weather == 'steadyrain' ~ "Steady rain",
                       input$radio_weather == 'intermittenrain' ~ "Intermittent rain",
                       input$radio_weather == 'snowing' ~ "Snowing",
                       input$radio_weather == 'cloudy' ~ "Cloudy",
                       input$radio_weather == 'clearsunny' ~ "Clear/Sunny"),


        j = input$weather,
        g = as.numeric(input$lat),
        h = as.numeric(input$lon),
        l = plyr::mapvalues(
          input$check_use, 
          from = c(
            "urban","agricultural", "openspace",
            "forested","othernatural","other"), 
          to = c(
            "Urban, industrial, or residential", "Agricultural","Developed open-space",
            "Forested","Other Natural","Other")
        ) %>% as.character() %>% paste0(collapse = ", "),
        f = input$boundary,
        fff = input$actreach,
        # bn = paste(as.character(input$radio_situation),collapse = ","),
        # 
        bn = plyr::mapvalues(
          input$radio_situation, 
          from = c(
            "flood","stream_modifications", "diversions",
            "discharges","drought","vegetation",
            "other","none"), 
          to = c(
            "Recent flood or debris flow","Stream modifications (e.g., channelization)","Diversions",
            "Discharges","Drought","Vegetation removal/limitations",
            "Other (explain in notes)","None")
        ) %>% as.character() %>% paste0(collapse = ", "),
        
        
        
        
        
        k = input$situation,
        
        # ------------------- Site Photos
        v = fig4(),
        u = fig3(),
        t = fig2(),
        s = fig1(),
        
        # ------------------- Observed Hydrology
        m = input$surfflow,
        n = input$subflow,
        o = input$pool,
        r = input$notes_observed_hydrology,
        # i = input$datum,
        # p = input$channel,
        
        # ------------------- Site Sketch
        w = fig5(),
        
        # ------------------- Climatic indicators
        snow_or_no = ifelse(
          is.null(session$userData$snow_or_no),
          "Data was not entered",
          session$userData$snow_or_no
        ),
        snow_persistence = ifelse(
          is.null(session$userData$snow_persistence),
          "Data was not entered",
          session$userData$snow_persistence
        ),
        oct_precip = ifelse(
          is.null(session$userData$oct_precip),
          "Data was not entered",
          session$userData$oct_precip
        ),
        may_precip = ifelse(
          is.null(session$userData$may_precip),
          "Data was not entered",
          session$userData$may_precip
        ),
        mean_temp = ifelse(
          is.null(session$userData$mean_temp),
          "Data was not entered",
          session$userData$mean_temp
        ),
        modelused = ifelse(
          is.null(session$userData$modelused),
          "Data was not entered",
          session$userData$modelused
        ),

        
        # ------------------- Biological indicators
        # ------------------- Aquatic Invertebrates
        aqua_inv = input$user_TotalAbundance,
        may_flies = input$user_mayfly_abundance,
        indicator_taxa = input$user_perennial_taxa,
        indicator_families = input$user_perennial_abundance,
        f6 = fig6(),
        f6_cap = input$inv1_cap,
        f7 = fig7(),
        f7_cap = input$inv2_cap,
        f8 = fig8(),
        f8_cap = input$inv3_cap,
        notes_aquainv = input$notes_aquainv,
        

        # ------------------- Aquatic Cover
        algae_streambed = case_when(input$user_alglivedead_cover_score == '0' ~ "None Detected",
                                    input$user_alglivedead_cover_score == '1' ~ "< 2%",
                                    input$user_alglivedead_cover_score == '5' ~ "2% to 10%",
                                    input$user_alglivedead_cover_score == '35' ~ "10% to 40%",
                                    input$user_alglivedead_cover_score == '50' ~ "40% and above"),
        ak = input$algae_checkbox,
        notes_algaecover = input$notes_algaecover,
        f9 = fig9(),
        f9_cap = input$alg1_cap,
        f10 = fig10(),
        f10_cap = input$alg2_cap,
        f11 = fig11(),
        f11_cap = input$alg3_cap,
        

        
        # ------------------- Fish Abundance
        fish_abundance = case_when(input$user_fishabund_score2 == '0' ~ "0 (Poor)",
                                   input$user_fishabund_score2 == '0.5' ~ "0.5",
                                   input$user_fishabund_score2 == '1' ~ "1 (Weak)",
                                   input$user_fishabund_score2 == '1.5' ~ "1.5",
                                   input$user_fishabund_score2 == '2' ~ "2 (Moderate)",
                                   input$user_fishabund_score2 == '2.5' ~ "2.5",
                                   input$user_fishabund_score2 == '3' ~ "3 (Strong)"
        ),
        fish_abundance_checkbox = input$fish_abundance_checkbox,
        notes_fish_abundance = input$notes_fish_abundance,
        f12 = fig12(),
        f12_cap = input$fish1_cap,
        f13 = fig13(),
        f13_cap = input$fish2_cap,
        f14 = fig14(),
        f14_cap = input$fish3_cap,
        

        # ------------------- Differences in vegetation
        vegetation_score = case_when(input$user_DifferencesInVegetation_score == '0' ~ "0 (Poor)",
                                     input$user_DifferencesInVegetation_score == '0.5' ~ "0.5",
                                     input$user_DifferencesInVegetation_score == '1' ~ "1 (Weak)",
                                     input$user_DifferencesInVegetation_score == '1.5' ~ "1.5",
                                     input$user_DifferencesInVegetation_score == '2' ~ "2 (Moderate)",
                                     input$user_DifferencesInVegetation_score == '2.5' ~ "2.5",
                                     input$user_DifferencesInVegetation_score == '3' ~ "3 (Strong)"
        ),
        notes_differences_vegetation = input$notes_differences_vegetation,
        f15 = fig15(),
        f15_cap = input$veg1_cap,
        f16 = fig16(),
        f16_cap = input$veg2_cap,
        f17 = fig17(),
        f17_cap = input$veg3_cap,
        
        # ------------------- Channel Width
        bankwidth = session$userData$bankwidth,
        

        # ------------------- Sinuosity
        sinuosity = case_when(input$user_Sinuosity_score == '0' ~ "0 (Poor)",
                              input$user_Sinuosity_score == '0.5' ~ "0.5",
                              input$user_Sinuosity_score == '1' ~ "1 (Weak)",
                              input$user_Sinuosity_score == '1.5' ~ "1.5",
                              input$user_Sinuosity_score == '2' ~ "2 (Moderate)",
                              input$user_Sinuosity_score == '2.5' ~ "2.5",
                              input$user_Sinuosity_score == '3' ~ "3 (Strong)"
        ),
        notes_sinuosity = input$notes_sinuosity,
        f18 = fig18(),
        f18_cap = input$sinu1_cap,
        f19 = fig19(),
        f19_cap = input$sinu2_cap,
        f20 = fig20(),
        f20_cap = input$sinu3_cap,
        
        # ------------------- Supplemental Information
        notes_supplemental_information = input$notes_supplemental_information,
        f21 = fig21(),
        f21_cap = input$add1_cap,
        f22 = fig22(),
        f22_cap = input$add2_cap,
        f23 = fig23(),
        f23_cap = input$add3_cap
        
        
        # # aa = fig6(),
        # ab = input$hyd1_cap,
        # #ac = fig7(),
        # ad = input$hyd2_cap,
        # #ae = fig8(),
        # af = input$hyd3_cap,
        # #ag = fig9(),
        # ah = input$hyd4_cap,
        # ai = case_when(input$radio_bmi == 0 ~ "None", 
        #                input$radio_bmi == 0.5 ~ "1 to 19",
        #                input$radio_bmi == 1 ~ "20+"),
        # aj = ifelse(input$radio_ept == 0, "No", "Yes"),
        # al = fig10(),
        # am = fig11(),
        # an = input$invnotes,
        # ao = case_when(input$radio_algae == 0 ~ "Not detected",
        #                input$radio_algae == 1 ~ "No, <10% cover",
        #                input$radio_algae == 2 ~ "Yes >10% cover"),
        # ap = fig12(),
        # aq = case_when(input$fish == 0 ~ "No fish observed",
        #                input$fish == 1 ~ "No, only mosquito fish observed",
        #                input$fish == 2 ~ "Yes, fish other than mosquitofish observed"),
        # ar = fig13(),
        # as = input$amph,
        # at = input$snake,
        # av = case_when(input$radio_hydro == 0 ~ "0 species",
        #                input$radio_hydro == 0.5 ~ "1 - 2 species",
        #                input$radio_hydro == 1 ~ "3+ species"),
        # ba = fig14(),
        # bb = input$algnotes,
        # bc = input$hydnotes,
        # bd = input$fishnotes,
        # be = input$add_cap,
        # # bf = input$other_ind,
        # bg = input$add_notes
        # bh = fig15(),
        # bi = input$add_cap2,
        # bo = input$hydro_comments,
        # #rf = predict_flowduration(),
        # tbl = predict_figure()#,
        #fig_map = fig_map()
      )
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(
        tempReport, 
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv())
      )
      removeModal()
      },
      warning = function(cond){
        showModal(
          modalDialog(
            "There was an error while generating the report. 
            Please contact Robert Butler (robertb@sccwrp.org) or Duy Nguyen (duyn@sccwrp.org) for more details.", 
            footer = modalButton("Ok")
          )
        )
        return(NULL)
      }
      )
    }
  )
  
}

shinyApp(ui=ui, server=server)
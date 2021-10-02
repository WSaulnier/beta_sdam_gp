source('global.R')
source('R/sno.R')
source('R/nosno.R')
### Maybe needed?
# install.packages('rmarkdown')
# install.packages('tinytex')
# tinytex::install_tinytex()  # install TinyTeX
###
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
          h1(HTML(
            "General Site Information")
          ),
          br(),
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
            selected = 'flood'
          ),
          textInput(
            inputId = "situation", 
            label = "Site disturbances/difficulties::" , 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          #------- Observed Hydrology
          h1(HTML(
            "Observed Hydrology")
          ),
          br(),
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
          
          #------- Site Photos
          h1(HTML("Site Photos")),
          br(),
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
          
          
          #------- Indicators
          h1(HTML("Indicators")),
          h2(HTML("Aquatic Invertebrates")),
          br(),
          numericInput(
            inputId = "aqua_inv",
            label = "Total abundance of aquatic invertebrates (optional): ",
            value = ""
          ),
          numericInput(
            inputId = "may_flies",
            label = "Total abundance of mayflies (optional): ",
            value = ""
          ),
          numericInput(
            inputId = "indicator_taxa",
            label = "Total abundance of perennial indicator taxa (optional):",
            value = ""
          ),
          numericInput(
            inputId = "indicator_families",
            label = "Total number of perennial indicator families (optional):",
            value = ""
          ),
          textInput(
            inputId = "notes", 
            label = "Notes about aquatic invertebrates:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "inv1", 
            HTML("Invertebrate Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "inv1_cap", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "inv2", 
            HTML("Invertebrate Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "inv2_cap", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "inv3", 
            HTML("Invertebrate Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          
          textInput(
            inputId = "inv3_cap", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          br(),
          #------- Algae Cover
          h2(HTML("Algae Cover")),
          br(),
          numericInput(
            inputId = "algae_streambed",
            label = "Algae cover on the streambed:",
            value = "",
          ),
          checkboxInput(
            "algae_checkbox", 
            "Check if all observed algae appear to be deposited from an upstream source", 
            value = FALSE, 
            width = NULL
          ),
          textInput(
            inputId = "algnotes", 
            label = "Notes about algae cover:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "alg1", 
            HTML("Algae Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "alg1_cap", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "alg2", 
            HTML("Algae Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "alg2_cap", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "alg3", 
            HTML("Algae Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          
          textInput(
            inputId = "alg3_cap", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          br(),
          
          #------- Fish Abundance
          h1(HTML("Fish abundance")),
          br(),
          numericInput(
            inputId = "fish_abundance",
            label = "Fish Abundance:",
            value = "",
          ),
          checkboxInput(
            "fish_abundance", 
            "Check if all fish observed are mosquitofish", 
            value = FALSE, 
            width = NULL
          ),
          textInput(
            inputId = "notes_fish_abundance", 
            label = "Notes about fish abundance:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "fish1", 
            HTML("Fish Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "fish1_cap", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "fish2", 
            HTML("Fish Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "fish2_cap", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "fish3", 
            HTML("Fish Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "fish3_cap", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          br(),
          
          #------- Differences in vegetation
          h1(HTML("Differences in vegetation")),
          br(),
          numericInput(
            inputId = "vegetation_score",
            label = "Differences in vegetation score (optional): ",
            value = "",
          ),
          textInput(
            inputId = "notes_differences_vegetation", 
            label = "Notes about differences in vegetation:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "veg1", 
            HTML("Vegetation Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "veg1_cap", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "veg2", 
            HTML("Vegetation Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "veg2_cap", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "veg3", 
            HTML("Vegetation Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "veg3_cap", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          br(),
          
          #------- Sinuosity
          h1(HTML("Sinuosity")),
          br(),
          numericInput(
            inputId = "sinuosity",
            label = "Sinuosity score (optional): ",
            value = "",
          ),
          textInput(
            inputId = "notes_sinuosity", 
            label = "Notes about sinuosity:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "sinu1", 
            HTML("Sinuosity Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "sinu1", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "sinu2", 
            HTML("Sinuosity Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "sinu2", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          fileInput(
            "sinu3", 
            HTML("Sinuosity Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          
          textInput(
            inputId = "sinu3", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          br(),
          
          #------- Supplemental Information
          h1(HTML("Supplemental Information")),
          br(),
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
            HTML("Additional Photo #1<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "add1_cap", 
            label = "Figure 1 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          fileInput(
            "add2", 
            HTML("Additional Photo #2<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          textInput(
            inputId = "add2_cap", 
            label = "Figure 2 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          
          
          fileInput(
            "add3", 
            HTML("Additional Photo #3<br />Upload photo file here."), 
            accept = c('image/png', 'image/jpeg')
          ),
          
          textInput(
            inputId = "add3_cap", 
            label = "Figure 3 Caption:", 
            value = "", 
            width = NULL, 
            placeholder = NULL
          ),
          downloadButton("report", "Generate report.")
          
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  
  sno <- eventReactive(
    input$snobutton, 
    {
      select
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
  
  #------------ Report Tab
  
  # Need to process figures separately.
  
  # Site photos
  fig1 <- reactive({gsub("\\\\", "/", input$blu$datapath)})
  fig2 <- reactive({gsub("\\\\", "/", input$mld$datapath)})
  print("fig2")
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
  fig19 <- reactive({gsub("\\\\", "/", input$sinu3$datapath)})
  
  # Supplemental Info photos
  fig20 <- reactive({gsub("\\\\", "/", input$add1$datapath)})
  fig21 <- reactive({gsub("\\\\", "/", input$add2$datapath)})
  fig22 <- reactive({gsub("\\\\", "/", input$add3$datapath)})
  
  
  
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
    
    
    
    
  })
  output$report <- downloadHandler(
    filename = "Western_Mountain_report.pdf",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path("pdf/report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      print("input$radio_situation")
      print(input$radio_situation)
      
      # Set up parameters to pass to Rmd document
      params <- list(
        # -------------------General Site Information
        a = input$project,
        b = input$assessor,
        c = input$code,
        d = input$waterway,
        e = input$date,
        bm = case_when(input$radio_weather == 0~"Storm/heavy rain",
                       input$radio_weather == 1~"Steady rain",
                       input$radio_weather == 2~"Intermittent rain",
                       input$radio_weather == 3~"Snowing",
                       input$radio_weather == 4~"Cloudy",
                       input$radio_weather == 5~"Clear/Sunny"),
        j = input$weather,
        g = as.numeric(input$lat),
        h = as.numeric(input$lon),
        l = case_when(input$check_use == 0 ~ "Urban/industrial/residential",
                      input$check_use == 1 ~ "Agricultural",
                      input$check_use == 2 ~ "Developed open-space",
                      input$check_use == 3 ~ "Forested",
                      input$check_use == 4 ~ "Other natural",
                      input$check_use == 5 ~ "Other"),
        f = input$boundary,
        fff = input$actreach,
        bn = input$radio_situation,
        k = input$situation,
        
        # ------------------- Site Photos
        v = fig4(),
        u = fig3(),
        t = fig2(),
        s = fig1(),
        
        # ------------------- Observed Hydrology
        i = input$datum,
        m = input$surfflow,
        n = input$subflow,
        o = input$pool,
        p = input$channel,
        r = input$notes_observed_hydrology,
        # # w = fig5(),
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
        ak = input$algae_checkbox,
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
        bb = input$algnotes,
        bc = input$hydnotes,
        bd = input$fishnotes,
        be = input$add_cap,
        # bf = input$other_ind,
        bg = input$add_notes
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
    }
  )
  
}

shinyApp(ui=ui, server=server)
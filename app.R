source('global.R')
# source('additionalinfo.R')
source('./R/background.R')
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
        .border-my-text {
            border: 2px solid black;
            border-padding: 2px;
            background-color: #b4bfd1;
            text-align: center;
        }
        .border-my-class {
            border: 2px solid black;
            border-padding: 2px;
            background-color: black;
            color: white;
            text-align: center;
        }
        #reg_button {
            background-color:#94d9f2;
            padding: 7px;
            font-size: 110%;
            font-weight: bold;
            border-style: outset;
            
            box-shadow: 0 8px 12px 0 rgba(0,0,0,0.24), 0 1px 1px 0 rgba(0,0,0,0.19);
            transition-duration: 0.1s;
        }
        #reg_button:hover {
            background-color:#5d8b9c;
            color: black;
            border-style: solid;
            border-color: black;
            border-width: px;
        }
        #runmodel {
            background-color:#94d9f2;
            padding: 7px;
            font-size: 110%;
            font-weight: bold;
            border-style: outset;
            
            box-shadow: 0 8px 12px 0 rgba(0,0,0,0.24), 0 1px 1px 0 rgba(0,0,0,0.19);
            transition-duration: 0.1s;
        }
        #runmodel:hover {
            background-color:#5d8b9c;
            color: black;
            border-style: solid;
            border-color: black;
            border-width: px;
        }
        #report {
            background-color:#94d9f2;
            padding: 7px;
            font-size: 110%;
            font-weight: bold;
            border-style: outset;
            
            box-shadow: 0 8px 12px 0 rgba(0,0,0,0.24), 0 1px 1px 0 rgba(0,0,0,0.19);
            transition-duration: 0.1s;
        }
        #report:hover {
            background-color:#5d8b9c;
            color: black;
            border-style: solid;
            border-color: black;
            border-width: px;
        }
        .leaflet-popup-content {
            text-align: center;
        }


    "))
    ),

    titlePanel(
        div(
            class="jumbotron",
            h2(HTML(
                "Web application for the Beta Streamflow Duration Assessment Method for Great Plains Region (Beta SDAM GP)
        ")
            ),
            h4(HTML("<p>Version <a href=\"https://github.com/WSaulnier/beta_sdam_gp\">1.0.1</a> Release date: July 2022 </p>")),
            img(src="eph.jpg", style = "height: 400px"),
            img(src="int2.jpg", style = "height: 400px"),
            img(src="per2.jpg", style = "height: 400px")
        ),
        "SDAM Great Plains"
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
                    fluidRow(column(12, h3("Step 1: Enter coordinates or select Great Plains region"), 
                                    )),
                    # coordinates----
                    fluidRow(
                      column(12,
                             selectInput(
                               "vol_region",
                               label = HTML("<b><i>Select method for determining Great Plains region.</b></i>"),
                               choices = c(
                                 "Enter Coordinates",
                                 "Select Great Plains Region",
                                 "Select Location on Map"
                               ),
                               selected = "No",
                               width = '20%'
                             )
                      )
                    ),
                    fluidRow(
                        column(7,
                               HTML('<hr style="color: black; height: 1px; background-color: black;">')
                               )
                    ),
                    
                    conditionalPanel(
                        
                      condition = "input.vol_region == 'Enter Coordinates'",
                      fluidRow(
                          column(
                              4,
                              div(HTML('<b><i>Enter coordinates in decimal degrees to determine if the site is in the study area and if the site is in the Northern or Southern Plains Region. </i></b>')),
                              div(id = "placeholder"),
                              div(id = "coords",
                                fluidRow(
                                  # div(id = "placeholder",
                                    column(4,
                                           numericInput("lat", label = NULL, value =  46.993162)),
                                    column(1, h5("Latitude"))
                                ),
                                fluidRow(
                                    column(4,numericInput("lon", label = NULL, value = -103.517482)),
                                    column(1, h5("Longitude"))
                                ),
                                fluidRow(
                                    column(4,
                                           br(),
                                           div(actionButton("reg_button", 
                                                            label=div("Assess Plains Region", icon('long-arrow-right'))
                                                            ) 
                                               ))
                                )
                              )
                          ),
                          column(
                              4,
                              conditionalPanel(
                                  condition = "input.reg_button != 0",
                                  
                                  uiOutput(outputId = "reg_class") %>%
                                      tagAppendAttributes(class = 'border-my-text')
                              )
                          )
                      )
                    ),
                    conditionalPanel(
                      condition = "input.vol_region == 'Select Great Plains Region'",
                      fluidRow(
                        column(12,
                               selectInput(
                                 "user_region",
                                 HTML("<b><i>Select Great Plains Region if not entering coordinates:</b></i>"),
                                 c(
                                   "No Region Selected" = "No Region",
                                   "Northern Great Plains" = "Northern",
                                   "Southern Great Plains" = "Southern"
                                 )
                               )
                        )
                      )
                    ),
                    ## leaflet map----
                    conditionalPanel(
                        condition = "input.vol_region == 'Select Location on Map'",
                        fluidRow(
                            column(6,
                                leafletOutput("map", height ='500px')
                            )
                        )
                    ),
                    ## break
                    fluidRow(
                        column(
                            12,
                            HTML('<hr style="color: black; height: 7px; background-color: black;">')
                        )
                    ),
                    
                    fluidRow(
                        column(
                            7,
                            
                            h3(HTML("Step 2: Enter required indicator data")),
                            
                            # biological indicators----
                            h4(HTML("<b><u>Biological Indicators</u></b>")),
                            fluidRow(
                                column(
                                    4,
                                    numericInput("user_EPT", label = NULL, value = 0, min = 0, max = 100, step = 1)
                                ),
                                column(
                                    4,
                                    h6("Number of EPT families identified from the assessment reach")
                                )
                            ),
                            
                            
                            fluidRow(
                                column(
                                    4,
                                    numericInput("user_Hydrophyte", label = NULL, value = 0, min = 0, step = 1)
                                ),
                                column(
                                    4,
                                    h6("Number of hydrophytic plant species without an odd distribution (e.g., <2% of assessment area) from the assessment reach")
                                )
                            ),
                            
                            
                            fluidRow(
                                column(
                                    12,
                                    radioButtons(
                                        "user_UplandRootedPlants", 
                                        HTML("<b><i>Absence of upland rooted plants in the streambed</b></i>"),
                                        c(
                                            "0 (Poor)" = 0,
                                            "0.5" = 0.5,
                                            "1 (Weak)" = 1,
                                            "1.5" = 1.5,
                                            "2 (Moderate)" = 2,
                                            "2.5" = 2.5,
                                            "3 (Strong)" = 3
                                        ),
                                        inline = T
                                    )
                                )
                            ),
                            fluidRow(
                                column(
                                    12,
                                    checkboxInput(
                                        "upland_checkbox", 
                                        "Check if no vegetation within reach.", 
                                        value = FALSE, 
                                        width = NULL
                                    )
                                )
                            ),
                            
                            fluidRow(
                                column(width = 12,
                                       HTML('<hr style="color: black; height: 1px; background-color: black;">'),
                                       numericInputIcon("select",
                                                        "Enter the Number of Densiometer Readings (min. 1, max. 12)",
                                                        min = 1,
                                                        max = 12,
                                                        value = 3,
                                                        step = 1,
                                                        icon = icon("hashtag"))
                                )
                            ),
                            
                            
                            h5(HTML("<b>Densiometer Reading</b>")),
                            fluidRow(
                                column(
                                    width = 6,
                                    uiOutput("densiUI")
                                ),
                                column(
                                    width = 6,
                                    uiOutput(outputId = "text") %>%
                                        tagAppendAttributes(class = "border-my-text")
                                ),
                                column(width = 12,
                                       HTML('<hr style="color: black; height: 3px; background-color: black;">')
                                )
                            ),
                            
                            # geomorphic indicators----
                            
                            h4(HTML("<b><u>Geomorphic indicators</u></b>")),
                            fluidRow(
                                column(
                                    12,
                                    radioButtons(
                                        "user_Substrate", 
                                        HTML("<b><i>Particle size/stream substrate sorting</b></i>"),
                                        c(
                                            "0 (Poor)" = 0,
                                            "0.75" = 0.75,
                                            "1.5 (Weak)" = 1.5,
                                            "2.25" = 2.25,
                                            "3 (Strong)" = 3
                                        ),
                                        inline = T
                                    )
                                )
                            ),
                            fluidRow(
                                column(
                                    12,
                                    radioButtons(
                                        "user_ChannelDimensions", 
                                        HTML("<b><i>Floodplain and channel dimensions</b></i>"),
                                        c(
                                            "0 (Poor)" = 0,
                                            "1.5 (Moderate)" = 1.5,
                                            "3 (Strong)" = 3
                                        ),
                                        inline = T
                                    )
                                )
                            ),
                            
                            
                            fluidRow(
                                column(
                                    12,
                                    radioButtons(
                                        "user_Sinuosity", 
                                        HTML("<b><i>Sinuosity</i></b>"),
                                        c(
                                            "0 (Poor)" = 0,
                                            "1 (Weak)" = 1,
                                            "2 (Moderate)" = 2,
                                            "3 (Strong)" = 3
                                        ),
                                        inline = T
                                    )
                                )
                            ),
                            
                            
                            fluidRow(
                                HTML('<hr style="color: black; height: 1px; background-color: black;">'),
                                column(width = 12,
                                       numericInputIcon("select_bank",
                                                        "Enter the Number of Bankful Measurements (min. 1, max. 3)",
                                                        min = 1,
                                                        max = 3,
                                                        value = 3,
                                                        step = 1,
                                                        icon = icon("hashtag"))
                                )
                            ),
                            fluidRow(
                                column(
                                    width = 6,
                                    uiOutput("bankUI")
                                ),
                                column(
                                    width = 6,
                                    uiOutput(outputId = "bank_text") %>%
                                        tagAppendAttributes(class = 'border-my-text')
                                )
                            ),
                            fluidRow(
                                
                                HTML('<hr style="color: black; height: 3px; background-color: black;">'),
                                tags$head(
                                    tags$style(HTML('#runmodel {background-color:#94d9f2;
                                                            padding: 8px;
                                                            font-size: 110%;
                                                            font-weight: bold;
                                                            border-style: outset;
                                                            
                                                            box-shadow: 0 8px 12px 0 rgba(0,0,0,0.24), 0 1px 1px 0 rgba(0,0,0,0.19);
                                                            transition-duration: 0.1s;
                                                            }',
                                                    '#runmodel:hover {
                                                            background-color:#5d8b9c;
                                                            color: black;
                                                            border-style: solid;
                                                            border-color: black;
                                                            border-width: px;
                                                            
                                                            }'))
                                ),
                                column(
                                    6,
                                    actionButton("runmodel", div("Run Model", icon('long-arrow-right')))
                                ),
                                column(
                                    6,
                                    conditionalPanel(
                                        condition = "input.runmodel != 0",
                                        uiOutput("class_out") %>%
                                            tagAppendAttributes(class = 'border-my-class')
                                    )
                                ),
                            ),
                            fluidRow(
                                column(
                                    12,
                                    br(), br(), br(), br(), br(), br()
                                    
                                )
                            )
                        )
                    ),
                    
                    
                    # Report Inputs----   
                    conditionalPanel(
                        condition = "output.class_out",

                        ## General Information----
                        HTML('<hr style="color: black; height: 6px; background-color: black;">'),
                        h3(HTML(
                            "Step 3: Enter additional information (optional)")
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
                                "Intermittent Rain" = 'intermittentrain',
                                "Snowing" = 'snowing',
                                "Cloudy" = 'cloudy',
                                "Clear/Sunny" = 'clearsunny'
                            ),
                            selected = NULL
                        ),
                        textAreaInput(
                            "weather",
                            label = "Notes on current or recent weather conditions:" ,
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        checkboxGroupInput(
                            inputId = "check_use",
                            label = "Surrounding land-use within 100 m (check one or two):",
                            choices = c(
                                "Urban, industrial, or residential" = 'urban',
                                "Agricultural" = 'agricultural',
                                "Developed open-space (e.g., golf course, parks, lawn grasses)" = 'openspace',
                                "Forested" = 'forested',
                                "Other Natural" = 'othernatural',
                                "Other" = 'other'
                            ),
                            selected = NULL
                        ),
                        textAreaInput(
                            inputId = "boundary",
                            label = "Describe reach boundaries:" ,
                            value = "",
                            width = '300px',
                            height = '300px',
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
                                "Water discharges" = 'discharges',
                                "Drought" = 'drought',
                                "Vegetation removal/limitations" = 'vegetation',
                                "Other (explain in notes)" = 'other',
                                "None" = 'none'
                            ),
                            selected = NULL
                        ),
                        textAreaInput(
                            inputId = "situation",
                            label = "Site disturbances/difficulties:" ,
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        
                        ## Observed Hydrology----
                        HTML('<hr style="color: black; height: 3px; background-color: black;">'),
                        h4(HTML(
                            "<b>Observed Hydrology</b>")
                        ),
                        numericInput(
                            inputId = "surfflow",
                            label = "Percent of reach with surface flows:",
                            value = 0,
                            min = 0,
                        ),
                        numericInput(
                            inputId = "subflow",
                            label = "Percent of reach with surface and sub-surface flows:",
                            value = 0,
                            min = 0,
                        ),
                        numericInput(
                            inputId = "pool",
                            label = "Number of isolated pools:",
                            value = 0,
                            min = 0,
                        ),
                        textAreaInput(
                            inputId = "notes_observed_hydrology",
                            label = "Comments on observed hydrology:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        
                        ## Indicators----
                        HTML('<hr style="color: black; height: 3px; background-color: black;">'),
                        h4(HTML("<b>Add photos and notes about indicators</b>")),
                        
                        ### General Photos----
                        slatesFileInput(
                            "tld",
                            "Top of reach looking downstream:",
                            accept = c('image/png', 'image/jpeg')
                        ),
                        
                        slatesFileInput(
                            "mlu",
                            "Middle of reach looking upstream:",
                            accept = c('image/png', 'image/jpeg')
                        ),
                        
                        slatesFileInput(
                            "mld",
                            "Middle of reach looking downstream:",
                            accept = c('image/png', 'image/jpeg')
                        ),
                        
                        slatesFileInput(
                            "blu",
                            "Bottom of reach looking upstream:",
                            accept = c('image/png', 'image/jpeg')
                        ),
                        
                        slatesFileInput(
                            "sketch",
                            "Site Sketch:",
                            accept = c('image/png', 'image/jpeg')
                        ),
                        ### EPT Taxa.-----
                        h4(HTML("<b>Aquatic Invertebrates</b>")),
                        textAreaInput(
                            inputId = "notes_ept_taxa",
                            label = "Notes about EPT Taxa:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        slatesFileInput(
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
                        slatesFileInput(
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
                        slatesFileInput(
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
                        slatesFileInput(
                            "inv4",
                            HTML("Invertebrate Photo #4<br /> <span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "inv4_cap",
                            label = HTML("<span style='font-weight:normal'> Invertebrate Photo #4 caption: </span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "inv5",
                            HTML("Invertebrate Photo #5<br /> <span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "inv5_cap",
                            label = HTML("<span style='font-weight:normal'>Invertebrate Photo #5 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "inv6",
                            HTML("Invertebrate Photo #6<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "inv6_cap",
                            label = HTML("<span style='font-weight:normal'>Invertebrate Photo #6 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        
                        ### Hydrophytes----
                        h4(HTML("<b>Hydrophytic Plant Abundance</b>")),
                        
                        textAreaInput(
                            inputId = "notes_hydrophytes",
                            label = "Notes about hydrophytes:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro1",
                            HTML("Hydrophyte Photo #1<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro1_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #1 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro2",
                            HTML("Hydrophyte Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro2_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #2 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro3",
                            HTML("Hydrophyte Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro3_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #3 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro4",
                            HTML("Hydrophyte Photo #4<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro4_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #4 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro5",
                            HTML("Hydrophyte Photo #5<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro5_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #5 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "hydro6",
                            HTML("Hydrophyte Photo #6<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "hydro6_cap",
                            label = HTML("<span style='font-weight:normal'>Hydrophyte Photo #6 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        
                        ### Substrate----
                        h4(HTML("<b>Particle size or stream substrate sorting</b>")),
                        
                        textAreaInput(
                            inputId = "notes_substrate",
                            label = "Notes about substrate sorting:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "sub1",
                            HTML("Substrate Photo #1<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "sub1_cap",
                            label = HTML("<span style='font-weight:normal'>Substrate Photo #1 caption: </span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "sub2",
                            HTML("Substrate Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "sub2_cap",
                            label = HTML("<span style='font-weight:normal'>Substrate Photo #2 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        
                        slatesFileInput(
                            "sub3",
                            HTML("Substrate Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "sub3_cap",
                            label = HTML("<span style='font-weight:normal'>Substrate Photo #3 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        ### Upland Rooted-----
                        h4(HTML("<b>Absence of upland rooted plants in the streambed</b>")),
                        textAreaInput(
                            inputId = "notes_rooted", 
                            label = "Notes about upland rooted vegetation:", 
                            value = "", 
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "veg1", 
                            HTML("Upland Rooted Plants Photo #1<br/><span style='font-weight:normal'>Upload photo file here:</span>"), 
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "veg1_cap", 
                            label = HTML("<span style='font-weight:normal'>Upland Rooted Plants Photo #1 caption:</span>"), 
                            value = "", 
                            width = NULL, 
                            placeholder = NULL
                        ),
                        
                        slatesFileInput(
                            "veg2", 
                            HTML("Upland Rooted Plants Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "veg2_cap", 
                            label = HTML("<span style='font-weight:normal'>Upland Rooted Plants Photo #2 caption:</span>"), 
                            value = "", 
                            width = NULL, 
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "veg3", 
                            HTML("Upland Rooted Plants Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"), 
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "veg3_cap", 
                            label = HTML("<span style='font-weight:normal'>Upland Rooted Plants Photo #3 caption: </span>"), 
                            value = "", 
                            width = NULL, 
                            placeholder = NULL
                        ),
                        ### Channel Dimensions----
                        h4(HTML("<b>Floodplain and Channel Dimensions</b>")),
                        
                        textAreaInput(
                            inputId = "notes_channel",
                            label = "Notes on floodplain and channel dimensions:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        numericInput(
                            inputId = "bankfull_2x",
                            label = "2x maximum bankfull depth (m.m):",
                            value = 0,
                            min = 0,
                        ),
                        numericInput(
                            inputId = "floodprone",
                            label = "Flood-prone width (m.m):",
                            value = 0,
                            min = 0,
                        ),
                        numericInput(
                            inputId = "entrench",
                            label = "Entrenchment Ratio:",
                            value = 0,
                            min = 0,
                        ),
                        slatesFileInput(
                            "channel1",
                            HTML("Channel Photo #1<br/><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "channel1_cap",
                            label = HTML("<span style='font-weight:normal'>Channel Photo #1 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "channel2",
                            HTML("Channel Photo #2<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "channel2_cap",
                            label = HTML("<span style='font-weight:normal'>Channel Photo #2 caption:</span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        slatesFileInput(
                            "channel3",
                            HTML("Channel Photo #3<br /><span style='font-weight:normal'>Upload photo file here:</span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        textInput(
                            inputId = "channel3_cap",
                            label = HTML("<span style='font-weight:normal'>Channel Photo #3 caption: </span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        
                        ### Sinuosity----
                        h4(HTML("<b>Sinuosity</b>")),

                        textAreaInput(
                            inputId = "notes_sinuosity",
                            label = "Notes about sinuosity:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        numericInput(
                            inputId = "valley_length",
                            label = "Valley length (m):",
                            value = 0,
                            min = 0,
                        ),
                        slatesFileInput(
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
                        slatesFileInput(
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
                        slatesFileInput(
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
                        
                        ## Notes and Photos----
                        h4(HTML("<b>Supplemental Information</b>")),
                        HTML(
                            "If observed, note the presence of the aquatic life stages of amphibians,
                            snakes, or turtles; iron-oxidizing bacteria and fungi; etc."
                        ),
                        
                        textAreaInput(
                            inputId = "notes_supplemental_information",
                            label = "Additional notes about the assessment:",
                            value = "",
                            width = '300px',
                            height = '300px',
                            placeholder = NULL
                        ),
                        
                        HTML('<hr style="color: black; height: 3px; background-color: black;">'),    
                        h4(HTML("<b>Additional Photos</b>")),
                        slatesFileInput(
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
                        slatesFileInput(
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
                        
                        
                        slatesFileInput(
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
                        slatesFileInput(
                            "add4",
                            HTML("Additional Photo #4<br /> <span style='font-weight:normal'>Upload photo file here: </span>"),
                            accept = c('image/png', 'image/jpeg')
                        ),
                        
                        textInput(
                            inputId = "add4_cap",
                            label = HTML("<span style='font-weight:normal'>Additional Photo #4 caption: </span>"),
                            value = "",
                            width = NULL,
                            placeholder = NULL
                        ),
                        
                        downloadButton("report", "Generate report"),
                        br(),
                        br(),
                        br()
                    )
                    
                )
                
            )
        )
    )
)


# tabPanel(
#     "Additional Resources",
#     addinfo
# )

# server-----------------------------------------------------------------------
server <- function(input, output, session) {
    
    # region -----


    region_class <- eventReactive(c(input$reg_button, input$map_click,input$vol_region),{
        if(!is.null(map_coords()) && input$vol_region == 'Select Location on Map'){
            x <- point_region(map_coords()[1], map_coords()[2])
        } else {
            x <- point_region(user_lat = input$lat, user_lon = input$lon)
        }
        x
    })
    



    observe({
        print(is.atomic(region_class()))
        if (is.atomic(region_class())){
            print(region_class())
        } else {
        print(region_class()$region)
        }
    })
    
  # if site is out of GP regions, offer a URL to alternate SDAM.  If site out of SDAM
  # study areas, return warning message from global function
  observeEvent(c(input$reg_button, region_class()),{
      
      if (is.atomic(region_class())){
          output$reg_class <- renderUI ({
              h2(HTML(paste0("<b>Great Plains Region: <br>", region_class(), "</b>")))
          })
      } else
          if (!is.atomic(region_class())){
          print(region_class()$region)
          if (region_class()$region != 'Northern' && region_class()$region != 'Southern' && !is.na(region_class()$region)){
              print(region_class()$URL)
              if (region_class()$URL != 'development' && region_class()$URL != 'planning'){
                  show_alert(
                      title = "Location Error!",
                      text = tagList(
                          tags$p(HTML(paste0("This site is outside of the Great Plains SDAM study area  The site is located in the ",
                                             '<a href=\"', region_class()$URL, '">',
                                             region_class()$region), ' SDAM.</a>')
                          )
                      ),
                      type = "error"
                  )
              } else {
                  show_alert(
                      title = "Location Error!",
                      text = tagList(
                          tags$p(HTML(paste0("This site is located outside of the Great Plains SDAM study area.  The site is located in the <b>",
                                             region_class()$region, "</b> SDAM region.  The ",
                                             region_class()$region, " is in the <b>",
                                             region_class()$URL, "</b> stage. If you would like to proceed with running the Great Plains
                                   model, you may exit this dialogue and select a Great Plains region."))
                          )
                      ),
                      type = "error"
                  )
              }

          } else if (is.na(region_class()$region)){

              show_alert(
                  title = "Location Error!",
                  text = tagList(
                      tags$p(HTML(paste0("The location of your site is outside of the SDAM study areas.",
                                         " Please check your latitude and longitude coordinates to ensure they are entered correctly.<br>",
                                         " If you would like to proceed with running the Great Plains",
                                         " model, you may exit this dialogue and select a Great Plains region.")
                      )
                      )
                  ),
                  type = "error"
              )

          } else {
              output$reg_class <- renderUI ({
                  if(!is.na(region_class()$region)){
                      if(region_class()$region == 'Northern' || region_class()$region == 'Southern'){
                          h2(HTML(paste0("<b>Great Plains Region: <br>", region_class()$region, "</b>")))
                      } else {
                          h2(HTML(paste0("<b>SDAM Region: <br>", region_class()$region, "</b>")))
                      }
                  }
              })
          }
      }
  })

    # leaflet map render-----
    output$map <- renderLeaflet({
        factPal <- colorFactor(pal = rainbow(9), levels = regions_leaflet$SDAM)
        leaflet(regions_leaflet) %>%
            addPolygons(stroke = FALSE,
                        fillOpacity = 0.3,
                        smoothFactor = 2,
                        color = ~factPal(regions_leaflet$SDAM),
                        group = "SDAM Regions") %>%
            setView(lng = -100,
                    lat = 40,
                    zoom = 6) %>%
            addLegend("bottomright",
                      title = HTML("<b><u>SDAM Regions</u></b>"),
                      pal = factPal,
                      values = regions_leaflet$SDAM,
                      group = "SDAM Regions") %>%

            addProviderTiles(providers$Esri.NatGeoWorldMap,
                             group = 'NatGeo World (Default)') %>%
            addProviderTiles(providers$Esri.WorldImagery,
                             group = 'Imagery') %>%
            addLayersControl(
                baseGroups=c("NatGeo World (Default)", "Imagery"),
                overlayGroups = "SDAM Regions",
                options = layersControlOptions(collapsed = FALSE)) %>%
            leafem::addMouseCoordinates() %>%
            addFullscreenControl()
    })
  
    # coordinates 
    map_coords <- reactive({
        click = input$map_click
        if(is.null(click))
            return()
        coords = c(round(click$lat,4), round(click$lng,4))
        updateNumericInput(
            session,
            "lat",
            value = coords[1]
        )
        updateNumericInput(
            session,
            "lon",
            value = coords[2]
        )
        coords
    })

    # map click----
    observe({
        click = input$map_click
        if(is.null(click))
            return()
        region <- if(region_class()$region == 'Southern' || region_class()$region == 'Northern'){
            paste0(region_class()$region, ' Great Plains')
        } else {
            paste0(region_class()$region, ' SDAM Region')
        }
       
        text<-HTML(paste("<b><u>", region, "</u></b><br>",
            "Latitude: ", round(click$lat, 4), ", Longtitude: ", round(click$lng, 4)))
        text2<-paste("You've selected point ", text)
        map_proxy = leafletProxy("map") %>%
            clearPopups() %>%
            addPopups(round(click$lng, 4), round(click$lat, 4), text)

        print(paste0(click$lat, ', ', click$lng))
    })




    # percent shade calculation -----
    # dynamic UI output for length 1:12 for densiometer recordings
    output$densiUI <- renderUI({
        lapply(
            X = 1:input$select,
            FUN = function(i) {
                sliderInput(inputId = paste0("densi", i), label = i, min = 0, max = 17, value = i)
            }
        )
    })
    
    # dynamic UI list of inputs for densiometer recordings
    densi_list <- eventReactive(input$select, {
        lapply(
            X = 1:input$select,
            FUN = function(i) {
                input = paste0('densi', i)
            }
        )
    })
    
    # Densiometer input names for use in report possibly
    densi_inputs <- reactive({
        list_names <- c()
        for(x in 1:length(densi_list())){
            list_names[[x]] <- paste(densi_list()[x])
        }
        return(list_names)
    })
    
    # Densiometer input values
    densi_values <- reactive({
        list_values <- c()
        for(x in 1:length(densi_list())){
            list_values[[x]] <- input[[paste(densi_list()[[x]])]]
        }
        return(list_values)
    })
    
    # calculated shade percentage
    densi_shade_perc <- eventReactive(densi_values(),{
        round((Reduce("+", densi_values()) / (input$select* 17))*100,2)
    })
    densi_shade_dec <- eventReactive(densi_values(),{
        round((Reduce("+", densi_values()) / (input$select* 17)),2)
    })
    
    # Show user calculated percent value
    output$text <- renderUI ({
        
        h3(HTML(paste0("<b>Percent Shade: ", densi_shade_perc(), "%")))
        
    })
    
    # Bankfull width calculation----
    
    # dynamic UI output for length 1:3 for bankfull width recordings
    output$bankUI <- renderUI({
        lapply(
            X = 1:input$select_bank,
            FUN = function(i) {
                numericInput(inputId = paste0("bank", i),
                             label = paste0("Bankfull Measurement ", i), 
                             value = 0)
            }
        )
    })
    
    # dynamic UI list of inputs for bankfull width recordings
    bank_list <- eventReactive(input$select_bank, {
        lapply(
            X = 1:input$select_bank,
            FUN = function(i) {
                input = paste0('bank', i)
            }
        )
    })
    
    # Densiometer input names to be possibly used in report
    bank_inputs <- reactive({
        list_names <- c()
        for(x in 1:length(bank_list())){
            list_names[[x]] <- paste(bank_list()[x])
        }
        return(list_names)
    })
    
    # Densiometer input values
    bank_values <- reactive({
        list_values <- c()
        for(x in 1:length(bank_list())){
            list_values[[x]] <- input[[paste(bank_list()[[x]])]]
        }
        return(list_values)
    })
    
    # calculated shade percentage
    bank_mean <- eventReactive(bank_values(),{
        round((Reduce("+", bank_values()) / (input$select_bank)),2)
    })
    
    # Show user calculated percent value
    output$bank_text <- renderUI ({
        h3(HTML(paste0("<b>Bankful Width (m): ", bank_mean(), "</b>")))
        
    })
    
    # used for debugging model
    # df <- reactive({
    #     df <- tibble(
    #         user_lat = as.numeric(input$lat),
    #         user_lon = as.numeric(input$lon),
    #         user_SubstrateSorting_score = input$user_Substrate,
    #         user_Sinuosity_score = input$user_Sinuosity,
    #         user_UplandRootedPlants_score = input$user_UplandRootedPlants,
    #         user_ChannelDimensions_score = input$user_ChannelDimensions,
    #         user_BankWidthMean = bank_mean(),
    #         user_EPT_taxa = input$user_EPT,
    #         user_Hydrophyte_total = input$user_Hydrophyte,
    #         user_PctShade = densi_shade_dec()
    #     )
    # })
    
    # output$help <- renderTable ({
    #     df()
    # })
    # observe({
    #   print(input$user_region)
    # })
    
    # run rf model and output stream classification----
    classification <- eventReactive(input$runmodel, {
        Beta_SDAM_GP(
            user_lat = as.numeric(input$lat),
            user_lon = as.numeric(input$lon),
            user_SubstrateSorting_score = as.numeric(input$user_Substrate),
            user_Sinuosity_score = as.numeric(input$user_Sinuosity),
            user_UplandRootedPlants_score = as.numeric(input$user_UplandRootedPlants),
            user_ChannelDimensions_score = as.numeric(input$user_ChannelDimensions),
            user_BankWidthMean = as.numeric(bank_mean()),
            user_EPT_taxa = as.numeric(input$user_EPT),
            user_Hydrophyte_total = as.numeric(input$user_Hydrophyte),
            user_PctShade = as.numeric(densi_shade_dec()),
            var_input_reg = input$user_region)
    })
    
    
    output$class_out <- renderUI ({
        h2(HTML(paste0("<b>", classification(), "</b>")))
    })
    
    
    # error_message----
    
    # REVISIT: attempted to add error messages but with bankfull/densiometer numeric input type, input
    # does not allow values outside range and therefore, won't trigger a modal error condition
    
    # Densiometer recording number outside range 
    # observeEvent(input$select, {
    #     if (input$select < 3){
    #         show_alert(
    #             title = "Error!",
    #             text = "The number of densiometer recordings should be between 1-12.  Please enter a number in this range.",
    #             type = "error"
    #         )
    #     }
    # })
    # Densiometer recording number outside range
    # observe({
    #     if (input$select < 4){
    #         showModal(
    #             modalDialog("The number of bankfull recordings should be between 1-3.  Please enter a number in this range."),
    #             footer= modalButton("OK"),
    #             easyClose = FALSE
    #         )
    #     }
    # })
    # # Densiometer recording number outside range 
    # observeEvent(input$bank_select, {
    #     if (input$bank_select < 1 | input$bank_select > 3){
    #         show_alert(
    #             title = "Error!",
    #             text = "The number of bankfull recordings should be between 1-3.  Please enter a number in this range.",
    #             type = "error"
    #         )
    #     }
    # })
    
    # Conditions in STEP 3
    observeEvent(input$surfflow, {
        print(input$surfflow)
        if (!is.na(input$surfflow)){
            if ((input$surfflow  < 0) | (input$surfflow  > 100) ){
                showModal(
                    modalDialog(
                        "Percent of reach with surface flow must be between 0 and 100 (inclusive)",
                        footer= modalButton("OK"),
                        easyClose = FALSE
                    )
                )
                updateNumericInput(
                    session,
                    "surfflow",
                    value = 0
                )
            }
        }
    }
    )
    
    observeEvent(input$subflow, {
        if (!is.na(input$subflow)){
            if (input$subflow < 0 | input$subflow > 100){
                showModal(
                    modalDialog(
                        "Percent of reach with surface and subsurface flow must be between 0 and 100 (inclusive)",
                        footer= modalButton("OK"),
                        easyclose = FALSE
                    )
                )
                updateNumericInput(
                    session,
                    "subflow",
                    value = 0
                )
            }
        }
    }
    )
    
    observeEvent(input$subflow, {
        if(!is.na(input$subflow)){
            if (input$subflow < input$surfflow ){
                showModal(
                    modalDialog(
                        "Percent of reach with surface and subsurface flow must be greater than or equal to % of reach with surface flow",
                        footer= modalButton("OK"),
                        easyclose = FALSE
                    )
                )
                updateNumericInput(
                    session,
                    "subflow",
                    value = 0
                )
            }
        }
    }
    )
    
    observeEvent(input$pool, {
        if (!is.na(input$surfflow)){
            if (input$surfflow == 100){
                if ((input$pool != 0) | (!is.null(input$pool))  ) {
                    showModal(
                        modalDialog(
                            "Number of isolated pools must be zero or blank if % of reach with surface flow is 100",
                            footer= modalButton("OK"),
                            easyclose = FALSE
                        )
                    )
                    updateNumericInput(
                        session,
                        "pool",
                        value = 0
                    )
                }
            }
        }
    }
    )
    
  
    # Report Tab--------------------------------------------------------------
    
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
    # retroactively added photos; naming convention broken
    fig6_1 <- reactive({gsub("\\\\", "/", input$inv4$datapath)})
    fig7_1 <- reactive({gsub("\\\\", "/", input$inv5$datapath)})
    fig8_1 <- reactive({gsub("\\\\", "/", input$inv6$datapath)})
    
    # Hydrophyte photos
    fig9 <- reactive({gsub("\\\\", "/", input$hydro1$datapath)})
    fig10 <- reactive({gsub("\\\\", "/", input$hydro2$datapath)})
    fig11 <- reactive({gsub("\\\\", "/", input$hydro3$datapath)})
    # retroactively added photos; naming convention broken
    fig9_1 <- reactive({gsub("\\\\", "/", input$hydro4$datapath)})
    fig10_1 <- reactive({gsub("\\\\", "/", input$hydro5$datapath)})
    fig11_1 <- reactive({gsub("\\\\", "/", input$hydro6$datapath)})
    
    # Fish photos
    fig12 <- reactive({gsub("\\\\", "/", input$sub1$datapath)})
    fig13 <- reactive({gsub("\\\\", "/", input$sub2$datapath)})
    fig14 <- reactive({gsub("\\\\", "/", input$sub3$datapath)})
    
    # Differences in vegetation photos
    fig15 <- reactive({gsub("\\\\", "/", input$veg1$datapath)})
    fig16 <- reactive({gsub("\\\\", "/", input$veg2$datapath)})
    fig17 <- reactive({gsub("\\\\", "/", input$veg3$datapath)})
    
    # Sinuosity photos
    fig18 <- reactive({gsub("\\\\", "/", input$sinu1$datapath)})
    fig19 <- reactive({gsub("\\\\", "/", input$sinu2$datapath)})
    fig20 <- reactive({gsub("\\\\", "/", input$sinu3$datapath)})
    
    # Channel Dimensions
    fig21 <- reactive({gsub("\\\\", "/", input$channel1$datapath)})
    fig22 <- reactive({gsub("\\\\", "/", input$channel2$datapath)})
    fig23 <- reactive({gsub("\\\\", "/", input$channel3$datapath)})
    
    # Supplemental Info photos
    fig24 <- reactive({gsub("\\\\", "/", input$add1$datapath)})
    fig25 <- reactive({gsub("\\\\", "/", input$add2$datapath)})
    fig26 <- reactive({gsub("\\\\", "/", input$add3$datapath)})
    fig27 <- reactive({gsub("\\\\", "/", input$add4$datapath)})
    
    
    
    output$report <- downloadHandler(
        
        filename = glue::glue("Great Plains SDAM Report ({format(Sys.time(), '%B %d, %Y')}).pdf"),
        content = function(file) {
            tryCatch({

                showModal(modalDialog("Please wait while the report is being generated.....", footer=NULL))
                tempReport <- file.path("markdown/report.Rmd")
                file.copy("report.Rmd", tempReport, overwrite = TRUE)

                # Set up parameters to pass to Rmd document
                params <- list(
                    # -------------------Classification
                    class_gp = classification(),
                    gp_region = case_when(
                        input$user_region != "No Region"  ~ input$user_region,
                        input$user_region == "No Region" ~ region_class()$region
                    ),

                    
                    # -------------------General Site Information
                    a = input$project,
                    b = input$assessor,
                    c = input$code,
                    d = input$waterway,
                    e = input$date,
                    bm = case_when(input$radio_weather == 'heavyrain' ~ "Storm/heavy rain",
                                   input$radio_weather == 'steadyrain' ~ "Steady rain",
                                   input$radio_weather == 'intermittentrain' ~ "Intermittent rain",
                                   input$radio_weather == 'snowing' ~ "Snowing",
                                   input$radio_weather == 'cloudy' ~ "Cloudy",
                                   input$radio_weather == 'clearsunny' ~ "Clear/Sunny"),
                    
                    
                    j = input$weather,
                    g = as.numeric(input$lat),
                    h = as.numeric(input$lon),
                    l = plyr::mapvalues(
                        input$check_use,
                        from = c(
                            "urban","agricultural", "Developed open-space (e.g., golf course, parks, lawn grasses)",
                            "forested","othernatural","other"),
                        to = c(
                            "Urban, industrial, or residential", "Agricultural","Developed open-space",
                            "Forested","Other Natural","Other")
                    ) %>% as.character() %>% paste0(collapse = ", "),
                    f = input$boundary,
                    fff = input$actreach,
                    bn = plyr::mapvalues(
                        input$radio_situation,
                        from = c(
                            "flood","stream_modifications", "diversions",
                            "Water discharges","drought","vegetation",
                            "other","none"),
                        to = c(
                            "Recent flood or debris flow","Stream modifications (e.g., channelization)","Diversions",
                            "Water discharges","Drought","Vegetation removal/limitations",
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
                    
                    # ------------------- Site Sketch
                    w = fig5(),
                    
       
                    # ------------------- Biological indicators
                    # EPT Taxa----
                    aqua_inv = input$user_EPT,
                    f6 = fig6(),
                    f6_cap = input$inv1_cap,
                    f7 = fig7(),
                    f7_cap = input$inv2_cap,
                    f8 = fig8(),
                    f8_cap = input$inv3_cap,
                    f6_1 = fig6_1(),
                    f6_1cap = input$inv4_cap,
                    f7_1 = fig7_1(),
                    f7_1cap = input$inv5_cap,
                    f8_1 = fig8_1(),
                    f8_cap = input$inv6_cap,
                    notes_aquainv = input$notes_ept_taxa,
                    
                    
                    # Hydrophytes----
                    hydrophytes = input$user_Hydrophyte,
                    notes_hydrophytes= input$notes_hydrophytes,
                    f9 = fig9(),
                    f9_cap = input$hydro1_cap,
                    f10 = fig10(),
                    f10_cap = input$hydro2_cap,
                    f11 = fig11(),
                    f11_cap = input$hydro3_cap,
                    f9_1 = fig9_1(),
                    f9_1cap = input$hydro4_cap,
                    f10_1 = fig10_1(),
                    f10_1cap = input$hydro5_cap,
                    f11_1 = fig11_1(),
                    f11_1cap = input$hydro6_cap,
                    
                    
                    
                    # Substrate----
                    substrate = case_when(input$user_Substrate == '0' ~ "0 (Poor)",
                                          input$user_Substrate == '0.5' ~ "0.5",
                                          input$user_Substrate == '1' ~ "1 (Weak)",
                                          input$user_Substrate == '1.5' ~ "1.5",
                                          input$user_Substrate == '2' ~ "2 (Moderate)",
                                          input$user_Substrate == '2.5' ~ "2.5",
                                          input$user_Substrate == '3' ~ "3 (Strong)"
                    ),
                    # fish_abundance_checkbox = input$fish_abundance_checkbox,
                    notes_substrate = input$notes_substrate,
                    f12 = fig12(),
                    f12_cap = input$sub1_cap,
                    f13 = fig13(),
                    f13_cap = input$sub2_cap,
                    f14 = fig14(),
                    f14_cap = input$sub3_cap,
                    
                    
                    # Upland Rooted----
                    upland_rooted = case_when(input$user_UplandRootedPlants == '0' ~ "0 (Poor)",
                                              input$user_UplandRootedPlants == '0.5' ~ "0.5",
                                              input$user_UplandRootedPlants == '1' ~ "1 (Weak)",
                                              input$user_UplandRootedPlants == '1.5' ~ "1.5",
                                              input$user_UplandRootedPlants == '2' ~ "2 (Moderate)",
                                              input$user_UplandRootedPlants == '2.5' ~ "2.5",
                                              input$user_UplandRootedPlants == '3' ~ "3 (Strong)"
                    ),
                    upland_checkbox = input$upland_checkbox,
                    notes_rooted = input$notes_rooted,
                    f15 = fig15(),
                    f15_cap = input$veg1_cap,
                    f16 = fig16(),
                    f16_cap = input$veg2_cap,
                    f17 = fig17(),
                    f17_cap = input$veg3_cap,
                    
                    # Bank Width----
                    bankwidth = bank_mean(),
                    
                    # Percent Shade----
                    shade = densi_shade_perc(),
                    
                    
                    # Sinuosity----
                    sinuosity = case_when(input$user_Sinuosity == '0' ~ "0 (Poor)",
                                          input$user_Sinuosity == '0.5' ~ "0.5",
                                          input$user_Sinuosity == '1' ~ "1 (Weak)",
                                          input$user_Sinuosity == '1.5' ~ "1.5",
                                          input$user_Sinuosity == '2' ~ "2 (Moderate)",
                                          input$user_Sinuosity == '2.5' ~ "2.5",
                                          input$user_Sinuosity == '3' ~ "3 (Strong)"
                    ),
                    notes_sinuosity = input$notes_sinuosity,
                    val_length = input$valley_length,
                    f18 = fig18(),
                    f18_cap = input$sinu1_cap,
                    f19 = fig19(),
                    f19_cap = input$sinu2_cap,
                    f20 = fig20(),
                    f20_cap = input$sinu3_cap,
                    
                    # Channel Dimensions----
                    channel_dim = case_when(input$user_Sinuosity == '0' ~ "0 (Poor)",
                                            input$user_Sinuosity == '1.5' ~ "1 (Moderate)",
                                            input$user_Sinuosity == '3' ~ "3 (Strong)"
                    ),
                    notes_channel = input$notes_channel,
                    bank2x = input$bankfull_2x,
                    fpw = input$floodprone,
                    entrenchment = input$entrench,
                    f21 = fig21(),
                    f21_cap = input$channel1_cap,
                    f22 = fig22(),
                    f22_cap = input$channel2_cap,
                    f23 = fig23(),
                    f23_cap = input$channel3_cap,
                    
                    # ------------------- Supplemental Information
                    notes_supplemental_information = input$notes_supplemental_information,
                    f24 = fig24(),
                    f24_cap = input$add1_cap,
                    f25 = fig25(),
                    f25_cap = input$add2_cap,
                    f26 = fig26(),
                    f26_cap = input$add3_cap,
                    f27 = fig27(),
                    f27_cap = input$add4_cap
                    

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
            Please contact Will Saulnier (wsaulnier@eprusa.net) for more details.",
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
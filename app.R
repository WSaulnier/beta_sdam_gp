source('global.R')
# source('sno.R')
# source('nosno.R')
# source('additionalinfo.R')
source('./R/background.R')
# source('R/global_20220628_v2.R')
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
    "))
    ),
    titlePanel(
        div(
            class="jumbotron",
            h2(HTML(
                "Web application for the Beta Streamflow Duration Assessment Method for Great Plains Region (Beta SDAM GP)
        ")
            ),
            h4(HTML("<p>Version <a href=\"https://github.com/SCCWRP/beta_sdam_wm\">1.0.1</a> Release date: July 2022 </p>")),
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
                    fluidRow(column(12, h3("Step 1: Enter coordinates"), 
                                    div('Enter coordinates in decimal degrees to determine if the site is in the study area and if the site is in the Northern or Southern Plains Region'))),
                    
                    fluidRow(
                        tags$head(
                            tags$style(HTML('#reg_button {background-color:#b4bfd1;}'))
                        ),
                        column(
                            4,
                            fluidRow(
                                column(4,numericInput("lat", label = NULL, value =  46.993162)),
                                column(1, h5("Latitude"))
                            ),
                            fluidRow(
                                column(4,numericInput("lon", label = NULL, value = -103.517482)),
                                column(1, h5("Longitude"))
                            )
                            # fluidRow(
                            #     actionButton("reg_button", label="Assess Plains Region") 
                            # )
                        ),
                        column(
                            2,
                            br(),
                            br(),
                            actionButton("reg_button", label="Assess Plains Region")
                        ),
                        column(
                            4,
                            conditionalPanel(
                                condition = "input.reg_button != 0",
                                
                                uiOutput(outputId = "reg_class") %>%
                                    tagAppendAttributes(class = 'border-my-text')
                            )
                            # h2(HTML("<b>Bankful Width</b>")),
                            
                        )
                        # column(
                        #     2,
                        #     ""
                        # )
                        
                        
                    ),
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
                            # div(HTML("<b><i>Aquatic invertebrate indicators</i></b>")),
                            
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
                                    h6("Number of hydrophytic plant species identified from the assessment reach without odd distribution")
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
                                       # numericInput("select", "Choose the Number of Densiometer Readings (max. 12)", min = 1, max = 12, value = 3, step = 1)
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
                                       # sliderInput("select_bank", "Choose the Number of Bankful Measurements (max. 12)", min = 1, max = 3, value = 3)
                                )
                            ),
                            fluidRow(
                                column(
                                    width = 6,
                                    uiOutput("bankUI")
                                ),
                                column(
                                    # h2(HTML("<b>Bankful Width</b>")),
                                    width = 6,
                                    uiOutput(outputId = "bank_text") %>%
                                        tagAppendAttributes(class = 'border-my-text')
                                )
                            ),
                            fluidRow(
                                HTML('<hr style="color: black; height: 3px; background-color: black;">'),
                                tags$head(
                                    tags$style(HTML('#runmodel{background-color:#b4bfd1;}'))
                                ),
                                column(
                                    6,
                                    actionButton("runmodel", "Run Model")
                                ),
                                column(
                                    6,
                                    conditionalPanel(
                                        condition = "input.runmodel != 0",
                                        uiOutput("class_out") %>%
                                            tagAppendAttributes(class = 'border-my-class')
                                    )
                                    
                                    # shinycustomloader::withLoader(uiOutput('final_class'))
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
                        
                        # the condition parameter is a JS statement which should return a boolean to decide whether to display the panel or not
                        #condition = "document.getElementById('final_class') !== null && document.getElementById('final_class').innerText.toLowerCase().includes('this reach is classified as')",
                        condition = "output.class_out",
                        #"(input.paramchoice == 'sno') || (input.paramchoice == 'nosno')",
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
                                "Intermitten Rain" = 'intermittenrain',
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
                                "Developed open-space " = 'openspace',
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
                                "Discharges" = 'discharges',
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
    region_class <- reactive({
        point_region(
            user_lat = input$lat,
            user_lon = input$lon
        )
    })
    # region_class <- eventReactive(input$reg_button, {
    #   point_region(
    #     user_lat = input$lat,
    #     user_lon = input$lon
    #   )
    # })
    
    
    
    output$reg_class <- renderUI ({
        h2(HTML(paste0("<b>Great Plains Region: <br>", region_class(), "</b>")))
    })
    
    
    
    # percent shade calculation -----
    # dynamic UI output for length variable 1:12 for densiometer recordings
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
    
    # Densiometer input names
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
    
    # dynamic UI output for length variable 1:3 for bankfull width recordings
    output$bankUI <- renderUI({
        lapply(
            X = 1:input$select_bank,
            FUN = function(i) {
                numericInput(inputId = paste0("bank", i),
                             label = paste0("Bankfull Measurement ", i), 
                             value = 0)
                # sliderInput(inputId = paste0("bank", i), label = i, min = 0, max = 17, value = i)
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
    
    # Densiometer input names
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
    df <- reactive({
        df <- tibble(
            user_lat = as.numeric(input$lat),
            user_lon = as.numeric(input$lon),
            user_SubstrateSorting_score = input$user_Substrate,
            user_Sinuosity_score = input$user_Sinuosity,
            user_UplandRootedPlants_score = input$user_UplandRootedPlants,
            user_ChannelDimensions_score = input$user_ChannelDimensions,
            user_BankWidthMean = bank_mean(),
            user_EPT_taxa = input$user_EPT,
            user_Hydrophyte_total = input$user_Hydrophyte,
            user_PctShade = densi_shade_dec()
        )
    })
    
    output$help <- renderTable ({
        df()
    })
    
    
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
            user_PctShade = as.numeric(densi_shade_dec())
        )
    })
    
    
    output$class_out <- renderUI ({
        h2(HTML(paste0("<b>", classification(), "</b>")))
    })
    
    
    # error_message----
    # print("session$userData$class")
    # print(is.character(session$userData$class))
    # # Conditions in STEP 2
    # observeEvent(input$user_mayfly_abundance, {
    #     if (!is.na( input$user_mayfly_abundance) ){
    #         if (input$user_mayfly_abundance > input$user_TotalAbundance){
    #             showModal(
    #                 modalDialog(
    #                     "Total abundance of mayflies must be less than total abundance of aquatic macroinvertebrates.", 
    #                     footer= modalButton("OK"),
    #                     easyClose = FALSE
    #                 )
    #             )
    #             updateNumericInput(
    #                 session,
    #                 "user_mayfly_abundance",
    #                 value = 0
    #             )
    #         }
    #     }
    # }
    # )
    # observeEvent(input$user_perennial_abundance, {
    #     if (!is.na(input$user_perennial_abundance)){
    #         if (input$user_mayfly_abundance > input$user_TotalAbundance){
    #             showModal(
    #                 modalDialog(
    #                     "Total abundance of mayflies must be less than total abundance of aquatic macroinvertebrates.", 
    #                     footer= modalButton("OK"),
    #                     easyClose = FALSE
    #                 )
    #             )
    #             updateNumericInput(
    #                 session,
    #                 "user_mayfly_abundance",
    #                 value = 0
    #             )
    #         } else if (
    #             (as.numeric(input$user_mayfly_abundance) + as.numeric(input$user_perennial_abundance)) > as.numeric(input$user_TotalAbundance)
    #         ) {
    #             showModal(
    #                 modalDialog(
    #                     "Total abundance of mayflies PLUS total abundance of perennial indicator families must be less than or equal to total abundance of aquatic macroinvertebrates", 
    #                     footer= modalButton("OK"),
    #                     easyClose = FALSE
    #                 )
    #             )
    #             updateNumericInput(
    #                 session,
    #                 "user_perennial_abundance",
    #                 value = 0
    #             )
    #         }
    #     }
    # }
    # )
    # 
    # observeEvent(input$user_perennial_taxa, {
    #     if (!is.na(input$user_perennial_taxa)){
    #         if (input$user_perennial_taxa > input$user_perennial_abundance){
    #             showModal(
    #                 modalDialog(
    #                     "Total abundance of perennial indicator families must be greater than or equal to the total number of perennial indicator families", 
    #                     footer= modalButton("OK"),
    #                     easyClose = FALSE
    #                 )
    #             )
    #             updateNumericInput(
    #                 session,
    #                 "user_perennial_taxa",
    #                 value = 0
    #             )
    #         }
    #     }
    # }
    # )
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
    
    # # observeEvent(input$snobutton, {
    # #   if ((!is.na(input$lon)) && (input$lon > 0)){
    # #     showModal(
    # #       modalDialog(
    # #         "Longitude value must be negative",
    # #         footer= modalButton("OK"),
    # #         easyclose = FALSE
    # #       )
    # #     )
    # #     updateNumericInput(
    # #       session,
    # #       "lon",
    # #       value = 0
    # #     )
    # #   }
    # # }
    # # )
    # 
    # sno <- eventReactive(
    #     input$snobutton, 
    #     {
    #         snowdom(input$lat, input$lon)
    #         
    #     }
    # )
    # 
    # 
    # # paramsui = params ui, ui that displays more inputs to grab more parameters
    # output$snomsg <- renderUI({
    #     
    #     sno <- sno()
    #     all_msg <- qdapRegex::ex_between(sno$msg, "<p>", "</p>")[[1]]
    #     session$userData$snow_or_no <- qdapRegex::ex_between(all_msg[1], "<strong>", "</strong>")[[1]]
    #     session$userData$snow_persistence <- all_msg[2]
    #     session$userData$oct_precip <-  all_msg[3]
    #     session$userData$may_precip <-  all_msg[4]
    #     session$userData$mean_temp <-  all_msg[5]
    #     
    #     
    #     
    #     
    #     if (sno$canrun) {
    #         fluidRow(
    #             column(
    #                 12,
    #                 fluidRow(
    #                     column(12, h4(HTML(glue::glue('<p>{sno$msg}</p>'))))
    #                 ),
    #                 fluidRow(
    #                     column(
    #                         12,
    #                         radioButtons(
    #                             "paramchoice", 
    #                             h4(HTML("Step 2: Select Model")),
    #                             c(
    #                                 "Snow Influenced" = 'sno',
    #                                 "Non Snow Influenced" = 'nosno'
    #                             ),
    #                             selected = character(0),
    #                             inline = T
    #                         )
    #                     )
    #                 )
    #             )
    #         )
    #     } else {
    #         fluidRow(
    #             column(
    #                 12,
    #                 fluidRow(
    #                     column(12, h4(HTML(glue::glue('<p>{sno$msg}</p><hr>'))))
    #                 )
    #             )
    #         )
    #     }
    # })
    # 
    # 
    # output$params <- renderUI({
    #     if (!is.null(input$paramchoice)) {
    #         if (input$paramchoice == 'sno') {
    #             return(snoparams_ui)
    #         } else {
    #             return(nosnoparams_ui)
    #         }
    #     } else {
    #         return('')
    #     }
    # })
    # 
    
    # 
    # 
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
                # print("fig6")
                # print(fig6())
                # print("input$algae_streambed")
                # print(input$algae_streambed)
                # Set up parameters to pass to Rmd document
                params <- list(
                    # -------------------Classification
                    class_gp = classification(),
                    gp_region = region_class(),
                    # class_gp_msg = session$userData$classmsg,
                    
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
                    # snow_or_no = ifelse(
                    #     is.null(session$userData$snow_or_no),
                    #     "Data was not entered",
                    #     session$userData$snow_or_no
                    # ),
                    # snow_persistence = ifelse(
                    #     is.null(session$userData$snow_persistence),
                    #     "Data was not entered",
                    #     session$userData$snow_persistence
                    # ),
                    # oct_precip = ifelse(
                    #     is.null(session$userData$oct_precip),
                    #     "Data was not entered",
                    #     session$userData$oct_precip
                    # ),
                    # may_precip = ifelse(
                    #     is.null(session$userData$may_precip),
                    #     "Data was not entered",
                    #     session$userData$may_precip
                    # ),
                    # mean_temp = ifelse(
                    #     is.null(session$userData$mean_temp),
                    #     "Data was not entered",
                    #     session$userData$mean_temp
                    # ),
                    # modelused = ifelse(
                    #     is.null(session$userData$modelused),
                    #     "Data was not entered",
                    #     session$userData$modelused
                    # ),
                    
                    
                    # ------------------- Biological indicators
                    # EPT Taxa----
                    aqua_inv = input$user_EPT,
                    # may_flies = input$user_mayfly_abundance,
                    # indicator_taxa = input$user_perennial_taxa,
                    # indicator_families = input$user_perennial_abundance,
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
                    # ak = input$algae_checkbox,
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
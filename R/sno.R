snoparams_ui <- fluidRow(
  column(
    7,
    h4(HTML("Step 3: Enter required indicator data")),
    div("Enter the data that you have collected for all indicators"),
    h5(HTML("<b>Biological indicators</b>")),
    div(HTML("<b><i>Aquatic invertebrate indicators</i></b>")),
    
    fluidRow(
      column(
        6,
        numericInput("user_TotalAbundance", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Total abundance of aquatic macroinvertebrates")
      )
    ),
    
    fluidRow(
      column(
        6,
        numericInput("user_mayfly_abundance", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Total abundance of mayflies")
      )
    ),
    
    
    
    fluidRow(
      column(
        6,
        numericInput("user_perennial_abundance", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Total abundance of perennial indicator families of aquatic macroinvertebrates")
      )
    ),
    
    
    fluidRow(
      column(
        6,
        numericInput("user_perennial_taxa", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Total number of perennial indicator families of aquatic macroinvertebrates")
      )
    ),
    
    
    fluidRow(
      column(
        12,
        radioButtons(
          "user_fishabund_score2", 
          HTML("<b><i>Fish abundance (other than mosquitofish)</b></i>"),
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
          "fish_abundance_checkbox", 
          "Check if all fish observed are mosquitofish", 
          value = FALSE, 
          width = NULL
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        radioButtons(
          "user_alglivedead_cover_score", 
          HTML("<b><i>Algae cover</i></b>"),
          c(
            "None Detected" = 0,
            "<2%" = 1,
            "2% to 10%" = 5,
            "10% to 40%" = 35,
            "40% and above" = 50
          ),
          inline = T
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        checkboxInput(
          "algae_checkbox", 
          "Check if all observed algae appear to be deposited from an upstream source", 
          value = FALSE, 
          width = NULL
        )
      )
    ),
    
    fluidRow(
      column(
        12,
        radioButtons(
          "user_DifferencesInVegetation_score", 
          HTML("<b><i>Differences in vegetation</i></b>"),
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
    

    h5(HTML("<b>Geomorphological indicators</b>")),
    fluidRow(
      column(
        6,
        numericInput("user_BankWidthMean", 
                     label = HTML("<b><i>Bank width (m.m)</i></b>"), 
                     value = "")
      ),
    ),
    fluidRow(
      column(
        12,
        radioButtons(
          "user_Sinuosity_score", 
          HTML("<b><i>Sinuosity</i></b>"),
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
        6,
        actionButton("runmodel", "Run Model")
      ),
      column(
        6,
        shinycustomloader::withLoader(uiOutput('final_class'))
      ),
    ),
    fluidRow(
      column(
        12,
        br()
      )
    )
  )
)
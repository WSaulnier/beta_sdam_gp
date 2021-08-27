nosnoparams_ui <- fluidRow(
  column(
    7,
    fluidRow(
      column(
        6,
        numericInput("user_mayfly_abundance", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Total Abundance of Mayflies")
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
          "Fish abundance (other than mosquitofish)",
          c(
            "Poor" = 0,
            "Weak" = 1,
            "Moderate" = 2,
            "Strong" = 3
          ),
          inline = T
        )
      )
    ),
    fluidRow(
      column(
        12,
        radioButtons(
          "user_Sinuosity_score", 
          "Sinuosity",
          c(
            "Poor" = 0,
            "Weak" = 1,
            "Moderate" = 2,
            "Strong" = 3
          ),
          inline = T
        )
      )
    ),
    fluidRow(
      column(
        6,
        numericInput("user_BankWidthMean", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Bank width (m)")
      )
    ),
    fluidRow(
      column(
        12,
        actionButton('runmodel', 'Run Model')
      )
    )
  ),
  column(5, withLoader(uiOutput('final_class')))
)
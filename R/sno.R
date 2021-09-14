snoparams_ui <- fluidRow(
  column(
    7,
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
          "user_alglivedead_cover_score", 
          "Algae cover",
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
        6,
        numericInput("user_BankWidthMean", label = NULL, value = 0, min = 0, step = 1)
      ),
      column(
        6,
        h6("Bank width (m)")
      )
    )
  )
)
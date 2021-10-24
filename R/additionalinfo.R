addinfo <- fluidRow(
  column(10,
         tagList(
           tags$p(HTML("For additional information, please refer to the user manual developed 
                       for the Beta Streamflow Duration Assessment Method for the Western Mountains. 
                       Information about this method can be found on the 
                       <a
                       href=\"
                       https://www.epa.gov/streamflow-duration-assessment/beta-streamflow-duration-assessment-method-western-mountains\">
                       Environmental Protection Agency's Streamflow Duration Assessment Methods 
                       for the Western Mountains homepage.
                       </a>")
            ),
           
           tags$p(HTML("The user manual, training material, and other resources may be accessed from the 
                       <a href =\"https://betasdamwm-sccwrp.hub.arcgis.com/\">
                       SDAM WM Training Website
                       </a>.")),
           
           tags$p("Identification of aquatic invertebrates:"),
           tags$ul(
             tags$li(tags$p(HTML(
             "<a href =\"https://xerces.org/publications/id-monitoring/macroinvertebrate-indicators-of-streamflow\">
                 The Xerces Society
              </a>"))),
             tags$li(tags$p(HTML(
             "<a href =\"https://www.macroinvertebrates.org/\">
                 Macroinvertebrates.org
              </a>"))),
             tags$li(tags$p(HTML("
              <a href =\"https://www.safit.org/\">
                 The Southwest Association of Freshwater Invertebrate Taxonomists
              </a>"))),
             tags$li(tags$p(HTML(
             "<a href =\"https://freshwater-science.org/\">
                 The Society for Freshwater Scientists
             </a>")))
           ),
           
           tags$p("Identification of riparian plants:"),
           tags$ul(
             tags$li(tags$p(HTML(
               "<a href =\"https://wetland-plants.usace.army.mil/nwpl_static/v34/home/home.html\">
                 U.S. Army Corps of Engineers National Wetland Plant Lists
              </a>"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://swbiodiversity.org/seinet/index.php\">
                 SEINet
              </a> (Arizona and New Mexico)"))),
             tags$li(tags$p(HTML("
              <a href =\"https://www.calflora.org/\">
                 Calflora
              </a>(California)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://calscape.org/\">
                 California Native Plant Society
             </a>(California)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://aznps.com/floras/#:~:text=Arizona%20Flora,Mohave%2C%20and%20Great%20Basin%20Deserts.\">
                 Arizona Native Plant Society
             </a>(Arizona)"))),
             tags$li(tags$p(HTML(
               "<a href =\"http://rmh.uwyo.edu/data/search.php\">
                 Rocky Mountain Herbarium
             </a>(Montana, Wyoming, Colorado, Utah, Arizona, and New Mexico)")))
           ),
           
           tags$p("Identification of amphibians and reptiles:"),
           tags$ul(
             tags$li(tags$p(HTML(
               "<a href =\"http://www.californiaherps.com/\">
                 California Herps
              </a>"))),
           ),
           
           tags$p("Bankfull indicators:"),
           tags$ul(
             tags$li(tags$p(HTML(
               "<a href =\"https://www.fs.fed.us/biology/nsaec/assets/BankfullStageWestern/BankfullStageWesternUS1995.html\">
                 U.S. Forest Service National Stream and Aquatic Ecology Center
              </a>"))),
             
           ),
           tags$p("For additional support with this website, please contact Dr. Raphael Mazor (raphaelm@sccwrp.org) 
                  at the Southern California Coastal Water Research Project.")
         )
  )
)
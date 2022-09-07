addinfo <- fluidRow(
  column(10,
         tagList(
           br(),
           tags$p(HTML("For additional information, please refer to the user manual developed 
                       for the Beta Streamflow Duration Assessment Method for the Great Plains. 
                       Information about this method can be found on the 
                       <a
                       href=\"
                       https://www.epa.gov/streamflow-duration-assessment/streamflow-duration-assessment-method-great-plains\">
                       Environmental Protection Agency's Beta Streamflow Duration Assessment Methods 
                       for the Great Plains website.
                       </a> and the user manual, training material, and other resources may be accessed from the 
                       <a
                       href=\"
                       https://sdam-for-great-plains-eprusa.hub.arcgis.com/\">
                       SDAM GP Training Hub.")
            ),
           
           tags$p("Identification of aquatic invertebrates:"),
           tags$ul(
             tags$li(tags$p(HTML(
             "<a href =\"https://www.macroinvertebrates.org/\">
                 Macroinvertebrates.org
              </a>"))),
             tags$li(tags$p(HTML(
             "<a href =\"https://www.waterbugkey.vcsu.edu/index.htm\">
                 Digital Key to Aquatic Insects of North Dakota
              </a>"))),
             tags$li(tags$p(HTML("
              <a href =\"https://dep.wv.gov/WWE/getinvolved/sos/Pages/UMW.aspx\">
                 Guide to Aquatic Invertebrates of the Upper Midwest
              </a>"))),
             tags$li(tags$p(HTML("
              <a href =\"https://sciencebase.usgs.gov/naamdrc/\">
                 North America Macroinvertebrate Digital Reference Collection
              </a>"))),
             tags$li(tags$p(HTML("
              <a href =\"https://freshwater-science.org/\">
                 The Society for Freshwater Scientists
              </a>"))),
             tags$li(tags$p(HTML("
              <a href =\"https://www.epa.gov/sites/default/files/2015-10/documents/macroinvertebrate_field_guide.pdf\">
                 Macroinvertebrate Indicators of Streamflow Duration OR, WA, & ID
              </a>"))),
             tags$li(tags$p(HTML(
             "<a href =\"http://cfb.unh.edu/StreamKey/html/index.html\">
                 UNH Center for Freshwater Biology: An Image-based key to stream insects
             </a>")))
           ),
           
           tags$p("Identification of riparian plants:"),
           tags$ul(
             tags$li(tags$p(HTML(
               "<a href =\"https://wetland-plants.usace.army.mil/nwpl_static/v34/home/home.html\">
                 U.S. Army Corps of Engineers National Wetland Plant Lists
              </a>"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://midwestherbaria.org/portal/index.php\">
                 Consortium of Midwest Herbaria
              </a> (IL, MI, MN, and WI)"))),
             tags$li(tags$p(HTML("
              <a href =\"https://www.wildflower.org/collections/\">
                 Lady Bird Johnson Wildflower Center
              </a>(Continental U.S.)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://www.kswildflower.org/\">
                 Kansas Wildflowers and Grasses
             </a>(KS)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://www.minnesotawildflowers.info/\">
                 Minnesota Wildflowers
             </a>(MN)"))),
             tags$li(tags$p(HTML(
               "<a href =\"http://rmh.uwyo.edu/data/search.php\">
                 Rocky Mountain Herbarium
             </a>(Incl. MT, WY, CO, and NM)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://cnhp.colostate.edu/cwic/library/field-guides/\">
                 Colorado Wetland Field Guides
             </a>(CO)"))),
             tags$li(tags$p(HTML(
               "<a href =\"https://www.austintexas.gov/sites/default/files/files/Watershed/blog/creekside/WetlandGuideByFamily_WEB.pdf\">
                 Central Texas Wetland Plants
             </a>(TX)")))
           ),

           tags$p("Bankfull indicators:"),
           tags$ul(
             tags$li(tags$p(HTML(
               "<a href =\"https://www.fs.usda.gov/biology/nsaec/products-videoswebinars.html\">
                 U.S. Forest Service National Stream and Aquatic Ecology Center
              </a>"))),
             
           ),
           tags$p(HTML(
             "R code used to develop this application is available here: 
             <a href =\"https://github.com/WSaulnier/beta_sdam_gp\" 
             > https://github.com/WSaulnier/beta_sdam_gp </a>"
             )
            ),
           tags$p("For additional support with this website, please contact Will Saulnier (wsaulnier@eprusa.net) 
                  at Ecosystem Planning and Restoration.")
         )
  )
)
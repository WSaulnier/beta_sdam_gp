bkgrnd <- fluidRow(
  column(10,
    tagList(
      tags$p(HTML("This is a draft tool to calculate the Beta Streamflow Duration Assessment Method (SDAM) developed for the Western Mountains region. 
             Do not use for regulatory purposes without prior consulting with the EPA product delivery team. For more information, consult the 
             <a href=\"https://www.epa.gov/streamflow-duration-assessment\">Environmental Protection Agency's Streamflow Duration Assessment Methods homepage.</a>")),
      tags$p(HTML("Streams may exhibit a diverse range of hydrologic regimes that strongly influence physical, chemical, and 
             biological characteristics of streams and their adjacent riparian areas. 
             Such hydrologic information supports many management decisions. 
             One important aspect of hydrologic regime is streamflow duration—the length of time that a stream supports sustained surface flow. 
             However, requisite hydrologic data to determine flow duration is unavailable at most reaches nationwide. 
             Although maps, hydrologic models, and other data resources exist 
             (e.g., the <a href=\"https://www.usgs.gov/core-science-systems/ngp/national-hydrography/national-hydrography-dataset?qt-science_support_page_related_con=0#qt-science_support_page_related_con\">
             National Hydrography Dataset
             </a>), 
             they may exclude small headwater streams, and limitations on accuracy and spatial or temporal resolution may reduce their utility for many management applications. 
             Therefore, there is a need for rapid, field-based methods to determine flow duration class at the reach scale in the absence of long-term hydrologic data 
             (e.g., <a href=\"https://www.mdpi.com/2073-4441/12/9/2545\">Fritz et al., 2020</a>)")),
    
      tags$p("For the purposes of the method presented here, stream reaches are classified into three types based on increasing streamflow duration:"),
      tags$ul(
        tags$li(tags$p("Ephemeral reaches flow only in direct response to precipitation. Water typically flows only during and shortly after large precipitation events, the streambed is always above the water table, and stormwater runoff is the primary source of water.")),
        tags$li(tags$p("Intermittent reaches are channels that contain water for only part of the year, typically during the wet season, where the streambed may be below the water table and/or where the snowmelt from surrounding uplands provides sustained flow. The flow may vary greatly with stormwater runoff.")),
        tags$li(tags$p("Perennial reaches contain water continuously during a year of normal rainfall, often with the streambed located below the water table for most of the year. Groundwater supplies the baseflow for perennial reaches, but flow is also supplemented by stormwater runoff or snowmelt."))
      ),
      tags$img(src="sdamwm.png"),
      tags$p("This online reporting tool allows application of the Beta Streamflow Duration Assessment Method for the Western Mountains (SDAM WM), the EPA’s standard method for the Western Mountains region outside the Pacific Northwest (SDAM PNW, described in Nadeau 2015). The SDAM WM is based on the presence of biological, geomorphological, and climatic indicators that associated with gradients of streamflow duration. "),
      tags$p("The Beta SDAM WM is based on six indicators measured in the field, plus climatic indicators measured using this website. The indicators are:"),
      tags$ul(
        tags$li(
          HTML(
            "<p>Biological indicators:
            <br>
            <ol>
              <li>The abundance and richness of aquatic invertebrates (specifically, the total abundance, the abundance of mayflies, and the abundance and richness of perennial indicator families)</li>
              <li>Algal cover on the streambed</li>
              <li>Fish abundance</li>
              <li>Differences in vegetation between the channel and surrounding uplands</li>
            </ol>
            "
          )
        ),
        tags$li(
          HTML(
            "<p>Geomorphological indicators
            <br>
            <ol>
              <li>Channel width</li>
              <li>Sinuosity</li>
            </ol>
            </p>
            "
          )
        ),
        tags$li(
          HTML(
            "<p>Climatic indicators
            <br>
            <ol>
              <li>Long-term precipitation (specifically, the average precipitation in May and October)</li>
              <li>Long-term maximum annual air temperature</li>
            </ol>
            </p>
            "
          )
        )
      ),
      tags$p("In addition, fish are used as a “single indicator” which can classify a stream as at least intermittent, even if the other indicators suggest an ephemeral classification."),
      
      tags$p("Users may obtain classifications using this website, after which they have the option to generate a report in standardized format."),
      tags$p(
        HTML(
          "This Beta method will be updated as more data are collected. For further information about streamflow duration assessment methods, 
          refer to the <a href=\"https://www.epa.gov/streamflow-duration-assessment\">EPA website</a>."
        )
      ),
      tags$p("For additional support with this website, please contact Dr. Raphael Mazor (raphaelm@sccwrp.org) at the Southern California Coastal Water Research Project.")
      
    )
  )
)
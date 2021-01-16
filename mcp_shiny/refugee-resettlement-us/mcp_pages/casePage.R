# This is the main interactive analysis page

casePage <- tabPanel('A Case Study',
                     column(width=3,
                            selectInput('firstCounty',
                                        label = 'Initial Resettlement Location',
                                        choices = firstCountyLoc),
                     )
)
                         # #A column of width 9 to contain the plots
                         # #Or customize this with whatever fits
                         # column(width=9,
                         #        HTML("<p><strong>These data come from the 2019 American Community Survey 1-Year Estimates available at Census.org.<br>To compare them with additional data, upload your data file from the sidebar menu.</strong></p>"),
                         #        tabsetPanel(type="tabs",
                         #                    
                         #                    # From Alexa's codes: Age Tab
                         #                    tabPanel("Age",
                         #                             fluidRow(
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Age Group By Gender<br>Census Data</h4>'),
                         #                                        plotlyOutput('decadeCensus'))
                         #                               ),
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Age Group By Gender<br>File Data</h4>'),
                         #                                        plotlyOutput('decadeFile'))
                         #                               ),
                         #                               column(12, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Generation By Gender Census Data</h4>'),
                         #                                        plotlyOutput('generationCensus'))
                         #                               )
                         #                               # column(6, 
                         #                               #        tags$div(
                         #                               #          HTML('<h4 class="plotTitle">Generation By Gender<br>File Data</h4>'),
                         #                               #          plotlyOutput('generationFile'))
                         #                               # ),
                         #                             )),
                         #                    
                         #                    # From Alexa's codes: Education Tab
                         #                    tabPanel("Education",
                         #                             fluidRow(
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Educational Attainment<br>Census Data</h4>'),
                         #                                        plotlyOutput('educationCensus'))
                         #                               ),
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Educational Attainment<br>File Data</h4>'),
                         #                                        plotlyOutput('educationFile'))
                         #                               )
                         #                               # ),
                         #                               # column(12, 
                         #                               #        tags$div(
                         #                               #          HTML('<h4 class="plotTitle">Educational Attainment By Race<br>Census Data</h4>'),
                         #                               #          plotlyOutput('educationByRace'))
                         #                               # )
                         #                             )),
                         #                    
                         #                    # From Oluchi's codes: Race Tab
                         #                    tabPanel("Race",
                         #                             fluidRow(
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Race and Ethnicity<br>Census Data</h4>'),
                         #                                        plotlyOutput('raceCensus'))
                         #                               ),
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Race and Ethnicity<br>File Data</h4>'),
                         #                                        plotlyOutput('raceFile'))
                         #                               ),
                         #                               column(12, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Top Languages Spoken at Home<br>Census Data</h4>'),
                         #                                        plotlyOutput('languageCensus'))
                         #                               )
                         #                             )),
                         #                    
                         #                    # From Alexa's codes: Gender Tab
                         #                    tabPanel("Gender",
                         #                             fluidRow(
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Gender Ratio<br>Census Data</h4>'),
                         #                                        plotlyOutput('genderCensus'))
                         #                               ),
                         #                               column(6, 
                         #                                      tags$div(
                         #                                        HTML('<h4 class="plotTitle">Gender Ratio<br>File Data</h4>'),
                         #                                        plotlyOutput('genderFile'))
                         #                               )
                         #                             ))
                         #        )
                         # )
                         
                         # sidebarLayout(
                         #   sidebarPanel(
                         #     # Select Input for location
                         #     selectInput('location', 
                         #                 'Choose a location', 
                         #                 location_choices),
                         #     # File input for user to upload their own file
                         #     #fileInput("age_userfileupload", "Upload Comparison Data"),
                         #     # Download Section: Label and Button
                         #     radioButtons("downloadReportFormat", 
                         #                  "Download Report",
                         #                  choices=list("Excel", "CSV", "PDF")),
                         #     actionButton("downloadReportButton", "Download Report")
                         #   ),
                         #   mainPanel(
                         #     tabsetPanel(type="tabs",
                         #                 tabPanel("Age", 
                         #                          plotOutput("ageOutput")),
                         #                 tabPanel("Education", 
                         #                          plotOutput("educationOutput")),
                         #                 tabPanel("Race", 
                         #                          plotOutput("raceOutput"))
                         #     )
                         #   )
                         # )
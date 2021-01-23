# This is the second interactive analysis page

casePage <- tabPanel('A Case Study',
                     h4(strong('Somali Refugees and the Communities in Which They Live'), align = 'center'),
                     sidebarLayout(
                       sidebarPanel(
                         width=3,
                         # make sidebarPanel autoscroll with mainPanel
                         style = "position:fixed;width:23%;",
                         selectInput('firstCounty',
                                     label = 'Initial Resettlement Location',
                                     choices = firstCountyLoc),
                         selectInput('secondCounty',
                                     label = 'Secondary Migration Location',
                                     choices = secondCountyLoc),
                         radioButtons('year',
                                      label = "Year",
                                      choices = c("2009", "2019"))
                         
                       ),
                       mainPanel(
                         width = 8,
                         tabsetPanel(type = "tabs",
                                     # Race/Ethnicity Comparison tab layout
                                     tabPanel("Race/Ethnicity",
                                              fluidRow(
                                                column(6,
                                                       htmlOutput('raceFirstTitle'), # for plot title based on user input
                                                       plotlyOutput('raceFirstLoc')
                                                ),
                                                column(6,
                                                       htmlOutput('raceSecondTitle'), # for plot title based on user input
                                                       plotlyOutput('raceSecondLoc')
                                                )
                                              )
                                     ),
                                     # Employment Comparison tab layout
                                     tabPanel("Employment Opportunities",
                                              fluidRow(
                                                column(6,
                                                       htmlOutput('emply16FirstTitle'), # for plot title based on user input
                                                       plotlyOutput('emply16FirstLoc')
                                                ),
                                                column(6,
                                                       htmlOutput('emply16SecondTitle'), # for plot title based on user input
                                                       plotlyOutput('emply16SecondLoc')
                                                )
                                              ),
                                              fluidRow(
                                                column(6,
                                                       htmlOutput('emply65FirstTitle'), # for plot title based on user input
                                                       plotlyOutput('emply65FirstLoc')
                                                ),
                                                column(6,
                                                       htmlOutput('emply65SecondTitle'), # for plot title based on user input
                                                       plotlyOutput('emply65SecondLoc')
                                                )
                                              )
                                     ),
                                     # Coethnic Community Comparison tab layout
                                     tabPanel("Coethnic Community",
                                              fluidRow(
                                                h5(em('Initial Resettlement Location'), align = 'left'),
                                                column(3,
                                                       htmlOutput('coethFirstTitle'),
                                                       plotlyOutput('coethFirstLoc')
                                                ),
                                                column(3,
                                                       htmlOutput('africanFirstTitle'),
                                                       plotlyOutput('africanFirstLoc')
                                                ),
                                                column(3,
                                                       htmlOutput('somaliFirstTitle'),
                                                       plotlyOutput('somaliFirstLoc')
                                                )
                                              ),
                                              hr(),
                                              fluidRow(
                                                h5(em('Secondary Migration Location'), align = 'left'),
                                                column(3,
                                                       htmlOutput('coethSecondTitle'),
                                                       plotlyOutput('coethSecondLoc')
                                                ),
                                                column(3,
                                                       htmlOutput('africanSecondTitle'),
                                                       plotlyOutput('africanSecondLoc')
                                                ),
                                                column(3,
                                                       htmlOutput('somaliSecondTitle'),
                                                       plotlyOutput('somaliSecondLoc')
                                                )
                                              )
                                     ),
                                     # Crime Comparison tab layout
                                     tabPanel("Crime",
                                              fluidRow(
                                                column(12,
                                                       plotlyOutput('crimeComp')
                                                )
                                              ),
                                              fluidRow(
                                                column(12,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Incidences of Crime', align = 'center'),
                                                       plotlyOutput('crimeFirstLoc'),
                                                ),
                                                p()
                                              )
                                     )
                         )
                       )
                     )
                     
)
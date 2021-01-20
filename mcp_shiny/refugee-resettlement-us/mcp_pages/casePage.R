# This is the main interactive analysis page

casePage <- tabPanel('A Case Study',
                     h4(strong('Somali Refugees Resettled in the United States'), align = 'center'),
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
                         width = 9,
                         tabsetPanel(type = "tabs",
                                     # Race/Ethnicity Comparison tab layout
                                     tabPanel("Race/Ethnicity",
                                              fluidRow(
                                                column(6,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Race and Ethnicity', align = 'center'),
                                                       plotlyOutput('raceFirstLoc')
                                                ),
                                                column(6,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('Race and Ethnicity', align = 'center'),
                                                       plotlyOutput('raceSecondLoc')
                                                )
                                              )
                                     ),
                                     # Employment Comparison tab layout
                                     tabPanel("Employment Opportunities",
                                              fluidRow(
                                                column(6,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Unemployment Rate', align = 'center'),
                                                       plotlyOutput('emplyFirstLoc')
                                                ),
                                                column(6,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('Unemployment Rate', align = 'center'),
                                                       plotlyOutput('emplySecondLoc')
                                                )
                                              )
                                     ),
                                     # Coethnic Community Comparison tab layout
                                     tabPanel("Coethnic Community",
                                              fluidRow(
                                                column(3,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Foreign-Born Population', align = 'center'),
                                                       plotlyOutput('coethFirstLoc')
                                                ),
                                                column(3,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('African Community', align = 'center'),
                                                       plotlyOutput('africanFirstLoc')
                                                ),
                                                column(3,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Somali Community', align = 'center'),
                                                       plotlyOutput('somaliFirstLoc')
                                                )
                                              ),
                                              fluidRow(
                                                column(3,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('Foreign-Born Population', align = 'center'),
                                                       plotlyOutput('coethSecondLoc')
                                                ),
                                                column(3,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('African Community', align = 'center'),
                                                       plotlyOutput('africanSecondLoc')
                                                ),
                                                column(3,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('Somali Community', align = 'center'),
                                                       plotlyOutput('somaliSecondLoc')
                                                )
                                              )
                                     ),
                                     # Crime Comparison tab layout
                                     tabPanel("Crime",
                                              fluidRow(
                                                column(6,
                                                       h5('Initial Resettlement Location', align = 'center'),
                                                       h5('Incidences of Crime', align = 'center'),
                                                       plotlyOutput('crimeFirstLoc')
                                                ),
                                                column(6,
                                                       h5('Secondary Migration Location', align = 'center'),
                                                       h5('Incidences of Crime', align = 'center'),
                                                       plotlyOutput('crimeSecondLoc')
                                                )
                                              )
                                     )
                         )
                       )
                     )
                     
)
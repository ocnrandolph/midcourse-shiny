# This is the main interactive analysis page

casePage <- tabPanel('A Case Study',
                     h4(strong('Somali Refugees Resettled in the United States'), align = 'center'),
                     column(width=2,
                            selectInput('firstCounty',
                                        label = 'Initial Resettlement Location',
                                        choices = firstCountyLoc),
                            selectInput('secondCounty',
                                        label = 'Secondary Migration Location',
                                        choices = secondCountyLoc),
                            radioButtons('year',
                                         label = "Year",
                                         choices = c("2008", "2018"))
                     ),
                     column(width = 10,
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
                                                   column(6,
                                                          h5('Initial Resettlement Location', align = 'center'),
                                                          h5('Foreign-Born Population', align = 'center'),
                                                          plotlyOutput('coethFirstLoc')
                                                   ),
                                                   column(6,
                                                          h5('Secondary Migration Location', align = 'center'),
                                                          h5('Foreign-Born Population', align = 'center'),
                                                          plotlyOutput('coethSecondLoc')
                                                   ),
                                                   column(6,
                                                          h5('Initial Resettlement Location', align = 'center'),
                                                          h5('Somali Community', align = 'center'),
# change to africanFirstLoc if somali data are unavailable                                                          
                                                          plotlyOutput('somaliFirstLoc')
                                                   ),
                                                   column(6,
                                                          h5('Secondary Migration Location', align = 'center'),
                                                          h5('Somali Community', align = 'center'),
# change to africanSecondLoc if somali data are unavailable
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
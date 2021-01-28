# This is the second interactive analysis page

casePage <- tabPanel('A Case Study',
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
                                      choices = c("2009", "2019")),
                         hr(),
                         p(strong("County & City Legend")),
                         p("Androscoggin County | Lewiston, Maine"),
                         p("Cumberland County | Portland, Maine"),
                         p("Dallas County | Dallas, Texas"),
                         p("DeKalb County | Atlanta, Georgia"),
                         p("Franklin County | Columbus, Ohio"),
                         p("Hennepin County | Minneapolis, Minnesota"),
                         p("King County | Seattle, Washington"),
                         p("Stearns County | St. Cloud, Minnesota")
                       ),
                       mainPanel(
                         width = 8,
                         h4(strong('Somali Refugees and the Communities in Which They Live'), align = 'center'),
                         br(),
                         p(em('How do characteristics of communities differ in ways that could influence adjustment to life in the U.S. for resettled refugees?'),
                           align = 'center'),
                         br(),
                         p(),
                         tabsetPanel(type = "tabs",
                                     # Race/Ethnicity Comparison tab layout
                                     tabPanel("Race/Ethnicity", align = 'center',
                                              fluidRow(
                                                column(6,
                                                       htmlOutput('raceFirstTitle'), # for plot title based on user input
                                                       plotlyOutput('raceFirstLoc')
                                                ),
                                                column(6,
                                                       htmlOutput('raceSecondTitle'), # for plot title based on user input
                                                       plotlyOutput('raceSecondLoc')
                                                )
                                              ),
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
                                                h5(strong('Overall Property Crime and Violent Crimes'), align = 'center'),
                                                h5('Comparison of Selected Locations Based on State and National Crime Rates', align = 'center'),
                                                column(12,
                                                       plotlyOutput('crimeComp')
                                                )
                                              ),
                                              fluidRow(
                                                h5(strong('Detailed Violent Crime Comparison'), align = 'center'),
                                                column(12,
                                                       plotlyOutput('crimeFirstLoc'),
                                                ),
                                                p(
                                                  br(),
                                                  'Note: Prior to 2012, the Department of Justice relied on the following outdated (legacy) definition of rape: "the carnal',
                                                  'knowledge of a female, forcibly and against her will". Modernization of this (revised) defintion now includes',
                                                  'perpetrators and victims of any gender, and include situations where the victim cannot give consent due to',
                                                  'temporary or permanent incapacity. Keep in mind that observed increases in incidents of rape may have more to',
                                                  'do with this expanded definition, not necessarily an actual increase in offenses. For more information,',
                                                  a(href='https://www.justice.gov/archives/opa/blog/updated-definition-rape', 'follow this link'),
                                                  'to the DOJ archives.'
                                                )
                                              )
                                     )
                         )
                       )
                     )
                     
)
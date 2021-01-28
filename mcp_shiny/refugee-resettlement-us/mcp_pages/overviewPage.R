# This is the first interactive analysis page

overviewPage <- tabPanel('An Overview',
                        sidebarLayout(
                          sidebarPanel(
                            width = 3,
                            radioButtons('admissionsData',
                                         label = "View U.S. Refugee Admissions Data:",
                                         choices = c(
                                           "Annual Admissions by Region" = "alladmit",
                                           "Admission Ceilings vs. Actual Admissions" = "comps",
                                           "Top 15 Countries of Origin (2009)" = "top2009",
                                           "Top 15 Countries of Origin (2019)" = "top2019"),
                                         selected = "")
                          ),
                          mainPanel(
                            width = 8,
                            h4(strong('An Overview of Refugee Resettlement in the United States'), align = 'center'),
                            br(),
                            p(em('What are the origins of people who are admitted to the U.S. as refugees?'), align = 'center'),
                            br(),
                            p('Historical trends and origins of refugees resettled in the U.S. since 1975', align = 'center'),
                            fluidRow(plotlyOutput('playersPlots'))
                          )
                        )
)
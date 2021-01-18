# This is the secondary interactive analysis page

playersPage <- tabPanel('Key Players',
                        h4(strong('An Overview of Refugee Resettlement in the United States'), align = 'center'),
                        sidebarLayout(
                          sidebarPanel(
                            radioButtons('admissionsData',
                                         label = "View U.S. Refugee Admissions Data:",
                                         choices = c(
                                           "All Admissions by Year" = "allYear",
                                           "All Admissions by Region" = "allRegion",
                                           "Admission Ceilings vs. Actual Admissions" = "comps",
                                           "Top 10 Countries of Origin (2008)" = "top2008",
                                           "Top 10 Countries of Origin (2018)" = "top2018"),
                                         selected = "")
                          ),
                          mainPanel(
                            fluidRow(h5('Admissions Data Visualizations', align = 'center'),
                                     plotlyOutput('playersPlots')
                            )
                          )
                        )
)
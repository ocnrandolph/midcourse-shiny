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
                            fluidRow(plotlyOutput('playersPlots')),
                            fluidRow(br(),
                                     h4(strong('The Nine Voluntary Agencies (VolAgs) Involved in Refugee Resettlement'), align = 'center'),
                                     HTML('<center><img src="PRM-RPP-Affiliate-Sites-2019.png"></center>'))
                          )
                        )
)
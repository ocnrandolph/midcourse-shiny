# This is the Data Sources page and all of its contents
creditsPage <- tabPanel("Credits",
                        tags$div(class="titlePanel",
                                 tags$h3(strong(class="title",
                                         "Credits"), 
                                         align = "center")
                        ),
                        HTML('<center><img src="NSS-logo.png" height="125 width="125"></center>'),
                        br(),
                        br(),
                        tags$div(class="bodyTextContainer",
                                 tags$h5(strong("About Me")),
                                 tags$p("My name is Oluchi Nwosu Randolph. This web app is my midcourse", 
                                 "project as a member of Nashville Software School's Data Science 4 Cohort.",
                                 "Feel free to check out my Git repo",
                                 a(href='https://github.com/ocnrandolph/midcourse-shiny', 'https://github.com/ocnrandolph/midcourse-shiny'),
                                 "if you'd like more information about this project and my code."),
                                 hr(),
                                 tags$h5(strong("Data Sources")),
                                 tags$p(a(href='https://www.census.gov/programs-surveys/acs', '2008 ACS 3-year estimates'), 'via the R package', a(href='https://walker-data.com/tidycensus/', 'tidycensus')),
                                 tags$p(a(href='https://www.census.gov/programs-surveys/acs', '2018 ACS 5-year estimates'), 'via tidycensus'),
                                 tags$p(a(href='https://crime-data-explorer.fr.cloud.gov/', 'FBI Crime Data Explorer')),
                                 hr(),
                                 tags$h5(strong("Additional Resources"))
                        )
)
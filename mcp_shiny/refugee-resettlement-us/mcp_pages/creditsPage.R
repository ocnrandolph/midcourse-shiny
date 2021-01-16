# This is the Data Sources page and all of its contents
creditsPage <- tabPanel("Credits",
                        tags$div(class="titlePanel",
                                 tags$h1(class="title",
                                         "Credits"
                                 )
                        ),
                        br(),
                        br(),
                        tags$div(class="bodyTextContainer",
                                 tags$h4("About Me"),
                                 tags$p("My name is Oluchi Nwosu Randolph. This web app is my midcourse", 
                                 "project as a member of Nashville Software School's Data Science 4 Cohort.",
                                 "Feel free to check out my Git repo",
                                 a(href='https://github.com/ocnrandolph/midcourse-shiny', 'https://github.com/ocnrandolph/midcourse-shiny'),
                                 "if you'd like more information about this project and my process."),
                                 hr(),
                                 tags$h4("Data Sources"),
                                 tags$p(a(href='https://www.census.gov/programs-surveys/acs', '2008 ACS 5-year estimates'), 'via the R package', a(href='https://walker-data.com/tidycensus/', 'tidycensus')),
                                 tags$p(a(href='https://www.census.gov/programs-surveys/acs', '2018 ACS 5-year estimates'), 'via tidycensus'),
                                 tags$p(a(href='https://crime-data-explorer.fr.cloud.gov/', 'FBI Crime Data Explorer')),
                                 hr(),
                                 tags$h4("Additional Resources")
                        )
)
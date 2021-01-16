# This is the Home page and all of its contents

homePage <- tabPanel('Home',
                     fluidRow(
                       column(5,
                              h3(strong('Integration and Pathways to Belonging:'), 
                                 align = 'center'),
                              h4('Exploring How Location Matters for Refugee Resettlement in the U.S.',
                                 align = 'center'),
                              br(),
                              p("Human migration is a common, yet often controversial phenomenon. Even when a newcomers' legal status is not a",
                                "point of contention, their presence can challenge a range of views on identity, place, and belonging. America",
                                "has been described as a cultural \"melting pot\", but what exactly does this mean? And how do we meaningfully",
                                "examine how individuals and communities experience, promote, and challenge this \"melting\" as it happens?",
                                "Countless books, documentaries, and dissertations have not exhausted all that there is to explore on this topic.",
                                "Therefore, it is unlikely that a single shiny app can do it justice either. What this app can do, however, is",
                                "function as a resource for others who care about these types of questions.", align = 'center'),
                              br(), 
                              strong('Research Questions'), 
                              br(), 
                              "This project reflects one starting point for understanding this phenomenon. I focus on the experiences of a,",
                              "specific group of newcomers, refugee arrivals, to explore two general questions:",
                              br(),
                              br(),
                              em("1. What are the origins of people who are admitted to the U.S. as refugees?"),
                              br(),
                              br(),
                              "This directs our attention to data on who is entering the melting pot, so to speak. Why refugees, you ask? I zero",
                              "in on refugees because U.S. federal policies, funds, and programs evidence a desire to help this population.",
                              "For FY 2021, the federal government budgeted a minimum of", 
                              a(href="https://www.state.gov/reports/report-to-congress-on-proposed-refugee-admissions-for-fy-2021/#ref13", "$814 million dollars"), 
                              "to encourage and assist with integration into life in the U.S., paricularly for refugees",
                              "and other foreign-born individuals seeking \"shelter or aid from disasters, oppression, emergency medical issues",
                              "and other urgent circumstances\"", a(href="https://www.uscis.gov/humanitarian", "USCIS"), 
                              ". Despite the fact that refugee admission ceilings have been at their", 
                              a(href="https://www.migrationpolicy.org/programs/data-hub/charts/us-annual-refugee-resettlement-ceilings-and-number-refugees-admitted-united", "lowest in history"), 
                              "under the Trump administration, as a country, we still spend a large amount of money and effort in this arena.", 
                              "An interest in the wellbeing of refugees is not only consistent with America's values, but also reflects my heart", 
                              "for refugee, immigrant, and marginalized communities."
                       ),
                       column(4,
                              img(src = 'home-collage-edit.png', # add image
                                  height = 486, 
                                  width = 798),
                              p(
                                br(),
                                tags$small('Photo Credits:',
                                           a(href='https://www.flickr.com/photos/14214150@N02/26040247193', 'Turkana County and Kakuma Camp'),
                                           'by Marisol Grandon/UK DFID',
                                           br(),
                                           'All other photos were obtained from',
                                           a(href='https://www.shutterstock.com/discover/10-free-stock-images', 'Shutterstock.com')
                                )
                              )
                       )
                     )
)

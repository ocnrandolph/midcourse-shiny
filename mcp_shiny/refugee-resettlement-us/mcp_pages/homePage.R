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
                                "function as a resource for others who care about these types of questions.", align = 'center', style = "font-size:16px;"),
                              br(), 
                              strong('Research Questions', style = "font-size:16px;"), 
                              br(), 
                              p("This project reflects one starting point for understanding this phenomenon. I focus on the experiences of a",
                              "specific group of newcomers, refugee arrivals, to explore two general questions:",
                              br(),
                              br(),
                              em("1. What are the origins of people who are admitted to the U.S. as refugees?"),
                              br(),
                              em("2. How do characteristics of resettlement communities differ in ways that could influence adjustment to life in the U.S. for refugees?"),
                              br(), style = "font-size:16px;"),
                              br(),
                              p(),
                              strong('Project Goals', style = "font-size:16px;"),
                              br(),
                              p("This shiny app will answer these initial questions. More than that though, I hope to pique your interest in issues",
                                "related to refugee resettlement, immigration, and community-building that leave you wondering how these processes that we",
                                "often take for granted actually work. And I hope to leave you wondering how we can improve on them. Enjoy!", style = "font-size:16px;"),
                              br()
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

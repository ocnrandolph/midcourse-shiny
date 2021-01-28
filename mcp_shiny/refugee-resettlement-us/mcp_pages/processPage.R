# This is the process page

processPage <- tabPanel('The Process',
                        fluidRow(
                          h3(strong('A Quick Introduction to the Resettlement Process'), align = 'center'),
                          column(4),
                          column(4,
                                 p(
                                   br(),
                                   em('The 1951 Refugee Convention defines a refugee as "someone who is unable or unwilling',
                                      "to return to their country of origin owing to a well-founded fear of being persecuted for",
                                      "reasons of race, religion, nationality, membership of a particular social group, or",
                                      'political opinion."'), align = 'center', style = "font-size:16px;")
                          ),
                          column(4),
                        ),
                        fluidRow(
                          column(12,
                                 br(),
                                 HTML('<center><img src="process-image-text.png" height="611.5" width="998.5"></center>'),
                                 br(),
                          ),
                        ),
                        fluidRow(
                          column(7,
                                 h4(strong('The Nine Voluntary Agencies (VolAgs) Involved in Refugee Resettlement'), align = 'center'),
                                 HTML('<center><img src="PRM-RPP-Affiliate-Sites-2019.png" height="687" width="888.75"></center>'),
                                 p(
                                   br(),
                                   tags$small('Credit:',
                                              a(href='https://www.wrapsnet.org/rp-agency-contacts/', 'Refugee Processing Center'),
                                              
                                   ), align = 'center'
                                 )
                          ),
                          column(5,
                                 br(),
                                 h4(strong('The Bottom Line'), align = 'center'),
                                 br(),
                                 p('International bodies (UNHCR), presidential administrations and Congress, and national VolAgs have',
                                   'a say in who, how many, and when refugees are admitted to the U.S., as well as where they will go',
                                   'once resettled here. VolAgs are required to show proof of supporters and affiliates in the community', 
                                   'and get letters of approval from state and local government officials in an effort to verify buy-in',
                                   'at these levels. However, admitted refugees and other members of the communities where they are',
                                   'resettled otherwise have little say in the process.',
                                   br(),
                                   align = 'center', style = "font-size:16px;"),
                                 br(),
                                 p(strong('Although efforts are made to make sure refugees are resettled in locations and communities that',
                                          'are equipped to help them thrive within their first 30-90 days, do these locations also serve these',
                                          'purposes long-term?'), align = 'center', style = "font-size:16px;"),
                                 br(),
                                 p('What can secondary migration patterns tell us about how different locations matter for the economic and',
                                   'social integration of resettled refugees long-term? (Although I use the term secondary migration, here',
                                   "I'm referring to any and all moves to different locations after initial resettlement.) Whereas",
                                   'integration is an early goal, facilitating belonging is key to experiencing the richest outcomes',
                                   'of the refugee resettlement process for individuals and communities affected by it.',
                                   align = 'center', style = "font-size:16px;")
                          )
                        )
)
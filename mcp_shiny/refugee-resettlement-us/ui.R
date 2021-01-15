# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph, from a 
# shiny app template created by Maeva Ralafi

# All libraries are imported in global.R

# Source codes that define the 'Home Page'
# homePage variable is defined here
#source("mcp_pages/homePage.R") # -> homePage

# Source codes that define the 'The Issue' Page
# issuePage variable
#source("mcp_pages/issuePage.R") # -> issuePage

# Source codes that define the 'Key Players' Page
# playersPage variable
#source("mcp_pages/playersPage.R") # -> playersPage

# Source codes that define the 'A Case Study' Page
# casePage variable
#source("mcp_pages/casePage.R") # -> casePage

# Source codes that define the 'The Takeaway' Page
# takeawayPage variable
#source("mcp_pages/takeawayPage.R") # -> takeawayPage

# Source codes that define the 'Credits' Page
# creditsPage variable
#source("mcp_pages/creditsPage.R") # -> creditsPage

# Putting the UI Together
shinyUI(
    # Using Navbar with custom CSS
    navbarPage(title = 'Integration and Pathways to Belonging',
               tabPanel('Home',
                        fluidRow(
                            column(5,
                                   h3('Integration and Pathways to Belonging:', 
                                      align = 'center'),
                                   h4('Exploring How Location Matters for Refugee Resettlement in the U.S.',
                                      align = 'center')
                            ),
                            column(4,
                                   img(src = 'home-collage.png', # add image
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
               ),
               tabPanel('Credits',
                        'Credits'),
               navbarMenu('Explore',
                          tabPanel('The Issue',
                                   'The Issue'),
                          tabPanel('Key Players',
                                   'Key Players'),
                          tabPanel('A Case Study',
                                   'Case Study'),
                          tabPanel('The Takeaway',
                                   'Conclusion')
               )
               
    )
)
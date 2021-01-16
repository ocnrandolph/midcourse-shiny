# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph, from a 
# shiny app template created by Maeva Ralafi

# All libraries are imported in global.R

# Source codes that define the 'Home Page'
# homePage variable is defined here
source("mcp_pages/homePage.R") # -> homePage

# Source codes that define the 'Credits' Page
# creditsPage variable
source("mcp_pages/creditsPage.R") # -> creditsPage

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

# Putting the UI Together
shinyUI(
    # Using Navbar with custom CSS
    navbarPage(title = 'Integration and Pathways to Belonging',
               homePage,
               creditsPage,
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
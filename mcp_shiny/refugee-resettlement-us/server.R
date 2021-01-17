# # Define server logic required to produce desired charts based on user selections

shinyServer(function(input, output) {
  # Race/Ethnicity Comparison output
  # plotly output for first location selection and year selection (stacked bar chart)
  output$raceFirstLoc <- plotly::renderPlotly({
    # 1st filter by location choice
    cleanDataset %>%
      filter(county == input$firstCounty) %>%
      # 2nd filter by year
      filter(year == input$year) %>%
      ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
      geom_col() +
      #scale_fill_manual(values = c('Hisp' = '#DCC5A8',
      #                           'nonHisp' = '#C2B5AE')) +
      #labs(#title = 'Race by Ethnicity',
      #x = NULL, y = 'Population', fill = NULL) +
      scale_y_continuous(limits=c(0, 450000),
                         breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000),
                         labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
  })
  
  # plotly output for second location selection and year selection (stacked bar chart)
  output$raceSecondLoc <- plotly::renderPlotly({
    # 1st filter by location choice
    cleanDataset %>%
      filter(county == input$secondCounty) %>%
      # 2nd filter by year
      filter(year == input$year) %>%
      ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
      geom_col() +
      #scale_fill_manual(values = c('Hisp' = '#DCC5A8',
      #                           'nonHisp' = '#C2B5AE')) +
      #labs(#title = 'Race by Ethnicity',
      #x = NULL, y = 'Population', fill = NULL) +
      scale_y_continuous(limits=c(0, 450000),
                         breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000),
                         labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
  })
  
  # Economic Opportunity Comparison output
  # plotly output for first location and year selection (dumbbell plot)
  output$emplyFirstLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # plotly output for second location and year selection (dumbbell plot)
  output$emplySecondLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # Co-Ethnic Community Comparison output
  # plotly output for first location and year selection (donut chart)
  output$coethFirstLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # plotly output for second location and year selection (donut chart)
  output$coethSecondLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # plotly output for first location and year selection (pie chart)
  #NOTE: Change to africanFirstLoc if Somali population data are not available
  output$somaliFirstLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # plotly output for second location and year selection (pie chart)
  #NOTE: Change to africanSecondLoc if Somali population data are not available
  output$somaliSecondLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # Incidences of Crime Comparison output
  # plotly output for first location and year selection (grouped bar chart)
  output$crimeFirstLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
  
  # plotly output for second location and year selection (grouped bar chart)
  output$crimeSecondLoc <- plotly::renderPlotly({
    cleanDataset %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      ggplot()
  })
})

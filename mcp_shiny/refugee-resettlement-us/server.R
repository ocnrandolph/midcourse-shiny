# # Define server logic required to produce desired charts based on user selections

shinyServer(function(input, output) {

#playersPage Output
  output$playersPlots <- plotly::renderPlotly({
    req(input$admissionsData)
    
    if (input$admissionsData == "allYear") {
      p <- subset_2009_race_data %>% 
        ggplot(aes(x = race, y = estimate, fill = ethnicity)) +
        geom_col()
    }
    else if (input$admissionsData == "allRegion") {
      p <- subset_2009_race_data %>% 
        ggplot(aes(x = race, y = estimate)) +
        geom_line()
    }
    
    p
  })

# casePage Output  
  # Race/Ethnicity Comparison output
  # plotly output for first location selection and year selection (stacked bar chart)
  output$raceFirstLoc <- plotly::renderPlotly({
    # 1st filter by location choice
    fig1 <- race_full %>%
      filter(county == input$firstCounty) %>%
      # 2nd filter by year
      filter(year == input$year) %>%
      ggplot(aes(x = race, y = estimate, fill = ethnicity)) +
      geom_col() +
      #scale_fill_manual(values = c('Hisp' = '#DCC5A8',
      #                           'nonHisp' = '#C2B5AE')) +
      labs(title = 'Race by Ethnicity', x = NULL, y = 'Population', fill = NULL) +
      # scale_y_continuous(limits=c(0, 450000),
      #                    breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000),
      #                    labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
    
    fig1
  })
  
  # plotly output for second location selection and year selection (stacked bar chart)
  output$raceSecondLoc <- plotly::renderPlotly({
    # 1st filter by location choice
    fig2 <- race_full %>%
      filter(county == input$secondCounty) %>%
      # 2nd filter by year
      filter(year == input$year) %>%
      ggplot(aes(x = race, y = estimate, fill = ethnicity)) +
      geom_col() +
      #scale_fill_manual(values = c('Hisp' = '#DCC5A8',
      #                           'nonHisp' = '#C2B5AE')) +
      labs(title = 'Race by Ethnicity', x = NULL, y = 'Population', fill = NULL) +
      # scale_y_continuous(limits=c(0, 450000),
      #                     breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000),
      #                     labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
    
    fig2
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
  # foreign born population vs total population
  # plotly output for first location and year selection (donut chart)
  output$coethFirstLoc <- plotly::renderPlotly({
    fig5 <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>%
      filter(coethnic == 'Total Foreign Born Population' | coethnic == 'Total Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate) %>% 
      add_pie(hole = 0.4)
    
    # generate plot
    fig5
  })
  
  # plotly output for first location and year selection (pie chart)
  # African foreign-born population vs total foreign-born population
  output$africanFirstLoc <- plotly::renderPlotly({
    fig6 <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>%
      filter(coethnic == 'Foreign Born Population - African' | coethnic == 'Total Foreign Born Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    fig6
  })
  
  # plotly output for first location and year selection (donut chart)
  # Somali Ancestry vs Total Ancestry
  output$somaliFirstLoc <- plotly::renderPlotly({
    fig7 <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Somali Ancestry' | coethnic == 'Ancestry Total') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate) %>% 
      add_pie(hole = 0.4)
    
    fig7
  })
  
  # plotly output for second location and year selection (donut chart)
  # foreign born population vs total population
  output$coethSecondLoc <- plotly::renderPlotly({
    fig8 <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Total Foreign Born Population' | coethnic == 'Total Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate) %>% 
      add_pie(hole = 0.4)
    
    # generate plot
    fig8
  })
  
  # plotly output for second location and year selection (pie chart)
  # African foreign-born population vs total foreign-born population
  output$africanSecondLoc <- plotly::renderPlotly({
    fig9 <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Foreign Born Population - African' | coethnic == 'Total Foreign Born Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    fig9
  })
  
  # plotly output for second location and year selection (donut chart)
  # Somali Ancestry vs Total Ancestry
  output$somaliSecondLoc <- plotly::renderPlotly({
    fig10 <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Somali Ancestry' | coethnic == 'Ancestry Total') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate) %>% 
      add_pie(hole = 0.4)
    
    fig10
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

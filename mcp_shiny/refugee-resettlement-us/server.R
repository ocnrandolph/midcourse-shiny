# # Define server logic required to produce desired charts based on user selections

shinyServer(function(input, output) {

#playersPage Output
  
  output$playersPlots <- plotly::renderPlotly({
    req(input$admissionsData)
    
    if (input$admissionsData == "alladmit") {
      ref_fig <- prm_hist_admit %>% 
        filter(Year != 'Total') %>% 
        filter(Region != 'Total') %>% 
        ggplot(aes(x = Year, y = Population, fill = Region)) +
        geom_col() +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45)) + # Rotate x-axis text labels
        scale_y_continuous(labels = label_comma()) +
        scale_fill_manual(values = alladmit_Palette)
        #scale_fill_viridis(discrete = TRUE, option = 'D')
    }
    else if (input$admissionsData == "comps") {
      ref_fig <- admit_vs_ceiling %>% 
        plot_ly(x = ~Year, 
                y = ~Admissions,
                name = 'Actual Admissions',
                type = 'scatter',
                mode = 'lines',
                line = list(color = '#29AF7FFF', width = 4)) %>%
        add_trace(y = ~Ceiling,
                  name = 'Admission Ceiling',
                  line = list(color = '#440154FF', width = 4, dash = 'dash')) %>% 
        layout(xaxis = list(tickmode = 'linear', tickangle = 45),
               yaxis = list(title = 'Refugee Admissions'))
    }
    else if (input$admissionsData == "top2009") {
      ref_fig <- admissions_2009 %>%
        filter(str_detect(Country, 'Total', negate = TRUE)) %>% # filter out country and region totals
        arrange(desc(Admitted)) %>% 
        head(15) %>% # grab top 15 values and countries
        ggplot() +
        geom_col(aes(x = reorder(Country, Admitted), y = Admitted, fill = Country)) +
        scale_color_viridis() +
        theme_minimal() +
        labs(x = NULL, y = 'Refugees Admitted in 2009') +
        scale_fill_manual(values = top09_Palette) +
        coord_flip()
    }
    else if (input$admissionsData == "top2019") {
      ref_fig <- admissions_2019 %>%
        filter(str_detect(Country, 'Total', negate = TRUE)) %>% # filter out country and region totals
        arrange(desc(Admitted)) %>% 
        head(15) %>% # grab top 15 values and countries
        ggplot() +
        geom_col(aes(x = reorder(Country, Admitted), y = Admitted, fill = Country)) +
        scale_color_viridis() +
        theme_minimal() +
        labs(x = NULL, y = 'Refugees Admitted in 2019') +
        scale_fill_manual(values = top19_Palette) +
        coord_flip()
    }
    
    ref_fig
  })

# casePage Output  
  # Race/Ethnicity Comparison output
  # Plot title based on user input
  output$raceFirstTitle <- renderUI({
    state <- race_full %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Racial Composition by Ethnicity (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
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
      labs(title = NULL, x = NULL, y = 'Population', fill = NULL) +
      scale_y_continuous(labels = label_comma()) +
      scale_x_discrete(labels = c('Native American',
                                  'Asian',
                                  'Black',
                                  'Pacific Islander',
                                  'Other',
                                  'Multiracial',
                                  'White')) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
    
    fig1
  })
  
  # Plot title based on user input
  output$raceSecondTitle <- renderUI({
    state <- race_full %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Racial Composition by Ethnicity (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
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
      labs(title = NULL, x = NULL, y = 'Population', fill = NULL) +
      scale_y_continuous(labels = label_comma()) +
      scale_x_discrete(labels = c('Native American',
                                  'Asian',
                                  'Black',
                                  'Pacific Islander',
                                  'Other',
                                  'Multiracial',
                                  'White')) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45)) # Rotate x-axis text labels
    
    fig2
  })
  
  # Economic Opportunity Comparison output
  # plotly output for first location and year selection (dumbbell plot)
  output$emply16FirstTitle <- renderUI({
    state <- employment_full_wide %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Unemployment Rate by Race (", input$year, ")")), align = 'center'))
    str3 <- as.character(h5("Ages 16-64", align = 'center'))
    HTML(paste(str1, str2, str3))
    
  })
  
  output$emply16FirstLoc <- plotly::renderPlotly({
    fig3a <- employment_full_wide %>% 
      filter(age_group == '16 to 64 years') %>%
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>%
      plot_ly(color = I("gray80")) %>%
      add_segments(x = ~Female, xend = ~Male, y = ~race, yend = ~race, showlegend = F) %>% 
      add_markers(x = ~Female, y = ~race, name = 'Women', color = I("pink")) %>% 
      add_markers(x = ~Male, y = ~race, name = 'Men', color = I("blue")) %>% 
      layout(xaxis = list(title = '% Unemployed'))
    
    fig3a
  })
  
  # plotly output for second location and year selection (dumbbell plot)
  output$emply16SecondTitle <- renderUI({
    state <- employment_full_wide %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Unemployment Rate by Race (", input$year, ")")), align = 'center'))
    str3 <- as.character(h5("Ages 16-64", align = 'center'))
    HTML(paste(str1, str2, str3))
    
  })
  
  output$emply16SecondLoc <- plotly::renderPlotly({
    fig4a <- employment_full_wide %>% 
      filter(age_group == '16 to 64 years') %>%
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      plot_ly(color = I("gray80")) %>%
      add_segments(x = ~Female, xend = ~Male, y = ~race, yend = ~race, showlegend = F) %>% 
      add_markers(x = ~Female, y = ~race, name = 'Women', color = I("pink")) %>% 
      add_markers(x = ~Male, y = ~race, name = 'Men', color = I("blue")) %>% 
      layout(xaxis = list(title = '% Unemployed'))
    
    fig4a
  })
  
  output$emply65FirstTitle <- renderUI({
    state <- employment_full_wide %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Unemployment Rate by Race (", input$year, ")")), align = 'center'))
    str3 <- as.character(h5("Ages 65 and up", align = 'center'))
    HTML(paste(str1, str2, str3))
    
  })
  
  output$emply65FirstLoc <- plotly::renderPlotly({
    fig3b <- employment_full_wide %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      filter(age_group == '65 years and over') %>%
      plot_ly(color = I("gray80")) %>%
      add_segments(x = ~Female, xend = ~Male, y = ~race, yend = ~race, showlegend = F) %>% 
      add_markers(x = ~Female, y = ~race, name = 'Women', color = I("pink")) %>% 
      add_markers(x = ~Male, y = ~race, name = 'Men', color = I("blue")) %>% 
      layout(xaxis = list(title = '% Unemployed'))
    
    fig3b
  })
  
  # plotly output for second location and year selection (dumbbell plot)
  output$emply65SecondTitle <- renderUI({
    state <- employment_full_wide %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Unemployment Rate by Race (", input$year, ")")), align = 'center'))
    str3 <- as.character(h5("Ages 65 and up", align = 'center'))
    HTML(paste(str1, str2, str3))
    
  })
  
  output$emply65SecondLoc <- plotly::renderPlotly({
    fig4b <- employment_full_wide %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(age_group == '65 years and over') %>%
      plot_ly(color = I("gray80")) %>%
      add_segments(x = ~Female, xend = ~Male, y = ~race, yend = ~race, showlegend = F) %>% 
      add_markers(x = ~Female, y = ~race, name = 'Women', color = I("pink")) %>% 
      add_markers(x = ~Male, y = ~race, name = 'Men', color = I("blue")) %>% 
      layout(xaxis = list(title = '% Unemployed'))
    
    fig4b
  })
  
  # Co-Ethnic Community Comparison output
  # foreign born population vs total population
  # plotly output for first location and year selection (pie chart)
  output$coethFirstTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Foreign Born Population (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
  output$coethFirstLoc <- plotly::renderPlotly({
    fig5 <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>%
      filter(coethnic == 'Total Foreign Born Population' | coethnic == 'Total Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    # generate plot
    fig5
  })
  
  # plotly output for first location and year selection (pie chart)
  # African foreign-born population vs total foreign-born population
  output$africanFirstTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Foreign Born Africans (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
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
  
  # plotly output for first location and year selection (pie chart)
  # Somali Ancestry vs Total Ancestry
  output$somaliFirstTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$firstCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Somali Population (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
  output$somaliFirstLoc <- plotly::renderPlotly({
    fig7 <- coethnic_full %>% 
      filter(county == input$firstCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Somali Ancestry' | coethnic == 'Ancestry Total') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    fig7
  })
  
  # plotly output for second location and year selection (pie chart)
  # foreign born population vs total population
  output$coethSecondTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Foreign Born Population (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
  output$coethSecondLoc <- plotly::renderPlotly({
    fig8 <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Total Foreign Born Population' | coethnic == 'Total Population') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    # generate plot
    fig8
  })
  
  # plotly output for second location and year selection (pie chart)
  # African foreign-born population vs total foreign-born population
  output$africanSecondTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Foreign Born Africans (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
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
  output$somaliSecondTitle <- renderUI({
    state <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      pull(state)
    
    str1 <- as.character(h5(strong(paste0(input$secondCounty, ", ", state[1])), align = 'center'))
    str2 <- as.character(h5(strong(paste0("Somali Population (", input$year, ")")), align = 'center'))
    HTML(paste(str1, str2))
    
  })
  
  output$somaliSecondLoc <- plotly::renderPlotly({
    fig10 <- coethnic_full %>% 
      filter(county == input$secondCounty) %>% 
      filter(year == input$year) %>% 
      filter(coethnic == 'Somali Ancestry' | coethnic == 'Ancestry Total') %>% 
      plot_ly(labels = ~coethnic,
              values = ~estimate,
              type = 'pie')
    
    fig10
  })
  
  # Incidences of Crime Comparison output
  # plotly output for general property and violent crime in both locations and US + year selection (line plot)
  output$crimeComp <- plotly::renderPlotly({
    fig11 <- crime_full %>% 
      filter(location == 'United States' | 
               county == input$firstCounty |
               county == input$secondCounty) %>% 
      filter(crime == 'Violent Crime' | 
               crime == 'Property Crime') %>% 
      ggplot(aes(x = year, y = rate_per_100K, group = location)) +
      geom_line(aes(color = location)) +
      scale_x_continuous(breaks = c(2009:2019)) +
      scale_y_continuous(labels = label_comma()) +
      facet_grid(rows = 'crime', scales = 'free') +
      theme_minimal()
    
    fig11
  })
  
  # plotly output for comparing detailed violent crime in both locations by year selection (grouped bar chart)
  output$crimeFirstLoc <- plotly::renderPlotly({
    fig12 <- crime_full %>% 
      filter(location == 'United States' | 
               county == input$firstCounty |
               county == input$secondCounty) %>% 
      filter(crime != 'Violent Crime') %>% 
      filter(crime != 'Property Crime') %>% 
      filter(year == input$year) %>% 
      ggplot(aes(x = crime, y = rate_per_100K, fill = location)) +
      geom_bar(position = "dodge", stat = "identity")
    
    fig12
  })
  
})

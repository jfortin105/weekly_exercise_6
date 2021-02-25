library(shiny)
library(tidyverse)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
  selectInput("state",
            "State",
            choices = list("Alabama", "Alaska", "American Samoa", "Arizona", "Arkansas", "California", "Colorado", 
                           "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Guam", "Hawaii", 
                           "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", 
                           "Massachusetts", "Michigan", "Minnesota", "Minor Outlying Islands", "Mississippi", "Missouri", 
                           "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", 
                           "North Carolina", "North Dakota", "Northern Mariana Islands", "Ohio", "Oklahoma", "Oregon", 
                           "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
                           "Texas", "U.S. Virgin Islands", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", 
                           "Wisconsin", "Wyoming"),
            multiple = TRUE),
  submitButton(text = "Load Graph"),
  plotOutput(outputId = "covidcases")
)
server <- function(input, output) {
  output$covidcases <- renderPlot({
    covid19 %>% 
      filter(cases >= 20,
             state == input$state) %>% 
      group_by(state) %>% 
      mutate(min_day = min(date),
             num_days = date - min_day) %>% 
      ggplot(aes(x = num_days, y = cases, color = state)) +
      geom_line() +
      scale_y_log10() + 
      theme(legend.position = "right") +
      labs(title = "Comparing COVID Cases by State",
           subtitle = "",
           y = "Log Cases",
           x = "Number of Days Since 20+ Cases")
  })
}
shinyApp(ui = ui, server = server)
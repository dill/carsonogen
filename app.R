library(shiny)

library(curl)
library(readxl)
library(jsonlite)
library(auk)
sapply(list.files("R/", full.names=TRUE), source)

ui <- fluidPage(
  fluidRow(
    h1("Carson-o-gen"),
    p("Pick a place and time to list to a random eBird checklist."),
    column(3,
      h2("Where and when"),
      numericInput("year", label = "Year", value = 2023),
      selectInput("month", label = "Month", selected = 1, choices=1:12),
      selectInput("day", label = "Day", selected = "1",
                  choices = 1:31),
      selectInput("location", label = "Location", selected = "GB-SCT-FIF",
                  choices = region_codes()),
      actionButton("dobeep", "quack")
    ),
    column(3,
      h1("Checklist"),
      uiOutput("list_credits")
    ),
    column(3,
      h2("Background"),
#      tags$img(src='www/carson.png', alt="A photo of Rachel Carson, manipulated to be wearing headphones. Her jacket has the eBird and xano-canto logos."),
imageOutput("carson"),
      p("This is based on an idea I got from a ",
      a("cool paper", href="https://www.nature.com/articles/s41467-021-26488-1"),
      " by my colleague ",
      a("Cat Morrison", href="https://www.bioss.ac.uk/people/catrionamorrison"),
      " where she and collaborators looked at the declines in avian biodiversity through the lens of acoustics."),
      p("A random eBird checklist is selected from a time/place and bird calls are then served from Xeno-Canto."),
      p("For best results use Firefox on Linux, untested on any other platform :)")
    )
  )
)

server <- function(input, output, session) {

  observeEvent(input$dobeep, {
    # get a random checklist
    re <- get_checklist(input$year, input$month, input$day, input$location)

    # get audio data
    aud <- do.call(rbind, lapply(re$sci_nm, get_quack))

    output$list_credits <- renderUI(
             tags$div(
               make_checklist(re, aud),
               make_cacophony(aud),
               id = "duck"
            ))
  })

  output$carson <- renderImage({
    list(src = "www/carson.png",
         contentType = 'image/png',
         width = 200,
         height = 294,
         alt="A photo of Rachel Carson, manipulated to be wearing headphones. Her jacket has the eBird and xano-canto logos.")
  }, deleteFile = FALSE)
}
shinyApp(ui, server)

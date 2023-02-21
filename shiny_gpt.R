
#Shiny ChatGPT | Jose Fernandez | Feb 2023


#Load Libraries
library(shiny)
library(shinydashboard)
library(openai)
library(gptchatteR)
library(DT)
library(tidyverse)
library(shinythemes)

#gptChatter library requirements
chatter.auth("xxxxxxxxxxxxxxx")
chatter.create(max_tokens = 1000)

#UI
ui <- tagList(
  
  dashboardPage(
  
  dashboardHeader(
    
    title = "GPT-3 Chat App",
    tags$li(class = "dropdown", actionLink("info", icon("info-circle")))
                  
    ),
  
  dashboardSidebar(
    
    width = 300,
    
    #text input to type the prompt
    div(style = "position: fixed",
    fluidRow(column(width = 12,
    textAreaInput("question", "", placeholder = "add your prompt here", rows=20)
    )),
    
    #app buttons
    fluidRow(
      
    #submit prompt  
    column(width = 1,
    actionButton("addbtn", icon("paper-plane"), NULL, class = "btn-primary", title = "Submit prompt to GPT"),
    
    #Remove columns from table
    column(width = 1, style = "padding-left: 6px",
    actionButton("removebtn", icon("trash-alt"), NULL, class = "btn-danger", title = "Remove selected rows from the table", style = "margin-left: 10px;")
          )
        )
       )
    )
    
  ),
  
  dashboardBody(
    
    #fixed dashboard
    tags$script(HTML("$('body').addClass('fixed');")),
    
    #wrapped text in table
    tags$style("#table { white-space:pre; }"),
    
    #container for table
    div(
    style = "height: 10000px; overflow-y: scroll;",
    column(width = 2),
    column(width = 8, DTOutput("table")),
    column(width = 2)
    )
    
  )
  
),

#app footer
  tags$footer(HTML(paste("Built by Jose Fernandez", 
                       a(icon("twitter"), href="https://twitter.com/jfernandez__"),
                       a(icon("github"), href="https://github.com/josedv82"),
                       "| © 2023")), 
              align = "right", style = "
              position:sticky;
              bottom:0;
              width:100%;
              height:20px;
              color: white;
              padding-right: 20px;
              background-color: #1A1A1A;")

)

#server
server <- function(input, output, session) {
  
  #info modal
  observeEvent(input$info, {
    showModal(modalDialog(
      title = "ABOUT THIS APP",
      HTML(paste("This application was created using the R package {gptchatteR} and all the model settings are the
      default ones. For more info check the package's ", a("GitHub Repo.", href="https://github.com/isinaltinkaya/gptchatteR"),
                 "<br>", "<br>", "The code for this app can be found here.")),
      easyClose = TRUE
    ))
  })
  
  #create an empty data frame to store the responses
  responses <- data.frame(prompt = character(), response = character(), stringsAsFactors = FALSE)
  
  #observeEvent to get the response from GPT and bind them to a table
  observeEvent(input$addbtn, {
    
    #get the response from GPT-3
    chat <- chatter.chat(input$question, feed = TRUE, return_response = TRUE)
    response <- chat$choices[[1]]
    
    #add the response to the data frame
    responses <<- rbind(responses, data.frame(prompt = paste(icon("user-large"), "<br>",  "<br>", input$question, sep = " "), 
                                              response = paste(icon("robot"), response, sep = " "),
                                              stringsAsFactors = FALSE))
    
    
    #update the table
    output$table <- renderDT({
      datatable(responses, 
                style = "bootstrap",
                escape = FALSE, 
                rownames = FALSE,
                extensions = 'Buttons',
                selection = list(mode = "multiple", target = "row"),
                options = list(
                  pageLength = 100,
                  #columnDefs = list(list(visible=FALSE, targets=c(0))),
                  dom = 'B',
                  buttons = list('copy', 'csv', 'excel', 'pdf', 'print'),
                  
                  initComplete = JS(
                    'function(settings, json) {
                      $(this.api().table().header()).css("background-color", "transparent");
                      $(this.api().table().header()).css("color", "transparent");
                    }'
                  )
                )) %>%
        
        formatStyle("prompt", background = "darkgrey")
        
    })
    
    #reset the textAreaInput to empty after submitting the prompt
    updateTextAreaInput(session, "question", value = "")
  })
  
  #observeEvent to remove selected rows from table
  observeEvent(input$removebtn, {
   
    selected_rows <- input$table_rows_selected
    updated_responses <- responses[-selected_rows, ]
    responses <<- updated_responses
    
    # update the table
    output$table <- renderDT({
      datatable(responses, 
                style = "bootstrap",
                escape = FALSE, 
                rownames = FALSE, 
                extensions = 'Buttons',
                selection = list(mode = "multiple", target = "row"),
                options = list(
                  pageLength = 100,
                  #columnDefs = list(list(visible=FALSE, targets=c(0))),
                  dom = 'B',
                  buttons = list('copy', 'csv', 'excel', 'pdf', 'print'),
                  
                  initComplete = JS(
                    'function(settings, json) {
                      $(this.api().table().header()).css("background-color", "transparent");
                      $(this.api().table().header()).css("color", "transparent");
                    }'
                  )
                ))%>%
        
        formatStyle("prompt", background = "darkgrey")
        
    })
  })
  
  # create the table output to be displayed
  output$table <- renderDT({
    
    req(input$question)
    req(input$addbtn)
    
    datatable(responses, 
              style = "bootstrap",
              escape = FALSE, 
              rownames = FALSE, 
              extensions = 'Buttons',
              selection = list(mode = "multiple", target = "row"),
              options = list(
                pageLength = 100,
                #columnDefs = list(list(visible=FALSE, targets=c(0))),
                dom = 'B',
                buttons = list('copy', 'csv', 'excel', 'pdf', 'print'),
                initComplete = JS(
                  'function(settings, json) {
                      $(this.api().table().header()).css("background-color", "transparent");
                      $(this.api().table().header()).css("color", "transparent");
                    }'
                )
              ))%>%
      
      formatStyle("prompt", background = "darkgrey")
      
  })
  
}

#run app
shinyApp(ui = ui, server = server)

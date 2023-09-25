#Install the required packages
install.packages("shiny","openai","jsonlite")

###Loading the requried packages
library(shiny)
library(openai)
library(jsonlite)

##Setting the enviroment variables
Sys.setenv(openai_api_key = "{secret_key}")
#{Secret_key-- Input the secret key you copied from your Openai account here


ui <- fluidPage(
  titlePanel("Chat Interface"),
  sidebarLayout(
    sidebarPanel(
      textInput("user_message", "Enter your message:"),
      sliderInput("temperature", "Temperature:", min = 0, max = 1, value = 0.7, step = 0.1),
      actionButton("submit_message", "Submit Message")
    ),
    mainPanel(
      # in the UI function
      titlePanel("Response:"),
      textOutput(outputId = "assistant")    
    )
  )
)

server <- function(input, output, session) {
  chat_history <- list()  # Store chat history
  
  observeEvent(input$submit_message, {
    user_message <- input$user_message
    
    # Add user's message to chat history
    chat_history <- append(chat_history, list(list("role" = "user",
                               "content" = user_message)))
    
    # Clear the user input field
    updateTextInput(session, "user_message", value = "")
    
    # Call the create_chat_completion function
    assistant_response <- create_chat_completion(
      model = "gpt-3.5-turbo",
      messages = chat_history,
      temperature = input$temperature,
      openai_api_key = Sys.getenv("openai_api_key")
    )
    
    # Extract and append assistant's response content to chat history
    assistant_content <- assistant_response[[5]]
    chat_history <- append(chat_history, list(list("role" = "assistant", 
                                              "content" = assistant_content)))
    # Update the chat display in the mainPanel
    output$assistant <-
      renderText({
        paste(assistant_content[4])
      })

     })
    }

#Add the final Shiny code that integrate the UI and the Server logic together
shinyApp(ui, server)
##Run the Shiny app


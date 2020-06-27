# Setup Environment -------------------------------------------------------
library(shiny)
library(httr)
library(dplyr)
library(shinythemes)
library(DT)
library(leaflet)


# UI ----------------------------------------------------------------------

# Define UI for application
ui = navbarPage(
    theme = shinytheme("flatly"),
    # <--- to change the theme, change the theme title
    "House Price Predictions",
    tabPanel("User Inputs",
             sidebarPanel(
                 # input for bedrooms
                 numericInput(
                     inputId = "bedrooms",
                     label = "Enter # of Bedrooms:",
                     1, min = 1, max = 8
                 ),
                 # input for bathrooms
                 numericInput(
                     inputId = "bathrooms",
                     label = "Enter # of Bathrooms:",
                     1, min = 1, max = 8
                 ),
                 # input for sqft
                 numericInput(
                     inputId = "sqft_living",
                     label = "Enter Square Footage:",
                     1500, min = 400, max = 8000
                 ),
                 # input for # floors
                 numericInput(
                     inputId = "floors",
                     label = "Enter # of Floors:",
                     1, min = 1, max = 5
                 ),
                 # Submit button
                 actionButton(inputId = "submit", "Submit")
             ),
             mainPanel(
                 # output predictions
                 DT::dataTableOutput(outputId = "table")
             )
     ),
    tabPanel("Map",
             mainPanel(
                 # Output leaflet map
                 leafletOutput("map"),
                 # Output
                 DT::dataTableOutput(outputId = "map_table")
             )
    )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    # get predictions
    df <- eventReactive(input$submit, {
        res <- httr::GET(
            # Point to Plumber API
            "https://rs-connect-d.com/content/418/prediction",
            # send inputs from app to Plumber API 
            query = list(bedrooms = input$bedrooms,
                         bathrooms = input$bathrooms,
                         sqft_living = input$sqft_living,
                         floors = input$floors
                         ),
            add_headers(
                # connect API Key created in RS Connect
                Authorization = paste0("Key ", Sys.getenv("CONNECT_API_KEY"))
                )
        ) %>%
            # get content from API call
            httr::content() %>%
            # convert data to tibble
            purrr::map_df(tibble::as_tibble)
    })
    
    # output prediction from API call
    output$table <- DT::renderDataTable({
        df <- df() %>% as.data.frame()
        datatable(df,
                  colnames = "Predicted House Price",
                  rownames = FALSE,
                  options = list(paging = FALSE, info = FALSE, searching = FALSE)) %>% 
            formatCurrency("value", "$", digits = 0)
    })
    
    # output leaflet map
    output$map <- renderLeaflet({
        # get data for map
        pins::board_register_rsconnect(server = "rs-connect-d.com")
        df <- pins::pin_get("house_test_data", board = "rsconnect")

        # code for leaflet map
        df %>%
            leaflet() %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            setView(lng = median(df$long), lat = median(df$lat), zoom = 14) %>%
            addAwesomeMarkers(
                lng = ~long,
                lat = ~lat,
                label = ~paste("House ID: ", id,
                               "Bedrooms: ", bedrooms,
                               "Bathrooms: ", bathrooms,
                               "Sqft: ", sqft_living,
                               "Floors: ", floors,
                               sep = " ")
            )
    })


    # Use API to get predictions from model
    map_df <- reactive({
        # require user to click on map
        req(input$map_marker_click)

        # get data for map
        df <- pins::pin_get("house_test_data", board = "rsconnect")

        # get the selected id from the map
        selected_id <- df %>%
            # Somtimes clicks and ids don't line up exactly, use min dist
            mutate(lat = lat - input$map_marker_click$lat,
                   long = long - input$map_marker_click$lng,
                   dist = lat^2 + long^2) %>%
            filter(dist == min(dist)) %>%
            select(id, bedrooms, bathrooms, sqft_living, floors)

        # get prediction from API
        res <- httr::GET(
            # Point to Plumber API
            "https://rs-connect-d.com/content/418/prediction",
            # send inputs from selected house to Plumber API
            query = list(bedrooms = selected_id$bedrooms,
                         bathrooms = selected_id$bathrooms,
                         sqft_living = selected_id$sqft_living,
                         floors = selected_id$floors
            ),
            add_headers(
                # connect API key from RS Connect
                Authorization = paste0("Key ", Sys.getenv("CONNECT_API_KEY"))
            )
        ) %>%
            # get content from API call
            httr::content() %>%
            # convert data to tibble
            purrr::map_df(tibble::as_tibble)
    })

    # Output prediction from house selected on map
    output$map_table <- DT::renderDataTable({
        map_df <- map_df() %>% as.data.frame()

        datatable(map_df,
                  colnames = "Predicted House Price",
                  rownames = FALSE,
                  options = list(paging = FALSE, info = FALSE, searching = FALSE)) %>%
            formatCurrency("value", "$", digits = 0)
    })
    
    
}

shinyApp(ui, server)
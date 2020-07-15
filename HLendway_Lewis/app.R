library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(babynames)
library(shinyjs)

# Preprocessing data
# Create extinct babynames single row dataset for loading speed
# extinct_babynames_singlerow <-
#     babynames %>%
#     filter(year <= 1960) %>%
#     group_by(name) %>%
#     filter(n() > 10) %>%
#     arrange(year) %>%
#     filter(row_number() == n()) %>%
#     ungroup() %>%
#     select(-prop)
# 
# saveRDS(extinct_babynames_singlerow,"HLendway_Lewis/data/extinct_babynames_singlerow.rds")
# 
# Create extinct babynames dataset for loading speed
# extinct_babynames <-
#     babynames %>%
#     filter(year <= 1960)
# saveRDS(extinct_babynames,"HLendway_Lewis/data/extinct_babynames.rds")
# 
# Create peak prop data for loading speed
# peak_prop_year_data <- babynames %>%
#     group_by(name, sex) %>%
#     filter(n() > 50) %>%
#     filter(prop == max(prop)) %>%
#     ungroup() %>%
#     sample_n(50)
# 
# saveRDS(peak_prop_year_data,"HLendway_Lewis/data/peak_prop_year_data.rds")

extinct_babynames_singlerow <- readRDS(paste0(getwd(),"/data/extinct_babynames_singlerow.rds"))
extinct_babynames <- readRDS(paste0(getwd(),"/data/extinct_babynames.rds"))
peak_prop_year_data <- readRDS(paste0(getwd(),"/data/peak_prop_year_data.rds"))

ui <-  dashboardPage(skin = "black",
                     dashboardHeader(
                         title="NoRth App"
                     ),
                     dashboardSidebar(sidebarMenu(id = "sidebar",
                                                  menuItem("Reactive Values", tabName = "tab_one", icon = icon("fast-forward")),
                                                  menuItem("Datatable Selection", tabName = "tab_two", icon = icon("table")),
                                                  menuItem("Plot Highlighting", tabName = "tab_three", icon = icon("area-chart")),
                                                  menuItem("Additional Examples", tabName = "tab_four", icon = icon("shopping-basket"))
                     )),
                     dashboardBody(
                         useShinyjs(),
                         tabItems(
                             tabItem(tabName = "tab_one",
                                     fluidRow(
                                         shiny::column(width = 12,
                                                       HTML(("<p><b>What are reactiveValues?</b>  <i>ReactiveValues are like a special type of list, 
                                                             they can store values from reactive objects but the reactiveValues object is not actually 
                                                             reactive itself.</i></p><br/>"))
                                         )
                                     ),
                                     fluidRow(
                                         shiny::column(width = 4,
                                                       textInput("name_input_reactive","First Name: "),
                                                       actionButton("add_name", "Add Name")
                                         ),
                                         shiny::column(width = 8,
                                                       box(title = "Name Info", width = 12, height = "600px",
                                                           solidHeader = T,
                                                           status = "primary", 
                                                           DT::dataTableOutput("my_name_table")
                                                       )
                                         )
                                     ),
                                     fluidRow(
                                         shiny::column(width = 4,
                                                       textInput("name_input","First Name: "),
                                                       actionButton("add_family_button", "Add Family Member")
                                         ),
                                         shiny::column(width = 8,
                                                       box(title = "My Family", width = 12, height = "600px",
                                                           solidHeader = T,
                                                           status = "primary", 
                                                           DT::dataTableOutput("my_family_name_list")
                                                       )
                                         )
                                     )
                             ),
                             tabItem(tabName = "tab_two",
                                     shiny::column(width = 4,
                                                   box(title = "Extinct Baby Names (1880-1960)", width = 12, 
                                                       solidHeader = T,
                                                       status = "primary", 
                                                       collapsible = T,    
                                                       DT::DTOutput("babynames.dt"))),
                                     shiny::column(width = 8,
                                                   plotOutput("dt_select_plot")
                                     )
                             ),
                             tabItem(tabName = "tab_three",
                                     shiny::column(width = 6, box(width = 12, 
                                                                  plotOutput("peak.scatter.plot",
                                                                             click = "peak.scatter.plot_click",
                                                                             brush = brushOpts(
                                                                                 id = "peak.scatter.plot_brush"
                                                                                 )))),
                                     shiny::column(width = 6, box(width = 12,
                                                                  plotOutput("peak.time.series"))),
                                     fluidRow(
                                         column(width = 6,
                                                h4("Points near click"),
                                                verbatimTextOutput("click_info")
                                         ),
                                         column(width = 6,
                                                h4("Brushed points"),
                                                verbatimTextOutput("brush_info")
                                         )
                                     )
                             ),
                             tabItem(tabName = "tab_four",
                                     fluidRow(
                                         box(title = "Additional Examples", 
                                             width = 12, 
                                             solidHeader = T,
                                             status = "primary", 
                                             HTML(("<p>Additional interactive plotting resources:</p>
                                             <ul>
                                                 <li>Shiny gallery plot selecting points on a plot: 
                                                    <a href='https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html' target='blank'>
                                                    https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html</a>
                                                 </li>
                                                 <li>RStudio reference guide for basic plot interaction: 
                                                    <a href='https://shiny.rstudio.com/articles/plot-interaction.html' target='blank'>
                                                    https://shiny.rstudio.com/articles/plot-interaction.html</a>
                                                 </li>
                                                 <li>RStudio reference guide for selecting rows of data: 
                                                    <a href='https://shiny.rstudio.com/articles/selecting-rows-of-data.html' target='blank'>
                                                    https://shiny.rstudio.com/articles/selecting-rows-of-data.html</a>
                                                 </li>
                                                 <li>RStudio reference guide for advanced plot interaction: 
                                                    <a href='https://shiny.rstudio.com/articles/plot-interaction-advanced.html' target='blank'>
                                                    https://shiny.rstudio.com/articles/plot-interaction-advanced.html</a>
                                                 </li>
                                             </ul>
                                             <p>Additional references for reactiveValues:</p>
                                             <ul>
                                                 <li>
                                                    RStudio reference guide on reactiveValues: 
                                                    <a href='https://shiny.rstudio.com/reference/shiny/0.11/reactiveValues.html' target='blank'>
                                                    https://shiny.rstudio.com/reference/shiny/0.11/reactiveValues.html</a>
                                                 </li>
                                                 <li>
                                                    ARDATA - Using reactiveValues with modules: 
                                                    <a href='https://www.ardata.fr/en/post/2019/04/26/share-reactive-among-shiny-modules/' target='blank'>
                                                    https://www.ardata.fr/en/post/2019/04/26/share-reactive-among-shiny-modules/</a>
                                                 </li>
                                                 <li>
                                                    Discussion on RStudio Community about reactiveValues in modular apps and using reactiveValues to pass data between modules: 
                                                    <a href='https://community.rstudio.com/t/best-practices-for-global-external-variables-used-in-a-module/5820/8' target='blank'>
                                                    https://community.rstudio.com/t/best-practices-for-global-external-variables-used-in-a-module/5820/8</a>
                                                 </li>
                                             </ul>"))
                                         )
                                     )
                             )
                         )
                     )
)


server <- function(input, output, session) {

    # Example of a typical reactive
    output$my_name_table <- DT::renderDataTable({
        
        req(input$add_name)
        
        # get the name entered and make a tibble to join to
        name <- isolate(input$name_input_reactive)
        data <- name %>% 
            as.tibble()
        
        # only render if there is a name
        validate(
            need(nrow(data) > 0, 'No one has been added to your family yet')
        )
        
        # join the name to the baby names data set and show the peak proportion year for each gender
        data %>% 
            rename(name = value)%>% 
            left_join(babynames, by = "name") %>% 
            group_by(name, sex) %>%
            filter(prop == max(prop)) %>%
            select(name, sex, year) %>%
            pivot_wider(names_from = sex, values_from = year, names_prefix = "Peak Prop Year - ")
        
        
    })
    
    # Setting up a reactiveValue `my_family` to hold the list of the family names entered in the app
    values <- reactiveValues(my_family = NULL)
    
    # Observe event for adding people to the family list - this will run when the `add_family_button` is clicked
    observeEvent(input$add_family_button, {
        
        # requires a non empty input to execute this code chunk
        req(input$name_input)
        
        print(paste("Add family member button clicked"))
        
        # get the historical family list from reactiveValues and print it to the console for demo sake
        # to reference your reacvtiveValues within a reative context, you can use the objectName$var or objectName[[`var`]]
        cur_family <- values$my_family
        
        print(paste(paste("Current family member list: "), paste(cur_family, collapse = ", ")))
        
        # clean up new family member name and print it to the console for demo sake
        new_member <- str_to_title(input$name_input)
        
        print(paste("Adding family member:", new_member))
        
        # Update the reactiveValues `my_family` to have the new family member and print it to the console for demo sake
        values$my_family <- c(cur_family, new_member)
        
        print(paste(paste("Updated family member list:"), paste(values$my_family, collapse = ', ')))
        
    })
    
    output$my_family_name_list <- DT::renderDataTable({
        
        # get the current family list from the reactiveValues
        data <- values$my_family %>% 
            as.tibble()
        
        # only render if there is a name
        validate(
            need(nrow(data) > 0, 'No one has been added to your family yet')
        )
        
        # join the family names to the baby names data set and show the peak proportion year for each gender
        data %>% 
            rename(name = value)%>% 
            left_join(babynames, by = "name") %>% 
            group_by(name, sex) %>%
            filter(prop == max(prop)) %>%
            select(name, sex, year) %>%
            pivot_wider(names_from = sex, values_from = year, names_prefix = "Peak Prop Year - ")
    
        
    })
    
    output$babynames.dt <- DT::renderDT({
        
        extinct_babynames_singlerow %>%
            select(name, sex, `Most Recent Year` = year, n) %>%
            datatable(options = list(paging = FALSE,
                                     scrollY = "400px"),
                      rownames = F,
                      height = "400px")
        
    })
    
    
    selected_data_to_plot <- reactive({
        req(input$babynames.dt_rows_selected)
        req(input$babynames.dt_row_last_clicked)
        
        print(paste("babyname indexes selected", input$babynames.dt_rows_selected))
        
        selected_names <- extinct_babynames_singlerow$name[input$babynames.dt_rows_selected]
        last_clicked_name <- extinct_babynames_singlerow$name[input$babynames.dt_row_last_clicked]
        
        print("babynames selected:") %>%
            print(str(selected_names))
        
        
        selected_data_to_plot <- extinct_babynames %>%
            filter(name %in% selected_names) %>%
            mutate(last_selected = if_else(
                name == last_clicked_name,
                "Last Selected",
                "Previously Selected"
            ))
        
        return(selected_data_to_plot)
    })
    
    
    output$dt_select_plot <- renderPlot({
        
        ggplot(selected_data_to_plot()) +
            geom_line(aes(x = year, y = prop, color = name, linetype = sex,
                          size = last_selected)) +
            scale_size_manual(values = c("Last Selected" = 2,
                                         "Previously Selected" = 0.5)) +
            scale_x_continuous(breaks = seq(1880, 1960, 10)) +
            labs(title = "Annual Proportion of Babies with Selected Names",
                 x = "Year", y = "Proportion")
        
    })
    
    output$peak.scatter.plot <- renderPlot({
        print("peak year scatterplot")
        print(peak_prop_year_data %>% head())
        
        peak_prop_year_data %>%
            ggplot(aes(x = year, y = prop, color = name)) +
            geom_point() +
            theme(legend.position = "none")
        
    })
    
    output$click_info <- renderPrint({
        # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
        # were a base graphics plot, we'd need those.
        print(nearPoints(peak_prop_year_data, input$peak.scatter.plot_click, addDist = TRUE))
    })
    
    output$brush_info <- renderPrint({
        
        brushedPoints(peak_prop_year_data, input$peak.scatter.plot_brush)
    })
    
    click_data <- reactive(
        nearPoints(peak_prop_year_data, input$peak.scatter.plot_click, addDist = TRUE)
    )
    
    brush_data <- reactive(
        brushedPoints(peak_prop_year_data, input$peak.scatter.plot_brush)
    )
    
    output$peak.time.series <- renderPlot({
        
        shiny::validate(need(nrow(click_data()) > 0 | nrow(brush_data()) > 0,
                             "Please select a specific point or a range of points from the scatter plot"))
        
        if(nrow(click_data()) == 1) {
            babynames %>%
                filter(name %in% click_data()$name) %>%
                ggplot(aes(x = year, y = prop, color = name, linetype = sex)) +
                geom_line() +
                scale_x_continuous(breaks = seq(1880, 2020, 10), limits = c(1880, 2020))
            
        } else {
            # if(nrow(brush_data() != 0)) {
            babynames %>%
                filter(name %in% brush_data()$name) %>%
                ggplot(aes(x = year, y = prop, color = name, linetype = sex)) +
                geom_line() +
                scale_x_continuous(breaks = seq(1880, 2020, 10), limits = c(1880, 2020))
            #  } else NULL
        }
        
    })

    
}

# Run the application 
shinyApp(ui = ui, server = server)
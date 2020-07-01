library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(babynames)
library(shinyjs)

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
# peak_prop_year_data <- babynames %>%
#     group_by(name, sex) %>%
#     filter(n() > 50) %>%
#     filter(prop == max(prop)) %>%
#     ungroup() %>%
#     sample_n(50)
# 
# saveRDS(peak_prop_year_data,"HLendway_Lewis/data/peak_prop_year_data.rds")

extinct_babynames_singlerow <- readRDS(paste0(getwd(),"/data/extinct_babynames_singlerow.rds"))
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
                                             HTML(("<ul>
                                             <li>
                                                <a href='https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html' target='blank'>
                                                https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html</a>
                                             </li>
                                                   </ul>"))
                                         )
                                     )
                             )
                         )
                     )
)


server <- function(input, output, session) {
    
    values <- reactiveValues(my_family=NULL)
    
    observeEvent(input$add_family_button, {
        
        # req(input$name_input)
        print(paste("Adding family member",input$name_input))
        cur_family <- values$my_family
        
        new_member <- str_to_title(input$name_input)
        
        if(length(new_member) > 0) {
            
            if(!is.null(cur_family)) {
                cur_family <- c(cur_family,new_member)
            } else {
                cur_family <- c(new_member)
            }
            
            # Update the reactiveValue to have the new family member
            values$my_family <- cur_family
        }
        print(paste("Family list",values$my_family))
    })
    
    output$my_family_name_list <- DT::renderDataTable({
        
        data <- values$my_family %>% 
            as.tibble()
        
        validate(
            need(nrow(data) > 0, 'No one has been added to your family yet')
        )
        
        data %>% 
            rename(name = value)%>% 
            left_join(babynames) %>% 
            group_by(name, sex) %>%
            filter(prop == max(prop)) %>%
            select(name, sex, year) %>%
            pivot_wider(names_from = sex,values_from = year, names_prefix = "Peak Prop Year - ")
    
        
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
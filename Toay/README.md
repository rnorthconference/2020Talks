# Introduction 
This repository contains an example of using RStudio Connect to create an end-to-end data science pipeline.

Open the presentation to get an overview: end_to_end_workflows.pdf

# Getting Started
Tutorials on Plumber and Pins can be found in the folder tutorials. This is to give a brief example on how to use the basic functions.

Data comes from the House Sales in King County, USA on Kaggle: https://www.kaggle.com/harlfoxem/housesalesprediction 

You will need the following libraries:
library(tidyverse)
library(pins)
library(plumber)
library(shiny)
library(httr)
library(shinythemes)
library(DT)
library(leaflet)
library(lubridate)
library(caTools)


# Build and Test

Content:
1. ingest_data.Rmd - reads and formats data then saves out test and train data as pins. Scheduled on Connect monthly.
2. build_model.Rmd - builds model and pins model object. Scheduled on Connect monthly.
3. API/plumber.R - serves the model predictions using Plumber API. Live on Connect.
4. App/app.R - shiny app for end users to get predictions. Live on Connect. 

Tip:
- when you deploy your Plumber API and Shiny App, you will need to create an API key in RStudio Connect and add the key as an environment variable within your API or App.

Once you name your key and add it as an environment variable, you can access pin objects using:

# register rconnect board
pins::board_register(board = "rsconnect", # board name
                     server = "rs-connect-d.com, # server name
                     key = Sys.getenv("CONNECT_API_KEY") # key name
                     )



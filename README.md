# Conference Seminars

- Amelia McNamara: Scraping, iterating, purring
- Lisa Lendway: Reproducible Machine Learning with tidymodels
- Haema Nilakanta: Being bilingual - coding in both R and python
- Eric Lind: Probabilistic answers to data science questions: using Bayesian hierarchical modeling in analysis of public transit
- Erin LeDell: Automatic Machine Learning in R
- Carson Sievert: Styling shiny and rmarkdown with Sass and Bootstrap 4
- Alyssa Toay: Deploying End-to-End Data Science Production Workflows in R
- Heather Lendway and Connor Jo Lewis: Powerful Yet Simple Reactive Concepts in Shiny
- Kim Eng Ky: dplyr + data.table = dtplyr?
- Nicholas Newstrom: R statistics: A social scientist’s journey

# Conference Startup Materials

## Install R 4.0.0 or higher
- Navigate to a nearby CRAN mirror: https://cran.r-project.org/mirrors.html; for example: https://mirror.las.iastate.edu/CRAN/
- Choose the download for your operating system

## Install RStudio
- Navigate to https://rstudio.com/products/rstudio/download/
- Choose the download for your operating system
- Install the following R packages in your R instance
```
install.packages( c('devtools', 'purrr', 'rvest', 
                    'RSelenium', 'dplyr', 'data.table', 
                    'dtplyr', 'epiDisplay', 'lavaan',
                    'reticulate', 'rstanarm', 'rstan',
                    'coda','mvtnorm','loo','dagitty',
                    'h2o', 'rmarkdown', 'shiny', 'plumber', 
                    'pins', 'flexdashboard', 'plotly', 'DT',
                    'shinydashboard', 'babynames', 'shinyjs',
                    'httr', 'shinythemes', 'leaflet','lubridate',
                    'moderndive', 'vip', 'caTools'))

install.packages( 'tidyverse' )
install.packages( 'tidymodels' ) #Say yes to any package requiring compilation if asked

#Rethinking and bootstraplib are not yet on CRAN
devtools::install_github('rmcelreath/rethinking') #won't work in R 4.0.0; update to R 4.0.2
devtools::install_github('rstudio/bootstraplib') #Choose 1 to update all packages if asked
```
# noRth Playlist
https://www.youtube.com/playlist?list=PLZJbLCOGgmFHER8pPVj40Bta_rGCNPr1q

# noRth 2021
Contact us at rnorthconf@gmail.com if you are interested in giving a talk or volunteering as part of the organization committee!



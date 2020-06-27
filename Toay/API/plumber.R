library(plumber)
library(dplyr)

# register RStudio Connect board
pins::board_register(board = "rsconnect",
                     server = "rs-connect-d.com",
                     key = Sys.getenv("CONNECT_API_KEY")
                     )

# get model pin
model <- pins::pin_get("house_model", board = "rsconnect")


#* @apiTitle Plumber API for House Price Model

#* Return the predicted house price
#* @param bedrooms number of bedrooms in the house
#* @param bathrooms number of bathrooms in the house
#* @param sqft_living square footage in the house
#* @param floors the number of floors in the house
#* @get /prediction
function(bedrooms, bathrooms, sqft_living, floors)
{
  # create a dataframe with inputs
  new_house <- data.frame(bedrooms = as.factor(bedrooms),
                          bathrooms = as.factor(bathrooms),
                          sqft_living = as.numeric(sqft_living),
                          floors = as.factor(floors))
  
  # predict the new house with the model object
  prediction <- predict(model, new_house)
  
  # round decimals
  prediction %>% 
    round()
}

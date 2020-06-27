# Setup Environment -------------------------------------------------------
library(pins)

# register board when multiple servers are available
board_register_rsconnect(server = "rs-connect-d.com")

# Put pin on board
pin(mtcars,
    "mtcars_data",
    description = "mtcars dataset",
    board = "rsconnect")

# get pin back
df <- pin_get("mtcars_data",
              board = "rsconnect")



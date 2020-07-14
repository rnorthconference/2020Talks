#######################################################
# Being Bilingual: coding in both R and Python        #
# noRth conference 2020                               #
# July 14, 2020                                       #
# Presenter: Haema Nilakanta                          #
#######################################################

# Interactive R code to accompany presentation # 
# Load library
library(reticulate)

# Check the package version
packageVersion("reticulate")

# Check what Python source it's using
py_config()

####################################
# Interacting with Python
#  1. Interactive session 
####################################

# Do a quick iteractive session
# This code will look like errors in script, but it's meant to be run in an interactive session
repl_python()

# Import a package
import pandas as pd

# Build a test data frame
# list of presenters and start time for July 14th session
north_R_July14 = {'Presenter': ['McNamara','Lendway','Nilakanta','Lind', 'LeDell'],
  'StartTime': ['9:10','10:00','10:35','11:15', '11:50']
}
# Save as a pandas dataframe 
p_df = pd.DataFrame(north_R_July14, columns = ['Presenter', 'StartTime'])

# Print output
print(p_df)

# Exit interactive session
exit

# Load pandas dataframe
p_df

# Notice it doesn't exist! But if we restart our interactive session
repl_python()

# and try again - we find it!
p_df

# That is, "All code executed within the REPL is run within the Python main module, 
# and any generated Python objects will persist in the Python session after the REPL is detached"

# Close it out again
exit

####################################
# Interacting with Python
#  2. Import Python packages
####################################

# Load the os (operating system) package
# This package is pre-installed
os = import("os")

# Use $ to extract functions
# In Python keep () to run the function
os$getcwd()

# Check it if matches with the R version
getwd()

# Sometimesw we need to install packages (i.e. aren't pre-installed)

# scipy popular python scientific computing package
# Use the conda tool and specify the environment to install it to
conda_install("r-reticulate", "scipy")

# Import the package
scipy = import("scipy")

# Another approach:
# Use the pip tool to install a package
# sklearn holds many machine learning functions
py_install('sklearn', pip = TRUE)

# Import modules from the package
sklearn_text = import("sklearn.feature_extraction.text")

# tensorflow popular package for deep-learning modules
# reticulate designed to install package from CRAN
# it will do the rest to install
install.packages("tensorflow")

# Then to load tensorflow, use typical library() command
library(tensorflow)

####################################
# Interacting with Python
#  3. Load external Python scripts
####################################

source_python("logitfunc.py")
logit_py(0.5)

##############################################
# Natural Language Processing Example (NLP)  #
##############################################

# Example of processing and analyzing text data 

# Install the spacyr package - used for fast natural language processing
# Similar to tensorflow, it's been designed to work with reticulate
# for easy install
install.packages("spacyr")

# Now clear workspace and restart R session - we will use a different conda session
rm(list = ls())
.rs.restartR()

# Load reticulate 
library("reticulate")

# Notice there is a new environment, "spacy_condaenv"
conda_list()

# Use the "spacy_condaenv" environment 
use_condaenv(condaenv = "spacy_condaenv")

# Load spacyr library
library("spacyr")

# Get english model from the package
spacy_initialize(model = "en_core_web_sm")

# Install and load pandas in this environment too
conda_install("spacy_condaenv", "pandas")
pd = import("pandas")

# Read in some text
txt = c(d1 = "noRth is an R conference.",
         d2 = "this is the best conference ever!",
         d3 = "Minnesota is in the midwest.")

# Check the components of the text
# pos is the Universal tagset for parts-of-speech
# tag is the detailed tag set based on the TIGER Treebank scheme
(wordbreakdown = spacy_parse(txt, tag = TRUE, entity = FALSE, lemma = FALSE))

# Tokenize (aka split up) the sentences
spacy_tokenize(txt)$d1
spacy_tokenize(txt)$d2
spacy_tokenize(txt)$d3

# Now break up the text into phrases
parsedtxt = spacy_parse(txt, lemma = FALSE, entity = TRUE, nounphrase = TRUE)
entity_extract(parsedtxt)
nounphrase_extract(parsedtxt)

# Let's go back to the word breakdown 
wordbreakdown
class(wordbreakdown)

# Convert the parsed text to a pandas dataframe
ex_pandas_df = reticulate::r_to_py(wordbreakdown)
class(ex_pandas_df)

# Create a ggplot histogram of the number word types 
wordbreakdown_df = data.frame(wordbreakdown)
library(ggplot2)
ggplot(wordbreakdown_df, aes(pos)) +
  geom_bar() + 
  xlab("Parts of Speech")

# Close out using spacy module
spacy_finalize()


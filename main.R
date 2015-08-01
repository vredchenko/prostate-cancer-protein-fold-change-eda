#
# Install any non-standard packages, but only if they are missing locally
# 
list.of.packages <- c("data.table") # <- add more packages here as needed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


# 
# At the end of the day we will want to aggregte results from all observations, hence the vector of dataframes.
# 
# Load data from CSV files, store in a vector of dataframes
# csv_files <- list.files(path="data", pattern = "*.csv", full.names = TRUE)
# all_data <- list()
# all_data <- lapply(csv_files, read.csv)


# 
# For now lets do a POC with a single observation
# 

# read in a single CSV file:
MyData <- read.csv(file="data/PRG_518_519.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

# subset just the columns we need, and skip first two rows because they are headers:
MyData <- MyData[ -(1:2), c(7,8,9,17,20)]

# add our own column names for easier referencing:
MyData = setNames(MyData, c("foldChange", "C1", "C2", "Seq", "Desc"))

# convert all "Infinity" strings to infinity value..
MyData$foldChange[MyData$foldChange == "Infinity"] <- "Inf"
# ..and set corrent types for columns:
MyData$foldChange <- as.numeric(as.character(MyData$foldChange))

# give absolute fold change values direction (i.e. did protein amount increase in healthy or tunorous tissue):
library(data.table) 
MyDataTable = data.table(MyData) # NOTE: data tables seem more robust for this?
MyDataTable[C1 == "Condition 1", foldChange := foldChange * -1] # TODO: which way round does this shit go?
# As good a time as any to..
rm(MyData, list.of.packages, new.packages) # ..free up some memory

# Now that we cleaned up the data a little, let the fun commence:

# It's easy to get a statisitcal summary of foldChange using "summary" function,
# but it helps to exclude infinite values first:
# noInfinity <- MyDataTable[ MyDataTable$foldChange != Inf & MyDataTable$foldChange != -Inf, ]
# View(noInfinity)
# print( summary(noInfinity$foldChange) )


# Should we want to sort based on foldChange magnitude:
sorted_asc <- MyDataTable[order(foldChange),] # in ascending order
sorted_desc <- MyDataTable[order(-foldChange),] # or in descending order
# View(sorted_desc)
rm(sorted_asc, sorted_desc)

# To see number of unique sequences and descriptions:
# u <- unique(MyDataTable$Desc)
# u <- unique(MyDataTable$Seq)


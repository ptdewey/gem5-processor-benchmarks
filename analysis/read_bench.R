#!/usr/bin/env Rscript

library(data.table)
library(dplyr)
library(readr)

# read target file path from cli args
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
    stop("Not enough arguments", call. = FALSE)
}
file_path <- args[1]
if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path, call. = FALSE)
}

# read simulation data into dataframe
read_simulation_data <- function(file_path) {
    lines <- read_lines(file_path)
    # remove comment lines
    data_lines <- grep("^.*\\s+\\d+(\\.\\d+)?\\s*#.*$", lines, value = TRUE)
    # extract metric names
    metrics <- sub("\\s+\\d+.*", "", data_lines)
    # extract metric values
    values <- as.numeric(sub("^.*?(\\d+(\\.\\d+)?).*", "\\1", data_lines))
    df <- data.table(metric = metrics, value = values, stringsAsFactors = FALSE)
    return(df)
}

simulation_data <- read_simulation_data(file_path)
print(head(simulation_data, 10))

# NOTE: write to csv to check if output looks correct
write.csv(simulation_data, "output.csv", row.names = FALSE)


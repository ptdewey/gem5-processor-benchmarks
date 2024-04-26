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
write.csv(simulation_data, "output.csv", row.names = FALSE)

# Function to merge data from multiple files into a single dataframe
merge_simulation_data <- function(directory) {
    files <- list.files(directory, pattern = "\\.txt$", full.names = TRUE)
    if (length(files) == 0) return(data.frame())

    merged_df <- read_simulation_data(files[1])
    colnames(merged_df) <- c("metric", tools::file_path_sans_ext(basename(files[1])))

    for (file in files[-1]) {
        data <- read_simulation_data(file)
        colnames(data) <- c("metric", tools::file_path_sans_ext(basename(file)))
        merged_df <- merge(merged_df, data, by = "metric", all = TRUE)
    }
    return(merged_df)
}


df <- merge_simulation_data(file_path)
print(head(df, 10))
write.csv(df, "benchmark_stats/all_stats.csv", row.names = FALSE)

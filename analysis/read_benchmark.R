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
    # select lines that potentially have three values before the comment
    data_lines <- grep("^[^#]+\\s+-?\\d+(\\.\\d+)?\\s+(-?\\d+\\.\\d+%?\\s*){0,2}#.*$", lines, value = TRUE)
    df_list <- lapply(data_lines, function(line) {
        # remove the comment for easier processing
        clean_line <- sub("#.*", "", line)
        # split the line into parts based on one or more spaces
        parts <- strsplit(clean_line, "\\s+")[[1]]
        # calculate the index where the metric name ends
        # maximum number of values expected at the end
        num_values_expected <- 3
        num_parts <- length(parts)
        metric_end_index <- max(1, num_parts - num_values_expected)
        metric <- paste(parts[1:metric_end_index], collapse = " ")
        value1 <- as.numeric(parts[metric_end_index + 1])
        value2 <- if (num_parts > metric_end_index + 1) suppressWarnings(as.numeric(gsub("%", "", parts[metric_end_index + 2]))) / 100 else NA
        value3 <- if (num_parts > metric_end_index + 2) suppressWarnings(as.numeric(gsub("%", "", parts[metric_end_index + 3]))) / 100 else NA

        data.table(metric = metric, value1 = value1, value2 = value2, value3 = value3)
    })
    df <- rbindlist(df_list, use.names = TRUE, fill = TRUE)
    return(df)
}

# simulation_data <- read_simulation_data(file_path)
# print(head(simulation_data, 10))
# write.csv(simulation_data, "output.csv", row.names = FALSE)

# function to merge data from multiple files into a single dataframe
merge_simulation_data <- function(directory) {
    files <- list.files(directory, pattern = "\\.txt$", full.names = TRUE)
    if (length(files) == 0) return(data.frame())
    merged_df <- read_simulation_data(files[1])
    base_name <- gsub("stats-|\\.txt", "", basename(files[1]))
    colnames(merged_df) <- c("metric", paste(base_name, "count", sep="_"), paste(base_name, "pct", sep="_"), paste(base_name, "total_pct", sep="_"))
    for (file in files[-1]) {
        data <- read_simulation_data(file)
        base_name <- gsub("stats-|\\.txt", "", basename(file))
        colnames(data) <- c("metric", paste(base_name, "count", sep="_"), paste(base_name, "pct", sep="_"), paste(base_name, "total_pct", sep="_"))
        merged_df <- merge(merged_df, data, by = "metric", all = TRUE)
    }
    return(merged_df)
}

# NOTE: comment these lines out to include percentage columns

# drop total percentage column
df <- merge_simulation_data(file_path)
df <- select(df, -contains("total_pct"))

# drop entirely 0/NA rows
df <- df %>%
    rowwise() %>%
    filter(
        !all(
            is.na(c_across(ends_with("_count"))) |
            c_across(ends_with("_count")) == 0,
            is.na(c_across(ends_with("_pct"))) |
            c_across(ends_with("_pct")) == 0
        )
    ) %>%
    ungroup()

# drop percentage column
df <- select(df, -contains("pct"))

print(head(df, 10))
write.csv(df, "benchmark_stats/all_stats.csv", row.names = FALSE)

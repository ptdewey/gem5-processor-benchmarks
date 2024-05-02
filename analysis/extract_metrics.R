#!/usr/bin/env Rscript

library(data.table)
library(dplyr)
library(readr)


args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
    stop("Not enough arguments", call. = FALSE)
}
file_path <- args[1]
if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path, call. = FALSE)
}
df <- read_csv(file_path)

# TODO: filter out specified metrics

search_metric <- function(search_string, data = df) {
  matching_rows <- data %>%
    filter(metric == search_string)

  if (nrow(matching_rows) == 0) {
    # return(tibble(matrix(ncol = ncol(data), nrow = 1, dimnames = list(NULL, colnames(data)))))
    return()
  } else {
    return(matching_rows)
  }
}

print(search_metric("system.cpu.cpi"))

mdf <- bind_rows(
    # system metrics
    search_metric("system.cpu.cpi"),
    search_metric("system.cpu.ipc"),
    search_metric("system.cpu.issueRate"),
    search_metric("system.cpu.lsq0.loadToUse"),
    search_metric("system.fetch.cycles"),

    # instruction cache metrics
    search_metric("system.cpu.icache.ReadExReq.avgMissLatency::total"),
    search_metric("system.cpu.icache.overallAvgMissLatency.avgMissLatency::total"),
    search_metric("system.cpu.icache.replacements"),
    search_metric("system.cpu.icache.writebacks::total"),
    search_metric("system.cpu.icache.tags.tagAccesses"),
    search_metric("system.cpu.icache.tags.tagsInUse"),
    search_metric("system.cpu.icache.tags.occupancies"),
    search_metric("system.cpu.icache.tags.avgOccs::total"),
    search_metric("system.cpu.icache.tags.avgOccs::writebacks"),
    search_metric("system.cpu.icache.tags.avgRefs"),
    search_metric("system.cpu.icache.overallMisses::total"),
    search_metric("system.cpu.icache.overallMisses::cpu.inst"),
    search_metric("system.cpu.icache.overallMissLatency::total"),
    search_metric("system.cpu.icache.overallMissLatency::cpi.inst"),
    search_metric("system.cpu.icache.snoopTraffic"),
    search_metric("system.cpu.icache.snoops"),
    search_metric("system.cpu.icache.demandAccesses::cpu.data"),

    # data cache metrics
    search_metric("system.cpu.dcache.ReadExReq.avgMissLatency::total"),
    search_metric("system.cpu.dcache.overallAvgMissLatency.avgMissLatency::total"),
    search_metric("system.cpu.dcache.replacements"),
    search_metric("system.cpu.dcache.writebacks::total"),
    search_metric("system.cpu.dcache.tags.tagAccesses"),
    search_metric("system.cpu.dcache.tags.tagsInUse"),
    search_metric("system.cpu.dcache.tags.occupancies"),
    search_metric("system.cpu.dcache.tags.avgOccs::total"),
    search_metric("system.cpu.dcache.tags.avgOccs::writebacks"),
    search_metric("system.cpu.dcache.tags.avgRefs"),
    search_metric("system.cpu.dcache.overallMisses::total"),
    search_metric("system.cpu.dcache.overallMisses::cpu.inst"),
    search_metric("system.cpu.dcache.overallMissLatency::total"),
    search_metric("system.cpu.dcache.overallMissLatency::cpi.inst"),
    search_metric("system.cpu.dcache.snoopTraffic"),
    search_metric("system.cpu.dcache.snoops"),
    search_metric("system.cpu.dcache.demandAccesses::cpu.data"),


    # l2 cache metrics
    search_metric("system.l2bus.transDist::UpgradeReq"),
    search_metric("system.l2bus.transDist::UpgradeResp"),
    search_metric("system.l2bus.reqLayer0.occupancy"),
    search_metric("system.l2cache.ReadExReq.avgMissLatency::total"),
    search_metric("system.l2cache.overallAvgMissLatency.avgMissLatency::total"),
    search_metric("system.l2cache.replacements"),
    search_metric("system.l2cache.writebacks::total"),
    search_metric("system.l2cache.tags.tagAccesses"),
    search_metric("system.l2cache.tags.tagsInUse"),
    search_metric("system.l2cache.tags.occupancies"),
    search_metric("system.l2cache.tags.avgOccs::total"),
    search_metric("system.l2cache.tags.avgOccs::writebacks"),
    search_metric("system.l2cache.tags.avgRefs"),
    search_metric("system.l2cache.overallMisses::total"),
    search_metric("system.l2cache.overallMisses::cpu.inst"),
    search_metric("system.l2cache.overallMissLatency::total"),
    search_metric("system.l2cache.overallMissLatency::cpi.inst"),
    search_metric("system.l2cache.snoopTraffic"),
    search_metric("system.l2cache.snoops"),
    search_metric("system.l2cache.demandAccesses::cpu.data"),

    # l3 cache metrics
    search_metric("system.l3bus.transDist::UpgradeReq"),
    search_metric("system.l3bus.transDist::UpgradeResp"),
    search_metric("system.l3bus.reqLayer0.occupancy"),
    search_metric("system.l3cache.ReadExReq.avgMissLatency::total"),
    search_metric("system.l3cache.overallAvgMissLatency.avgMissLatency::total"),
    search_metric("system.l3cache.replacements"),
    search_metric("system.l3cache.writebacks::total"),
    search_metric("system.l3cache.tags.tagAccesses"),
    search_metric("system.l3cache.tags.tagsInUse"),
    search_metric("system.l3cache.tags.occupancies"),
    search_metric("system.l3cache.tags.avgOccs::total"),
    search_metric("system.l3cache.tags.avgOccs::writebacks"),
    search_metric("system.l3cache.tags.avgRefs"),
    search_metric("system.l3cache.overallMisses::total"),
    search_metric("system.l3cache.overallMisses::cpu.inst"),
    search_metric("system.l3cache.overallMissLatency::total"),
    search_metric("system.l3cache.overallMissLatency::cpi.inst"),
    search_metric("system.l3cache.snoopTraffic"),
    search_metric("system.l3cache.snoops"),
    search_metric("system.l3cache.demandAccesses::cpu.data")
)

print(mdf)
write.csv(mdf, "benchmark_stats/filtered_stats.csv")

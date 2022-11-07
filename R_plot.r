#
# Copyright 2022 Erwan Mahe (github.com/erwanM974)
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

rm(list=ls())
# ==============================================
library(ggplot2)
library(scales)
# ==============================================

# ==============================================
read_ana_report <- function(file_path) {
  # ===
  report <- read.table(file=file_path, 
                       header = FALSE, 
                       sep = ";",
                       blank.lines.skip = TRUE, 
                       fill = TRUE)
  
  names(report) <- as.matrix(report[1, ])
  report <- report[-1, ]
  report[] <- lapply(report, function(x) type.convert(as.character(x)))
  report
}
# ==============================================

# ==============================================
prepare_ana_data <- function(mydata) {
  mydata <- data.frame( mydata )
  #
  print( sprintf("number of times the timeout is exceeded : %d", 
                 nrow(mydata[mydata$verdict == "TIMEOUT",])) )
  #
  mydata <- mydata[mydata$verdict != "TIMEOUT",]
  #
  print( sprintf("number of ACCEPTED : %d", nrow(mydata[mydata$kind == "ACPT",])) )
  print( sprintf("number of MULTIPREF : %d", nrow(mydata[mydata$kind == "PREF",])) )
  print( sprintf("number of SWAP_ACT : %d", nrow(mydata[mydata$kind == "SACT",])) )
  print( sprintf("number of SWAP_COMP : %d", nrow(mydata[mydata$kind == "SCMP",])) )
  print( sprintf("number of NOISE : %d", nrow(mydata[mydata$kind == "NOIS",])) )
  #
  mydata$kind <- as.factor(mydata$kind)
  mydata$hibou_time_median <- as.double(mydata$hibou_time_median)
  mydata$trace_length <- as.integer(mydata$trace_length)
  mydata
}
# ==============================================


# ==============================================
geom_ptsize = 1
geom_stroke = 1
geom_shape = 19
# ===
draw_scatter_splot <- function(report_data,plot_title,is_log_scale,has_jitter) {
  g <- ggplot(report_data, aes(x=trace_length, y=hibou_time_median, color=kind))
  # 
  if (is_log_scale) {
    g <- g + scale_y_continuous(trans='log10')
    #+ scale_x_continuous(trans='log10')
    plot_title <- paste(plot_title, "(log scale)", sep=" ")
  }
  #
  if (has_jitter) {
    g <- g + geom_point(size = geom_ptsize, 
                      stroke = geom_stroke, 
                      shape = geom_shape,
                      position = position_jitter(w = 0.5, h = 0)) 
    plot_title <- paste(plot_title, "(horizontal jitter)", sep=" ")
  } else {
    g <- g + geom_point(size = geom_ptsize, 
                        stroke = geom_stroke, 
                        shape = geom_shape) 
  }
  #
  g <- g + labs(colour = "kind", x = "length", y = "hibou time") +
    ggtitle(plot_title) +
    theme(plot.title = element_text(margin = margin(b = -25)),
          axis.title.x = element_text(margin = margin(t = 5)),
          axis.title.y = element_text(margin = margin(r = 5))) +
    scale_color_manual(values=c("ACPT" = "blue", "PREF" = "green", "NOIS" = "red", "SACT" = "orange", "SCMP" = "purple"))
  #
  g
}
# ==============================================


# ==============================================
treat_benchmark_data <- function(file_path,benchmark_name,is_log_scale,has_jitter) {
  print("")
  print(benchmark_name)

  bench_data <- read_ana_report(file_path)
  bench_data <- prepare_ana_data(bench_data)

  print("time")
  print(summary(bench_data$hibou_time_median))
  print(sd(bench_data$hibou_time_median))
  print("")
  
  bench_plot <- draw_scatter_splot(bench_data,benchmark_name,is_log_scale,has_jitter)
  
  plot_file_name <- paste(gsub(" ", "_", benchmark_name), "png", sep=".")
  
  ggsave(plot_file_name, bench_plot, width = 2000, height = 1500, units = "px")
}
# ==============================================


treat_benchmark_data("./coping.csv","Book Order",FALSE,TRUE)
treat_benchmark_data("./abp.csv","ABP",TRUE,TRUE)
treat_benchmark_data("./network.csv","Network",TRUE,TRUE)
treat_benchmark_data("./sensor.csv","Sensor",TRUE,TRUE)





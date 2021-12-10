# Imports
options(warn=-1)
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(gplots))
shhh(library(tidyverse))
library(qgraph)
library("RColorBrewer")
options(warn=0)

# Apartado a
# http://cardsorting.net/tutorials/25.csv
data <- read.csv(url("http://cardsorting.net/tutorials/25.csv"))
data <- data.frame(data)

# Apartado b
data <- data[, -c(1:6)]# delete columns 1 through 6
data <- data[,-ncol(data)]

# Apartado c
hist(as.numeric(unlist(data)), labels=c(0,1), main='Frecuencia de respuestas')

# Apartado d
distances = dist(t(data), method="euclidean")
heatmap.2(as.matrix(distances), trace="none", dendrogram ="row")

# Apartado e
qgraph(1/distances, layout='spring', vsize=3, theme='Hollywood')

# Apartado f
# Obtenemos las tarjetas más relacionadas entre sí
min_distance <- min(distances)
cat("Min distance between cards:", min_distance, "\n")

cat("Cards with higher similarity:\n")
min_indexes <- which(as.matrix(distances)==min_distance, arr.ind=TRUE)

names = colnames(data)
correlated_pairs <- data.frame(Item1=character(), Item2=character()) 
for (row in 1:nrow(min_indexes)) {
  new_row <- data.frame(names[min_indexes[row, "row"]],
                        names[min_indexes[row, "col"]])
  names(new_row) <- c("Item1", "Item2")
  
  correlated_pairs <- rbind(correlated_pairs, new_row)
}
correlated_pairs
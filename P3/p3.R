# Imports
options(warn=-1)
# Silent annoying warnings
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(gplots))
shhh(library(tidyverse))
library(qgraph)
library("RColorBrewer")
options(warn=0)

# Apartado a
# http://cardsorting.net/tutorials/25.csv

# Lectura de los datos, introducci�n en dataframe.
data <- read.csv(url("http://cardsorting.net/tutorials/25.csv"))
data <- data.frame(data)

# Apartado b

# Eliminaci�n de columnas 1 a 6, que es donde est�n las variables no interesantes
data <- data[, -c(1:6)]# delete columns 1 through 6
data <- data[,-ncol(data)]

# Apartado c

# Dibujamos el histograma, convirtiendo los datos a numeric para que la funci�n
# hist los acepte como par�metro
hist(as.numeric(unlist(data)), labels=c(0,1), xlab='Valores tomados',
     main='Frecuencia de respuestas')

# Apartado d

# Calculamos las distancias usando la distancia eucl�dea
distances = dist(t(data), method="euclidean")
# Dibujamos el histograma usando el dendograma en las filas
heatmap.2(as.matrix(distances), trace="none", dendrogram ="row")

# Apartado e

# Usamos Qgraph para representar el gr�fico de relaciones usando la funci�n de similitud: 
# 1/distancia
qgraph(1/distances, layout='spring', vsize=3, theme='Hollywood')

# Apartado f
# Obtenemos las tarjetas m�s relacionadas entre s�
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

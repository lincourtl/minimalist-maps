# Creating minimalist maps
# As detailed by Arthur Charpentier
# See: http://freakonometrics.hypotheses.org/20241

# A couple of helper functions
# Create dir_name if it doesn't already exist
make_directory.maybe <- function(dir_name) {
  working_dir <- getwd()
  the_path <- file.path(working_dir,dir_name)
  if (!dir.exists(the_path)) {
    invisible(dir.create(the_path))
    print("The directory was created.")
  } else {
    print("That directory already exists.")
  }
}

# Download data_url to data_path. 
# If file already exists, redownload it only if refetch=TRUE
download.maybe <- function(data_url, data_path, refetch) {
  dest <- file.path(data_path, basename(data_url))
  if (refetch || !file.exists(dest))
    invisible(download.file(data_url, dest))
  dest
}

# Create directories for our data and images if necessary
working_dir <- getwd()
data_dir <- "data"
image_dir <- "images"
airports_dir <- "airports"
airports_data_dir <- paste(data_dir, airports_dir, sep="/")
make_directory.maybe(data_dir)
make_directory.maybe(image_dir)
make_directory.maybe(airports_data_dir)

# Plot all world cities as points
library(maps)
data("world.cities")
plot(world.cities$lon, world.cities$lat,
     pch=19, cex=.7, axes=FALSE, xlab="", ylab="")

# Plot only the major cities
# Where a major city has population > 100,000
data("world.cities")
major.cities <- world.cities[world.cities$pop>100000,]
plot(major.cities$lon, major.cities$lat,
     pch=19, cex=.7, axes=FALSE, xlab="", ylab="")

# Download and unzip airport data if needed
# Yeah, that's really the URL to the data. Something's up with that site's config 
airports_data_url <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_airports.zip"
airports_zipdata <- paste(airports_data_dir,basename(airports_data_url),sep="/")
airports_shape_file <- paste(airports_data_dir, "ne_10m_airports.shp", sep="/")
download.maybe(airports_data_url,airports_data_dir, FALSE)
unzip(airports_zipdata, ex=airports_data_dir, list=FALSE, overwrite=FALSE)

# Plot airports
library(maptools)
shape <- readShapePoints(airports_shape_file)
plot(shape, pch=19, cex=.7)

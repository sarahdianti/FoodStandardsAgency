# Following code is to web-scrape and download files 
# from Food Standards Agency website (FRHS data)

# Download required packages

# For scrape information from web pages
library(rvest) 

# Working with XML and HTML from R
library(xml2)

# Structure sequence of data
library(magrittr)

# For downloading the file into internal storage
library(downloader)

# Save link where FRHS data located into an object
url_path_data <- "https://data.food.gov.uk/catalog/datasets/38dd8d6a-5ab1-4f50-b753-ab33288e3200"

# Read contents from the link
url_page_source <- read_html(url_path_data)

# Scrape the download link for every city
url_to_download <- url_page_source %>%
  html_nodes(".o-dataset-distribution--link") %>%
  html_attr("href")  

# Delete the first line (not one of city's link)
url_to_download <- url_to_download[-1]

# Scrape the city name
data_titles <- url_page_source %>%
  html_nodes("h2") %>%
  html_text() %>%
  trimws(.) 

# Delete the first four lines 
data_titles <- data_titles[-(1:4)]

# Create a data frame consisting the city name and its download link
my_urls_download <- data.frame(
  title = data_titles,
  urls = url_to_download
)  

# Format data into characters
my_urls_download$title <- as.character(my_urls_download$title)
my_urls_download$urls <- as.character(my_urls_download$urls)

# Create a folder to place the downloaded files
dir.create("xml_files")

# Download all XML files through link for every row (city)
for (url_index in 1:nrow(my_urls_download)) {
  url_here <- my_urls_download$urls[url_index]
  filename_vector <- strsplit(my_urls_download$urls[url_index],split="/")[[1]]
  filename <- filename_vector[length(filename_vector)]
  download.file(url_here,paste0("xml_files/",filename))
}

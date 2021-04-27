library(rvest)
library(dplyr)
library("writexl")

get_authors = function(article_link) {
  article_page = read_html(article_link)
  article_authors = article_page %>% html_nodes("tr:nth-child(2) .metadataFieldValue a") %>% html_text() %>% paste(collapse = "; ")

  return(article_authors)
}

get_keywords = function(article_link) {
  article_page = read_html(article_link)
  article_keywords = article_page %>% html_nodes("tr:nth-child(3) .metadataFieldValue") %>% html_text() %>% paste(collapse = "; ")
  return(article_keywords)
}
get_year = function(article_link) {
  article_page = read_html(article_link)
  article_date = article_page %>% html_nodes("tr:nth-child(4) .metadataFieldValue") %>% html_text()
  
  #cut date string to year
  article_year <- str_sub(article_date, start= -4)
  return(article_year)
}
get_title = function(article_link) {
  article_page = read_html(article_link)
  article_date = article_page %>% html_nodes("tr:nth-child(1) .metadataFieldValue") %>% html_text()
  
}
bibliography = data.frame()
  #set loop to iterate over issues
  for (iss in seq(from = 60334, to = 60346, by = 1)) {

  article_link=paste0("https://scholarspace.manoa.hawaii.edu/handle/10125/", iss) 
    
  page = read_html(link)
    
    title = sapply(article_link, FUN = get_title)
    authors = sapply(article_link, FUN = get_authors)
    keywords = sapply(article_link, FUN = get_keywords)
    year = sapply(article_link, FUN = get_year)

    bibliography = rbind(bibliography, data.frame(title, year, keywords, authors))
  }

View(bibliography)

write_xlsx(bibliography, "ScrapeData.xlsx")
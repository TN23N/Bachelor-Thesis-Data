library(rvest)
library(dplyr)
library("writexl")

get_authors = function(article_link) {
  article_page = read_html(article_link)
  article_authors = article_page %>% html_nodes(".contrib-search") %>% html_text() %>% paste(collapse = ";")
  article_authors <- substr(article_authors,2,99)
  article_authors <- gsub("  ",", ",article_authors)
  return(article_authors)
}

get_authorAffiliation = function(article_link) {
  article_page = read_html(article_link)
  article_authorAffiliation = article_page %>% html_nodes(".intent_contributor") %>% html_text() %>% paste(collapse = "; [")
  #reduce noise
  article_authorAffiliation <- gsub("\n ","",article_authorAffiliation)
  article_authorAffiliation <- gsub("           ","] ",article_authorAffiliation)
  article_authorAffiliation <- gsub("       ","",article_authorAffiliation)
  article_authorAffiliation <- paste0("[", article_authorAffiliation)
  article_authorAffiliation <- gsub("\\)|\\(","",article_authorAffiliation)
  article_authorAffiliation <- gsub("  ",", ",article_authorAffiliation)
  return(article_authorAffiliation)
}

get_keywords = function(article_link) {
  article_page = read_html(article_link)
  article_keywords = article_page %>% html_nodes(".intent_text") %>% html_text() %>% paste(collapse = "; ")
  return(article_keywords)
}
get_year = function(article_link) {
  article_page = read_html(article_link)
  article_date = article_page %>% html_nodes(".intent_journal_publication_date") %>% html_text()
  
  #cut date string to year
  article_date_cut <- substr(article_date,19,50)
  article_year <- substrRight(article_date_cut, 4)
  return(article_year)
}

bibliography = data.frame()

  #enter selected journal issn
  issn = "1367-3270"
  #enter selected volume
  vol = 22
  #set loop to iterate over issues
  for (iss in seq(from = 2, to = 3, by = 1)) {

    link=paste0("https://www.emerald.com/insight/publication/issn/", issn,"/vol/", vol,"/iss/",iss) 
    
  page = read_html(link)
    
    title = page %>% html_nodes(".font-serif a") %>% html_text()
    article_link = page %>% html_nodes(".font-serif a") %>%
    html_attr("href") %>% paste("https://www.emerald.com", ., sep="")
    
    authors = sapply(article_link, FUN = get_authors)
    keywords = sapply(article_link, FUN = get_keywords)
    year = sapply(article_link, FUN = get_year)
    authorAffiliation = sapply(article_link, FUN = get_authorAffiliation)

    bibliography = rbind(bibliography, data.frame(title, year, keywords, authors, authorAffiliation))
  }

View(bibliography)

write_xlsx(bibliography, "ScrapeData.xlsx")
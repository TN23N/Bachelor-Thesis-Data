library(rvest)
library(dplyr)
library("writexl")
library(stringr)


get_authorAffiliation = function(article_link) {
  article_page = read_html(article_link)
  article_authorAffiliation = article_page %>% html_nodes(".xmlReaderAffiliates") %>% html_text() %>% paste(collapse = "; ")
  
  return(article_authorAffiliation)
}

get_keywords = function(article_link) {
  article_page = read_html(article_link)
  article_keywords = article_page %>% html_nodes(".xmlReaderAbstract+ .xmlReaderAbstract") %>% html_text() %>% paste(collapse = "; ")
  return(article_keywords)
}
get_title = function(article_link) {
  article_page = read_html(article_link)
  title = article_page %>% html_nodes("h1") %>% html_text() %>% paste(collapse = "; ")
  return(title)
}

bibliography = data.frame()

  #set loop to iterate over issues
  for (issueid in seq(from = 200321, to = 200324, by = 1)) {
    
  link=paste0("https://www.igi-global.com/gateway/issue/",issueid)
  page = read_html(link)
      
      article_idl =  article_link = page %>% html_nodes("#detailsNoClick") %>%
      html_attr("href") %>% paste()
      article_id <- str_sub(article_idl, start= -6)
      article_link = paste("https://www.igi-global.com/gateway/article/full-text-html/", article_id, sep="")
      
    authors = sapply(article_link, FUN = get_authors)
    keywords = sapply(article_link, FUN = get_keywords)
    title = sapply(article_link, FUN = get_title)
    authorAffiliation = sapply(article_link, FUN = get_authorAffiliation)

    bibliography = rbind(bibliography, data.frame(title, keywords, authorAffiliation))
  }

View(bibliography)

write_xlsx(bibliography, "ScrapeData.xlsx")
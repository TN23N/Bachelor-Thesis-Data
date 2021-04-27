library(rvest)
library(dplyr)
library("writexl")

get_authors = function(article_link) {
  article_page = read_html(article_link)
  article_authors = article_page %>% html_nodes(".author-name") %>% html_text() %>% paste(collapse = "; ")
  return(article_authors)
}

bibliography = data.frame()

 #enter selected volume
 vol = 26
 year = 2019
 #set loop to iterate over issues
 for (iss in seq(from = 1, to = 4, by = 1)) {

 link=paste0("https://onlinelibrary.wiley.com/toc/10991441/", year, "/", vol,"/",iss) 
    
    page = read_html(link)
    title = page %>% html_nodes(".visitable h2") %>% html_text()
    article_link = page %>% html_nodes(".loa-authors-trunc~ .content-item-format-links li:nth-child(2) a") %>%
    html_attr("href") %>% paste("https://onlinelibrary.wiley.com", ., sep="")
    
    authors = sapply(article_link, FUN = get_authors)
    
    title<-title[2:length(title)]

    bibliography = rbind(bibliography, data.frame(title, authors, year, vol))
  }

View(bibliography)

write_xlsx(bibliography, "ScrapeData.xlsx")
# code not optimized

# returns summarized data filtered by keywords search, with option to aggregate words rather than phrases
dat_processing <- function(data, single_word = TRUE, filter_yr = TRUE){
  #  jahre <- seq(1990, 2020, 1)
  #  gemeinde <- read.csv("municipalities.csv") %>% data.frame() %>% pull(Name) %>% tolower()
  #  delete_words <-c("kanton", "schweiz", "zürich", "zh", "winterthur",  "deutsch", "stadt", jahre, gemeinde)
  #  domains <- data %>% dplyr::select(top_domain) %>% distinct()
  if (filter_yr){
    data <- data %>% filter(time == "Jahr")
  }
  
  if (single_word){
    out <- data %>% 
      unnest_tokens(word, Suchanfragen, token = "words", to_lower = T, drop = F) %>% 
      #    filter(! word %in% delete_words) %>% 
      anti_join(get_stopwords(language = "en")) %>%
      anti_join(get_stopwords(language = "de")) %>%
      anti_join(get_stopwords(language = "fr")) %>%
      group_by(top_domain, word) %>% 
      summarise(n = n(),
                klicks = sum(Klicks),
                impressions = sum(Impressionen)) %>% 
      ungroup %>% 
      group_by(word) %>% 
      mutate(sum_impressions = sum(impressions)) %>%
      mutate(count_domains = row_number()) %>% 
      mutate(max_domains = max(count_domains)) %>% 
      ungroup() 
  } else {
    out <- data %>%
      select(word = Suchanfragen, klicks = Klicks, impressions = Impressionen, top_domain)
  }
  return(out)
}

# returns top <length> impressions filtered by <domains> 
domain_filter <- function(data, domains, length = 15, filter_yr = TRUE){
  if (filter_yr){
    data <- data %>% filter(time == "Jahr")
  }
  out <- data %>% 
    filter(top_domain %in% domains) %>% 
    top_n(length, Impressionen) %>%
    select(klicks = Klicks, word = Suchanfragen, impressions = Impressionen, top_domain)
  return(out)
}

# make a sankey plot based on filtered data
zhweb <- function(data, title = NULL){
 
  column1 <- unique(sort(data$word))
  column2 <- unique(sort(data$top_domain))
  
  data$domain_id <- as.numeric(as.factor(data$top_domain)) + length(column1) - 1
  data$word_id <- as.numeric(as.factor(data$word)) - 1

  
  p <- plot_ly(
    type = "sankey",
    orientation = "h",
    node = list(
      label = c(column1, column2),
      color = c(rep("lightgreen", length(column1)), rep("#009ee0", length(column2))),
      pad = 15,
      thickness = 10,
      line = list(
        color = "white",
        width = 0.5
      )
    ),
    
    link = list(
      source = rep(data$word_id, 2),
      target = rep(data$domain_id,2),
      value = c(data$impressions - data$klicks, data$klicks),
      color = c(rep(rgb(253, 227, 212, 255, maxColorValue = 255), nrow(data)), 
                rep("orange", nrow(data)))
    )
  ) %>%
    layout(
      title = title, font = list(size = 12)
    )
  
  return(p)
}

# examples
# zhweb(domain_filter(dat, c("zh.ch","ji.zh.ch"), filter_yr = F))
# zhweb(dat_processing(dat[dat$Suchanfragen %in% c("gis zh","gis", "gis zürich"),], single_word = F, filter_yr = T))

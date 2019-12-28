#---------------------------------------------------------------------#
#               Assignment AMPBA Batch 13                             #
#---------------------------------------------------------------------#

library("shiny")
#Loading necessary files
library(udpipe)
library(lattice)
library(wordcloud)
library(RColorBrewer)
library(sentimentr)
library(dplyr)
library(ggplot2) # for plotting
library(tidytext) # for analyzing text in tidy manner
library(wordcloud)
library(tidyr)

options(shiny.maxRequestSize=30*1024^2)


# Define Server function
shinyServer(function(input, output) {
  
  Dataset <- reactive({
    if (is.null(input$file)) { return(NULL) }
    else{
      reviews_df <- as.data.frame(read.csv(input$file$datapath,stringsAsFactors = FALSE))
      
      english_model = udpipe_load_model(input$file1$datapath)
      
      df1 <- as.data.frame(udpipe_annotate(english_model, x = reviews_df$Reviewer.Comment,parser = "none",trace = FALSE))[,c(4,6)]
      
      df1$token <- tolower(df1$token)
      df1$token_final <- 'NA'
      
    
       feat_list <- as.list(strsplit(input$searchInput, ",")[[1]])
       feature_list <- tolower(feat_list)
      
      
      for (feature in feature_list){
        df1$token_final <- ifelse(grepl(feature,df1$token),feature,df1$token_final)
      }
      
      df2 <- unique(df1$sentence[df1$token_final != 'NA'])
      return(df2)
      
    }
  })
  
  
  Dataset1 <- reactive({
    if (is.null(input$file)) { return(NULL) }
    else{
      
      reviews_df <- as.data.frame(read.csv(input$file$datapath,stringsAsFactors = FALSE))
      english_model = udpipe_load_model(input$file1$datapath)
      
      df1 <- as.data.frame(udpipe_annotate(english_model, x = reviews_df$Reviewer.Comment,parser = "none",trace = FALSE))[,c(4,6)]
      
      df1$token <- tolower(df1$token)
      df1$token_final <- 'NA'
      
      
      feat_list <- as.list(strsplit(input$searchInput, ",")[[1]])
      feature_list <- tolower(feat_list)
      
      
      for (feature in feature_list){
        feature <- stringr::str_replace_all(feature,"[\\s]+", "")
        df1$token_final <- ifelse(grepl(feature,df1$token),feature,df1$token_final)
      }
      
      return(df1)
      
    }
  })
  
  
  
  
  
  output$plot1 = renderPlot({ 
    df1 <- Dataset1()
    df4 <- df1 %>%
      count(token_final, sort = TRUE)%>%
      filter(token_final != 'NA')%>%   # n is wordcount colname.
      mutate(token_final = reorder(token_final, n))
    
      df4$n<-df4$n/sum(df4$n)
    
      df4 %>% 
        ggplot(aes(token_final, n)) +
        geom_bar(stat = "identity", col = "red", fill = "red") +
        xlab('Key Words') + ylab('relative frequency') +
        coord_flip()
    
    })
  

  output$wordcloud1 = renderPlot({
       df1 <- Dataset1()
       df4 <- df1 %>%
              count(token_final, sort = TRUE)%>%
              filter(token_final != 'NA')%>%   # n is wordcount colname.
              mutate(token_final = reorder(token_final, n))
       
       df4$n<-df4$n/sum(df4$n)
       pal <- brewer.pal(8,"Dark2")
       
       df4 %>%
         with(wordcloud(token_final, n,scale = c(3.5, 0.25), random.order = FALSE, max.words = 50, colors=pal))
       
       
  })
  
  output$comments = renderPrint({
    comments <- Dataset()
    comments
  })
  
})

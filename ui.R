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

# Define ui function
 shinyUI(
  fluidPage(
    
    titlePanel("Car Review Analysis"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload data (xls file with review along with header)"),
        
        fileInput("file1", "Upload UDPIPE file for the NLP"),
        
        textInput('searchInput', 'key words to be searched in the reviews'),
        
        submitButton(text = "Apply Changes", icon("refresh"))
        
        
        ),   # end of sidebar panel

      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only xls file (.xls) data file. xls data file should have headers and the first row of the file should have column names.",align="justify"),
                             p("Please refer to the link below for sample xls file."),
                             a(href="https://github.com/Pundareek/pundareek/blob/master/Kia%20Seltos_Review.csv"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload data (xls file with header)")),
                               'and upload the review  data file. Also pass the comma seperated unigrams that need to be searched in the reviews.')),
                    tabPanel("Bar plot", 
                             plotOutput('plot1')),
                    
                    tabPanel("Word Cloud",
                             plotOutput('wordcloud1')),
                    
                    tabPanel("Sentences with  Keywords",
                             verbatimTextOutput('comments'))
                
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI

# requiredPackages= c("psych", "scran", "shiny", "shinyTree", "plotly", "shinythemes", "ggplot2", "DT",
#                     "pheatmap", "shinyjqui","threejs", "sm", "RColorBrewer", "mclust", "reshape",  "knitr", "kableExtra", "shinyWidgets", "scater", "biomaRt", "devtools", "dplyr", "edgeR", "gplots", "shinydashboard", "stringi", "svglite")
# install.packages(c("rafalib", "shinydashboard", "shinyBS", "shinythemes", "Rfast", "shinycssloaders", "pryr", "scran"))
# rafalib::install_bioc(requiredPackages)
# devtools::install_github("mul118/shinyMCE")
# devtools::install_github("jlmelville/uwot")
#You need to download Rtools to compile uwot
# devtools::install_github("daattali/colourpicker")
# BiocManager::install("TRONCO")
# install.packages("sm")

#https://doi.org/10.1101/123810 data is used in tutorial
#preformatted RData/Rds files are required to input 

library(shiny)
library(data.table)
library(tidyr)
# library(reactlog)
library(shinyTree)
library(tibble)
library(shinyBS)
library(plotly)
library(shinythemes)
library(ggplot2)
library(shinyBS)
# library(plotly)
library(DT)
library(edgeR)


# runExample("02_text")

#setwd("E:/YJ/1GIBH/CJK/projects/interactive Shiny R/yj")
f <- read.csv("scTE interactive surface/TE.layout.csv",header = T)
write.csv(f[1:1000,],file='scTE interactive surface/testlayout.csv',quote=T)

ui <- shinyUI(pageWithSidebar(
  headerPanel("Interactive Visualization scRNA-seq analysis"),
  
  sidebarPanel(
    fileInput("layout",label ="tSNE/UMAP layout",multiple = FALSE,
              placeholder = "tSNE layout file",
              accept = c("text/csv","text/comma-seperated-values,text/pain",".csv")),
    # fileInput("expr",label ="Gene Expression Table:",multiple =FALSE, 
    #           placeholder = "expression data",
    #           accept = c("text/csv","text/comma-seperated-values,text/pain",".csv")),
    # 
    selectInput("species","choose a species:",
                choices = c("Mus musculus","human")),
    textInput("gene","Gene Name:",value = "RLTR13G")
    # selectInput("gene list","choose select gene name:",
                # choices = names(layout))# I still need to explore how to select all the gene names to faciliate the input gene name
    
  ),
  
  mainPanel(
    h3(textOutput("Interactive Visualization")),
    
    plotOutput("global"),
    br(),
    
    verbatimTextOutput("gene"),
    br(),
    tableOutput("contents")
    
  )
  
))


server<- shinyServer(function(input,output){
  
  output$contents <- renderTable({
    inFile <- input$layout
    if(is.null(inFile))
      return("Please input files!")
    
    scatter_expr<-read.table(inFile$datapath,sep=',',header = T)
    return(colnames(scatter_expr))
    
  })
  
  
  output$gene <- renderText({
    input$gene
  })
  
  output$global <- renderPlot({
    inFile <- input$layout
    if (is.null(inFile)) 
      return("please input files")
    
    scatter_expr<-read.table(inFile$datapath,sep=',',header = T)
    p <- ggplot(scatter_expr,aes(Dim.1,Dim.2))+geom_point()
      
    
    if (input$gene!='None') 
      p <- p + aes_string(color=input$gene)+
      scale_color_gradient2(low='#2020FF',mid="white",high='#FF1B1B')+#,limits=c(-1,0.5)
      theme_bw()+
      theme(panel.grid=element_blank())#,panel.border=element_blank()
    
    return(p)
  })
  
})


shinyApp(ui,server)

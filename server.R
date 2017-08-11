  shinyServer(function(input, output, session) {  

  
  
  
 library(dplyr)
  library(ggplot2)
 
  iris_sample <- data.frame(Inflation= numeric(0), Pes= numeric(0))
  row.names(iris_sample) <- NULL
  
  # The important part of reactiveValues()
  values <- reactiveValues()
  values$df <- iris_sample
  
  
  addData <- observe({
    
    # your action button condition
    if(input$addButton > 0) {
      # create the new line to be added from your inputs
      newLine <- isolate(c(input$InflationAmount, input$Pes))
      # update your data
      # note the unlist of newLine, this prevents a bothersome warning message that the rbind will return regarding rownames because of using isolate.
      isolate(values$df <- rbind(as.matrix(values$df), unlist(newLine)))
      
    }
  })
  

  newData <- reactive({
   data <- as.data.frame(values$df) %>%
     mutate(deltaPes = lead(Pes) - lag(Pes))
   
  })
  
  

 
    


  
  


  ({
  output$table <- renderTable({newData()}, include.rownames=F)
})


    
  
 
  
  
  dataSummary1 <- reactive({ newData() %>%
      mutate(mediandeltaPes = quantile(deltaPes, probs = 0.50, na.rm = TRUE)) %>%
      filter(deltaPes <= mediandeltaPes) %>%
      filter(Inflation == min(Inflation))
  })
  
  
  
  
  output$summary1 <- renderPrint({ print("Optimal Filling Volume:"); dataSummary1()$Inflation
  })
  
  output$summary2 <- renderPrint({ print("Corresponding Pes:"); dataSummary1()$Pes
  })
  
  
  

  
  output$plot1 <- renderPlot({
    ggplot(newData(), aes(Inflation, Pes)) + geom_point() + geom_line() +
      geom_vline(data = dataSummary1() , aes(xintercept = Inflation)) +
      theme_bw()
  })
  
  
  
  

  



  
})
server <- function(input, output, session) {
  output$avg_age <- renderValueBox({
    valueBox(ceiling(mean(survival::lung$age)),"Average Age",icon=icon('list'),color="light-blue")
  })
  output$avg_time <- renderValueBox({
    valueBox(ceiling(mean(survival::lung$time)),"Average Time",icon=icon('calendar'),color="orange")
  })
  output$total_pat <- renderValueBox({
    valueBox(nrow(survival::lung),"Total Row",icon=icon('file'),color="olive")
  })
  output$correlationPlot <- renderPlotly({
    density_plot <- ggplot(survival::lung, aes(x = time, y = .data[[input$feature]])) +
      geom_density_2d() +
      geom_point(color='blue',alpha = 0.5) +
      scale_color_gradient(low = "blue", high = "green") +
      labs(title = "Density Contour Plot of Time vs Feature", x = "Time", y = input$feature)
    ggplotly(density_plot)
  })
  
  
  output$survival_plot_full <- renderPlot({
    # Fit Cox proportional hazards model for full dataset
    fit <- survfit(Surv(time, status) ~ 1, data = survival::lung)
    
    # Plot survival curves for full dataset
    ggsurvplot(fit, data = survival::lung, risk.table = TRUE,
               xlab = "Time", ylab = "Survival Probability",
               surv.median.line = "hv",
               legend.title = "Sex", legend.labs = "All")
  })
  
  df<- survival::lung
  df <- reactive({
    if (input$variable == "age") {
      age_range <- seq(0, max(survival::lung$age), by = 10)
      df <- survival::lung[survival::lung$age %in% age_range, ]
    } else {
      df <- survival::lung
    }
    return(df)
  })
  output$survival_plot <- renderPlot({
    if(input$variable=='sex'){
      # Fit Cox proportional hazards model
      fit <- survfit(Surv(time, status) ~ sex, data = df())
      
      # Plot survival curves
      ggsurvplot(fit, data = df(), risk.table = TRUE,
                 xlab = "Time", ylab = "Survival Probability",
                 surv.median.line = "hv",
                 legend.title = input$variable, 
                 legend.labs = levels(factor(df()[[input$variable]])[1:2]))
    }
    else if (input$variable == 'ph.ecog') {
      # Fit Cox proportional hazards model for ph.ecog
      fit <- survfit(Surv(time, status) ~ ph.ecog, data = df())
      
      # Plot survival curves for ph.ecog
      ggsurvplot(fit, data = df(), risk.table = TRUE,
                 xlab = "Time", ylab = "Survival Probability",
                 surv.median.line = 'hv',
                 legend.title = input$variable, 
                 legend.labs = levels(factor(df()[[input$variable]])))
    }
    else{
      fit <- survfit(Surv(time, status) ~ age, data = df())
      
      # Plot survival curves
      ggsurvplot(fit, data = df(), risk.table = TRUE,
                 xlab = "Time", ylab = "Survival Probability",
                 surv.median.line = 'hv',
                 legend.title = input$variable, 
                 legend.labs = levels(df()[[input$variable]][1:2]))
    }
    
  })
  
}
#ggsurvplot(fit, data = df(), risk.table = TRUE,
#           xlab = "Time", ylab = "Survival Probability",
#          legend.title = input$variable, 
#           legend.labs = unique(df()[[input$variable]])[1:2])

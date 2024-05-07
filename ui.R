library(shiny)
library(bslib)
library(shinydashboard)
library(plotly)
library(survival)
library(survminer)
library(DT)
ui<-dashboardPage(
  dashboardHeader(title='LUNG CANCER'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Correlation",tabName = "correlation"),
      menuItem("Survival",tabName = "full_surv"),
      menuItem("Survival | Category",tabName = "sur_an")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("correlation",
              fluidRow(
                fillRow(
                  box(
                    width=12,
                    height = "100%",
                    title="CORRELATION",
                    status = "primary",
                    selectInput("feature","Features",
                                c("inst","age","meal.cal","wt.loss"
                                )),
                    plotlyOutput("correlationPlot",height = 550)
                  )
                )
              )
      ),
      tabItem("full_surv",
              fluidRow(
                valueBoxOutput("avg_age"),
                valueBoxOutput("avg_time"),
                valueBoxOutput('total_pat')
              ),
              fluidRow(
                box(
                  width = 12,
                  height = "100%",
                  title = "SURVIVAL ANALYSIS PLOT",
                  status = "primary",
                  plotOutput("survival_plot_full",height = 500)
                )
              )
      ),
      tabItem("sur_an",
              fluidRow(
                fillRow(
                  box(
                    width = 12,
                    height = "100%",
                    title = "SURVIVAL ANALYSIS PLOT (CATEGORY-WISE)",
                    status = "primary",
                    selectInput("variable", "Variable",
                                c("sex", "ph.ecog", "age")),
                    plotOutput("survival_plot",height = 540)
                  )
                )))
    )
    
  )
  
)


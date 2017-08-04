ui = fluidPage(
  headerPanel('Esophageal Balloon Inflation App'),
  sidebarPanel(
    numericInput("InflationAmount", label="Add a new Balloon Inflation Amount", value=""),
    numericInput("Pes", label="Add the correspondig Pes value at end exhalation", value=""),
    actionButton("addButton", "upload")
  ),
  mainPanel(
    tableOutput("table"),
    plotOutput("plot1"),
  verbatimTextOutput("summary1"),
  verbatimTextOutput("summary2")
  )
)
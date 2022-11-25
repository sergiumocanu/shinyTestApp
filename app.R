library(shinydashboard)

# Use the module in an application
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(

    manageData::manageData_UI("manage1")
  )

)
server <- function(input, output, session) {

  testMAE <- reactive({readRDS(gDRtestData::get_test_dataset_paths()["combo_1dose_many_drugs"])})
  assayNormalized <- reactive({gDRutils::convert_mae_assay_to_dt(testMAE(), "Normalized", include_metadata = TRUE, retain_nested_rownames = FALSE)})
  assayAveraged <- reactive({gDRutils::convert_mae_assay_to_dt(testMAE(), "Averaged", include_metadata = TRUE, retain_nested_rownames = FALSE)})
  assayMetrics <- reactive({gDRutils::convert_mae_assay_to_dt(testMAE(), "Metrics", include_metadata = TRUE, retain_nested_rownames = FALSE)})
  assayObjects <- reactive({
    list(
      normalized = assayNormalized(),
      averaged = assayAveraged(),
      metrics = assayMetrics(),
      metrics_raw = assayMetrics()
    )
  })

  rv <- reactiveValues()
  rv$assay_object_manage_data <- reactive({
    browser()
    list(
      `single-agent` = assayObjects()
    )
  })
  rv$pidfs <- reactive({
    gDRutils::get_prettified_identifiers()
  })
  rv$vars_wish_list = c("drug_name2", "duration", "data_source")
  rv$fit_source = "gDR"

  manageData::manageData_SERVER("manage1", rv = rv)
}
shinyApp(ui, server)

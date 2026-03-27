# ============================================================
#   DYNAMIC REPORTING TOOL — INDIA EDITION
#   File    : app.R
#   Run     : Open in RStudio and click "Run App"
#   Install : install.packages(c("shiny","ggplot2","dplyr","readr"))
# ============================================================


# --- Load all required packages ---
library(shiny)    # builds the interactive web app
library(ggplot2)  # draws charts and graphs
library(dplyr)    # filters and groups data
library(readr)    # reads CSV files


# ============================================================
#                         UI SECTION
#        Everything the user SEES is defined here
# ============================================================

ui <- fluidPage(
  
  # --- Page title shown in browser tab ---
  title = "India Reporting Tool",
  
  # --- CSS Styling for the whole app ---
  tags$head(
    tags$style(HTML("

      /* Overall page background */
      body {
        background-color : #f0f2f5;
        font-family      : Arial, sans-serif;
      }

      /* Top header bar with Indian flag colors */
      .header-bar {
        background    : linear-gradient(to right, #FF9933, #ffffff, #138808);
        padding       : 15px 20px;
        text-align    : center;
        font-size     : 22px;
        font-weight   : bold;
        color         : #000080;
        border-bottom : 3px solid #000080;
        margin-bottom : 20px;
      }

      /* White card for the sidebar */
      .sidebar-card {
        background    : #ffffff;
        padding       : 20px;
        border-radius : 10px;
        box-shadow    : 0 2px 8px rgba(0,0,0,0.12);
      }

      /* White card for the main output area */
      .main-card {
        background    : #ffffff;
        padding       : 20px;
        border-radius : 10px;
        box-shadow    : 0 2px 8px rgba(0,0,0,0.12);
      }

      /* Summary statistic boxes at the top */
      .stat-box {
        background    : #ffffff;
        border-left   : 5px solid #FF9933;
        padding       : 12px 15px;
        border-radius : 8px;
        margin-bottom : 15px;
        box-shadow    : 0 1px 5px rgba(0,0,0,0.1);
        min-height    : 70px;
      }

      /* Title text inside stat boxes */
      .stat-title {
        font-size   : 13px;
        color       : #888888;
        font-weight : bold;
      }

      /* Value text inside stat boxes */
      .stat-value {
        font-size   : 18px;
        font-weight : bold;
        color       : #000080;
        margin-top  : 4px;
      }

      /* Generate Report button (saffron color) */
      #gen_btn {
        background-color : #FF9933;
        color            : white;
        border           : none;
        width            : 100%;
        padding          : 10px;
        font-size        : 15px;
        font-weight      : bold;
        border-radius    : 6px;
        margin-top       : 10px;
        cursor           : pointer;
      }

      /* Download button (green color) */
      #download_report {
        background-color : #138808;
        color            : white;
        border           : none;
        width            : 100%;
        padding          : 10px;
        font-size        : 14px;
        font-weight      : bold;
        border-radius    : 6px;
        margin-top       : 10px;
        cursor           : pointer;
      }

      /* Style for all table outputs */
      table {
        width       : 100%;
        font-size   : 14px;
        border-collapse : collapse;
      }

      /* Table header row */
      th {
        background-color : #000080;
        color            : white;
        padding          : 8px 10px;
        text-align       : left;
      }

      /* Table data rows alternating colors */
      tr:nth-child(even) { background-color : #f9f9f9; }
      tr:hover           { background-color : #fff3e0; }
      td { padding : 7px 10px; }

    "))
  ),
  
  
  # --- Top Header Bar ---
  div(class = "header-bar",
      "🇮🇳 Dynamic Reporting Tool — India Edition 📊"
  ),
  
  
  # --- Main layout: Sidebar on left, Output on right ---
  sidebarLayout(
    
    # ==================== LEFT SIDEBAR ====================
    sidebarPanel(
      width = 3,  # sidebar takes 3 out of 12 grid columns
      
      div(class = "sidebar-card",  # white card styling
          
          # Sidebar heading
          h4("⚙️ Controls", style = "color:#000080; font-weight:bold;"),
          hr(),
          
          # 1. File upload input
          fileInput(
            inputId     = "file_upload",       # used in server to read this input
            label       = "📁 Upload CSV File", # shown above the button
            accept      = ".csv",              # only allow .csv files
            buttonLabel = "Browse...",         # text on the browse button
            placeholder = "No file selected"  # shown before upload
          ),
          
          hr(),
          
          # 2. Dropdown: choose column to analyze
          selectInput(
            inputId  = "col_select",                    # used in server
            label    = "🔍 Select Column to Analyze",   # label text
            choices  = c("Upload a file first" = ""),   # placeholder until file loaded
            selected = ""                               # nothing selected yet
          ),
          
          # 3. Dropdown: choose a filter value from that column
          selectInput(
            inputId  = "filter_val",                    # used in server
            label    = "🎯 Select Filter Value",        # label text
            choices  = c("Select a column first" = ""), # placeholder
            selected = ""                               # nothing selected yet
          ),
          
          hr(),
          
          # 4. Generate Report button
          actionButton(
            inputId = "gen_btn",            # used in server to detect click
            label   = "📋 Generate Report"  # button text
          ),
          
          br(), br(),
          
          # 5. Download filtered data button
          downloadButton(
            outputId = "download_report",   # used in server
            label    = "⬇️ Download CSV"   # button text
          ),
          
          hr(),
          
          # Info section: what columns are in the sample data
          h5("📌 Sample Data Columns:", style = "color:#000080;"),
          tags$ul(
            tags$li("Name — Employee name"),
            tags$li("Department — Work area"),
            tags$li("Sales_INR — Sales in ₹"),
            tags$li("Month — Month name"),
            tags$li("State — Indian state"),
            tags$li("City — Indian city"),
            tags$li("Gender — Male / Female")
          )
          
      )  # end sidebar-card div
      
    ),  # end sidebarPanel
    
    
    # ==================== RIGHT MAIN PANEL ====================
    mainPanel(
      width = 9,  # main panel takes 9 out of 12 grid columns
      
      div(class = "main-card",  # white card styling
          
          # --- TOP STAT CARDS ROW ---
          fluidRow(
            
            # Stat Card 1: Total rows in dataset
            column(3,
                   div(class = "stat-box",
                       div(class = "stat-title", "👥 Total Records"),
                       div(class = "stat-value", textOutput("stat_total", inline = TRUE))
                   )
            ),
            
            # Stat Card 2: Total sales in rupees
            column(3,
                   div(class = "stat-box",
                       div(class = "stat-title", "💰 Total Sales (₹)"),
                       div(class = "stat-value", textOutput("stat_sales", inline = TRUE))
                   )
            ),
            
            # Stat Card 3: Which state has highest sales
            column(3,
                   div(class = "stat-box",
                       div(class = "stat-title", "🏆 Top State"),
                       div(class = "stat-value", textOutput("stat_state", inline = TRUE))
                   )
            ),
            
            # Stat Card 4: Which department has highest sales
            column(3,
                   div(class = "stat-box",
                       div(class = "stat-title", "🏢 Top Dept"),
                       div(class = "stat-value", textOutput("stat_dept", inline = TRUE))
                   )
            )
            
          ),  # end fluidRow (stat cards)
          
          hr(),
          
          # --- OUTPUT TABS ---
          tabsetPanel(
            type = "tabs",  # normal clickable tab style
            
            # TAB 1: Raw data preview (first 10 rows)
            tabPanel(
              title = "📄 Data Preview",
              br(),
              h5("Showing first 10 rows of uploaded file:"),
              tableOutput("preview_table")  # output defined in server
            ),
            
            # TAB 2: Filtered data table
            tabPanel(
              title = "📋 Filtered Table",
              br(),
              h5("Rows matching your selected filter:"),
              tableOutput("filtered_table")  # output defined in server
            ),
            
            # TAB 3: Bar chart of selected column
            tabPanel(
              title = "📊 Bar Chart",
              br(),
              h5("Bar chart of filtered data by selected column:"),
              plotOutput("bar_chart", height = "460px")  # output defined in server
            ),
            
            # TAB 4: State-wise sales chart (India specific)
            tabPanel(
              title = "🗺️ State-wise Sales",
              br(),
              h5("Total Sales (₹) grouped by Indian State:"),
              plotOutput("state_chart", height = "480px")  # output defined in server
            ),
            
            # TAB 5: Summary statistics text
            tabPanel(
              title = "📈 Summary Stats",
              br(),
              h5("Statistical summary of filtered data:"),
              verbatimTextOutput("summary_stats")  # output defined in server
            )
            
          )  # end tabsetPanel
          
      )  # end main-card div
      
    )  # end mainPanel
    
  )  # end sidebarLayout
  
)  # end fluidPage (ui)


# ============================================================
#                       SERVER SECTION
#      All logic, calculations and outputs are here
# ============================================================

server <- function(input, output, session) {
  
  
  # ----------------------------------------------------------
  #  REACTIVE 1: Read uploaded CSV file into R
  # ----------------------------------------------------------
  uploaded_data <- reactive({
    
    req(input$file_upload)  # stop if no file uploaded yet
    
    # read the uploaded CSV file from its temporary path
    df <- read_csv(
      input$file_upload$datapath,  # Shiny saves uploaded file here
      show_col_types = FALSE       # don't print column type messages
    )
    
    return(df)  # return the data frame
  })
  
  
  # ----------------------------------------------------------
  #  OBSERVER 1: Fill column dropdown when file is uploaded
  # ----------------------------------------------------------
  observeEvent(uploaded_data(), {
    
    # get all column names from the uploaded file
    cols <- names(uploaded_data())
    
    # update the column dropdown with these names
    updateSelectInput(
      session  = session,
      inputId  = "col_select",  # which dropdown to update
      choices  = cols,           # list of column names
      selected = cols[1]         # auto-select the first column
    )
  })
  
  
  # ----------------------------------------------------------
  #  OBSERVER 2: Fill filter dropdown when column is selected
  # ----------------------------------------------------------
  observeEvent(input$col_select, {
    
    req(uploaded_data())  # make sure file is uploaded
    req(input$col_select != "")  # make sure a column is actually selected
    
    # get the column name the user selected
    chosen_col <- input$col_select
    
    # find all unique values in that column and sort them
    vals <- sort(unique(as.character(uploaded_data()[[chosen_col]])))
    
    # update the filter value dropdown with these unique values
    updateSelectInput(
      session  = session,
      inputId  = "filter_val",  # which dropdown to update
      choices  = vals,           # list of unique values
      selected = vals[1]         # auto-select the first value
    )
  })
  
  
  # ----------------------------------------------------------
  #  REACTIVE 2: Filter data only when Generate button clicked
  # ----------------------------------------------------------
  filtered_data <- eventReactive(input$gen_btn, {
    
    req(uploaded_data())      # make sure data is loaded
    req(input$col_select)     # make sure a column is selected
    req(input$filter_val)     # make sure a filter value is selected
    
    df  <- uploaded_data()     # full dataset
    col <- input$col_select    # selected column name
    val <- input$filter_val    # selected filter value
    
    # filter the dataframe: keep rows where column value matches filter
    result <- df[as.character(df[[col]]) == val, ]
    
    return(result)  # return filtered rows
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 1: Total records stat card
  # ----------------------------------------------------------
  output$stat_total <- renderText({
    
    req(uploaded_data())  # only run if data is loaded
    
    # count total rows in the uploaded file
    paste0(nrow(uploaded_data()), " rows")
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 2: Total Sales in ₹ stat card
  # ----------------------------------------------------------
  output$stat_sales <- renderText({
    
    req(uploaded_data())  # only run if data is loaded
    df <- uploaded_data()
    
    # check if Sales_INR column exists in the file
    if ("Sales_INR" %in% names(df)) {
      total <- sum(df$Sales_INR, na.rm = TRUE)  # sum all sales values
      paste0("\u20B9", format(total, big.mark = ","))  # format as ₹1,23,456
    } else {
      "N/A"  # show N/A if column not found
    }
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 3: Top State stat card
  # ----------------------------------------------------------
  output$stat_state <- renderText({
    
    req(uploaded_data())
    df <- uploaded_data()
    
    # only run if both State and Sales_INR columns exist
    if (all(c("State", "Sales_INR") %in% names(df))) {
      
      # group by state, sum sales, pick the top one
      top <- df %>%
        group_by(State) %>%
        summarise(Total = sum(Sales_INR, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(Total)) %>%
        slice(1)
      
      as.character(top$State)  # return top state name
      
    } else {
      "N/A"
    }
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 4: Top Department stat card
  # ----------------------------------------------------------
  output$stat_dept <- renderText({
    
    req(uploaded_data())
    df <- uploaded_data()
    
    if (all(c("Department", "Sales_INR") %in% names(df))) {
      
      top <- df %>%
        group_by(Department) %>%
        summarise(Total = sum(Sales_INR, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(Total)) %>%
        slice(1)
      
      as.character(top$Department)
      
    } else {
      "N/A"
    }
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 5: Raw data preview table (first 10 rows)
  # ----------------------------------------------------------
  output$preview_table <- renderTable({
    
    req(uploaded_data())      # only show if data is loaded
    head(uploaded_data(), 10) # return first 10 rows only
    
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  
  # ----------------------------------------------------------
  #  OUTPUT 6: Filtered data table
  # ----------------------------------------------------------
  output$filtered_table <- renderTable({
    
    req(filtered_data())  # only show after Generate button clicked
    filtered_data()       # return all filtered rows
    
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  
  # ----------------------------------------------------------
  #  OUTPUT 7: Bar Chart of selected column
  # ----------------------------------------------------------
  output$bar_chart <- renderPlot({
    
    req(filtered_data())  # only draw if filtered data exists
    
    df  <- filtered_data()    # get filtered data
    col <- input$col_select   # get selected column name
    
    # count how many rows per unique value in selected column
    chart_df <- df %>%
      group_by(Value = as.character(.data[[col]])) %>%
      summarise(Count = n(), .groups = "drop") %>%
      arrange(desc(Count))
    
    # define Indian tricolor palette
    india_colors <- c("#FF9933", "#138808", "#000080",
                      "#FF6B6B", "#4ECDC4", "#FFD700",
                      "#9B59B6", "#E67E22", "#1ABC9C")
    
    # repeat colors if more bars than colors
    bar_colors <- rep(india_colors, length.out = nrow(chart_df))
    
    # draw the bar chart
    ggplot(chart_df, aes(x = reorder(Value, -Count), y = Count)) +
      geom_bar(
        stat  = "identity",     # use actual Count values
        fill  = bar_colors,     # Indian tricolor fill
        color = "white",        # white border around each bar
        width = 0.65            # width of each bar
      ) +
      geom_text(
        aes(label = Count),     # show count number on top of bar
        vjust    = -0.5,        # position label above bar
        size     = 5,           # label font size
        fontface = "bold",      # bold label
        color    = "#000080"    # navy blue label color
      ) +
      labs(
        title    = paste("Bar Chart of:", col),
        subtitle = paste("Filter Applied:", input$col_select, "=", input$filter_val),
        x        = col,
        y        = "Count",
        caption  = "India Dynamic Reporting Tool"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title      = element_text(face = "bold", hjust = 0.5,
                                       color = "#000080", size = 17),
        plot.subtitle   = element_text(hjust = 0.5, color = "#666666", size = 13),
        plot.caption    = element_text(hjust = 1, color = "#999999"),
        axis.text.x     = element_text(angle = 30, hjust = 1, size = 12),
        axis.text.y     = element_text(size = 12),
        panel.grid.major.x = element_blank(),
        legend.position = "none"
      )
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 8: State-wise Sales Chart (₹ INR)
  # ----------------------------------------------------------
  output$state_chart <- renderPlot({
    
    req(uploaded_data())  # use FULL data (not filtered) for state chart
    df <- uploaded_data()
    
    # check required columns exist
    if (!all(c("State", "Sales_INR") %in% names(df))) {
      # draw empty plot with message if columns missing
      ggplot() +
        annotate("text", x = 0.5, y = 0.5,
                 label = "Columns 'State' and 'Sales_INR' not found in file",
                 size = 6, color = "red") +
        theme_void()
      return()
    }
    
    # group by state and sum sales
    state_df <- df %>%
      group_by(State) %>%
      summarise(Total_Sales = sum(Sales_INR, na.rm = TRUE), .groups = "drop") %>%
      arrange(Total_Sales)  # ascending so highest is at top when flipped
    
    # draw horizontal bar chart
    ggplot(state_df, aes(x = reorder(State, Total_Sales), y = Total_Sales)) +
      geom_bar(
        stat  = "identity",
        fill  = "#FF9933",  # saffron color for all bars
        color = "white",
        width = 0.7
      ) +
      geom_text(
        aes(label = paste0("\u20B9", format(Total_Sales, big.mark = ",", scientific = FALSE))),
        hjust    = -0.08,   # label slightly outside right edge of bar
        size     = 3.8,
        fontface = "bold",
        color    = "#000080"
      ) +
      coord_flip() +  # flip axes so states are on y-axis (easier to read)
      scale_y_continuous(
        expand = expansion(mult = c(0, 0.2)),  # give space for labels
        labels = function(x) paste0("\u20B9", format(x, big.mark = ",", scientific = FALSE))
      ) +
      labs(
        title    = "State-wise Total Sales (\u20B9 INR)",
        subtitle = "All Indian states in the dataset",
        x        = "State",
        y        = "Total Sales (INR)",
        caption  = "India Dynamic Reporting Tool"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title    = element_text(face = "bold", hjust = 0.5,
                                     color = "#000080", size = 17),
        plot.subtitle = element_text(hjust = 0.5, color = "#666666", size = 12),
        plot.caption  = element_text(hjust = 1,   color = "#999999"),
        axis.text.x   = element_text(size = 10),
        axis.text.y   = element_text(size = 11, face = "bold"),
        panel.grid.major.y = element_blank()
      )
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 9: Summary statistics text output
  # ----------------------------------------------------------
  output$summary_stats <- renderPrint({
    
    req(filtered_data())  # only run after Generate button clicked
    df <- filtered_data()
    
    cat("=================================================\n")
    cat("   SUMMARY REPORT — INDIA DYNAMIC REPORTING TOOL\n")
    cat("=================================================\n\n")
    
    cat("Filter Applied :", input$col_select, "=", input$filter_val, "\n")
    cat("Rows Found     :", nrow(df), "\n")
    cat("Columns        :", ncol(df), "\n\n")
    
    # If Sales_INR exists, show rupee statistics
    if ("Sales_INR" %in% names(df)) {
      s <- df$Sales_INR
      cat("--- Sales Summary (INR) ---\n")
      cat("Minimum  : INR", format(min(s,  na.rm = TRUE), big.mark = ","), "\n")
      cat("Maximum  : INR", format(max(s,  na.rm = TRUE), big.mark = ","), "\n")
      cat("Average  : INR", format(round(mean(s, na.rm = TRUE)), big.mark = ","), "\n")
      cat("Total    : INR", format(sum(s,  na.rm = TRUE), big.mark = ","), "\n\n")
    }
    
    cat("--- Full R Summary ---\n\n")
    print(summary(df))
  })
  
  
  # ----------------------------------------------------------
  #  OUTPUT 10: Download filtered data as CSV file
  # ----------------------------------------------------------
  output$download_report <- downloadHandler(
    
    # set the filename of the downloaded file
    filename = function() {
      paste0("India_Report_", input$col_select, "_", Sys.Date(), ".csv")
    },
    
    # write the filtered data into the file
    content = function(file) {
      req(filtered_data())       # make sure filtered data exists
      write_csv(filtered_data(), file)  # save as CSV
    }
  )
  
  
}  # end of server


# ============================================================
#   LAUNCH THE APP
# ============================================================
shinyApp(ui = ui, server = server)

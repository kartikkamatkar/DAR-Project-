***

# 🇮🇳 Dynamic Reporting Tool — India Edition

### 📊 Overview
The **Dynamic Reporting Tool** is a specialized R-based web application that simplifies data analysis for non-technical users. While it can process any standard CSV, it is optimized for Indian datasets, featuring localized currency formatting (₹), theme-based styling using Indian flag colors, and specific state-wise sales analysis.

### 🛠️ Technologies Used
* **Language**: R Programming
* **UI Framework**: `shiny` (for the interactive web interface)
* **Visualizations**: `ggplot2` (for professional bar charts and state-wise graphs)
* **Data Manipulation**: `dplyr` (for filtering, grouping, and summarizing data)
* **File Handling**: `readr` (for fast CSV data loading)

---

### 🚀 Key Features
* **Interactive File Upload**: Supports any `.csv` file format.
* **Dynamic Filtering**: Automatically detects column names and unique values to allow specific data drill-downs.
* **Live Dashboard**: 
    * **Stat Cards**: Real-time display of Total Records, Total Sales (₹), Top State, and Top Department.
    * **Data Preview**: View the first 10 rows of any uploaded dataset.
* **Visual Analytics**:
    * **Custom Bar Charts**: Categorical data visualization using an Indian tricolor palette (Saffron, White, Green, Navy Blue).
    * **State-wise Sales Chart**: A horizontal bar chart specifically designed to show total revenue across different Indian states.
* **Export Capabilities**: Download your filtered data back into a CSV file for external use.

---

### 📂 Project Structure
* `app.R`: The core application file containing both the UI (User Interface) and Server logic.
* `data.csv`: A sample dataset featuring 32 Indian employee records across various states like Maharashtra, Delhi, and Karnataka.
* `.Rproj`: RStudio project configuration file.

---

### 📋 Sample Data Description
The tool includes a `data.csv` file to help you get started immediately. It contains the following columns:
* **Name**: Employee name.
* **Department**: Work area (e.g., Sales, HR, IT).
* **Sales_INR**: Sales figures in Indian Rupees (₹).
* **Month**: The month the record was created.
* **State**: The Indian state of the employee/transaction.
* **City**: The specific Indian city.
* **Gender**: Male/Female.

---

### ⚙️ Installation and Setup

1.  **Install R**: Download from [CRAN](https://cran.r-project.org).
2.  **Install RStudio**: Download from [Posit](https://posit.co/download/rstudio-desktop).
3.  **Install Dependencies**: Open RStudio and run the following command in the console:
    ```r
    install.packages(c("shiny", "ggplot2", "dplyr", "readr"))
    ```
4.  **Run the App**: 
    * Open `app.R` in RStudio.
    * Click the **"Run App"** button at the top right of the editor.

---

### 📖 How to Use
1.  **Upload**: Click "Browse..." and select your CSV file (e.g., `data.csv`).
2.  **Configure**:
    * Select a **Column to Analyze** (e.g., "Department").
    * Select a **Filter Value** (e.g., "Sales").
3.  **Generate**: Click the **"Generate Report"** button to refresh the dashboard.
4.  **Explore**: Navigate through the tabs (**Data Preview, Filtered Table, Bar Chart, State-wise Sales, Summary Stats**) to view results.
5.  **Download**: Click **"Download CSV"** to save your filtered results.

---

### ⚠️ Important Notes
* The **State-wise Sales** chart requires the dataset to have columns named exactly `"State"` and `"Sales_INR"` to function.
* Large datasets (50,000+ rows) may experience slower loading times depending on your hardware.

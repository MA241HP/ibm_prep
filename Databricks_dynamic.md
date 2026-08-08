## ✨ Key Features

* **Metadata-Driven Execution:** Define table source paths, target names, and validation rules in a central configuration array without hardcoding pipeline steps.
* **Python Factory Functions:** Uses closures and factory functions to dynamically instantiate `@dlt.table` objects at execution setup time without variable scoping bugs.
* **Auto Loader Ingestion:** Incrementally processes raw incoming JSON/CSV datasets from cloud storage (`ABFSS` / `S3`).
* **Dynamic Data Quality (Expectations):** Applies dictionary-based expectation rules using `@dlt.expect_all_or_drop`.
* **Automated Quarantine Routing:** Isolates failed records into dedicated quarantine tables using inverse logic filtering (`NOT (rule_1 AND rule_2)`).

---

## 🐍 Complete Python Pipeline Code (`dlt_dynamic_pipeline.py`)

Below is the complete implementation script to include in your repository:

```python
"""
dlt_dynamic_pipeline.py
========================
A dynamic, metadata-driven Delta Live Tables (DLT) pipeline for Databricks.
Ingests raw JSON datasets into Bronze tables, cleanses them into Silver tables
using dynamic quality rules, and routes bad records to Quarantine tables.
"""

import dlt
from pyspark.sql.functions import col

# ==============================================================================
# 1. METADATA & CONFIGURATION SETUP
# ==============================================================================
# In production, this dictionary can be loaded from an external JSON file 
# or a Unity Catalog metadata table during pipeline initialization.
TABLE_CONFIGS = [
    {
        "dataset_id": "sales_orders",
        "source_type": "json",
        "source_path": "/databricks-datasets/retail-org/sales_orders/",
        "bronze_table": "bronze_sales_orders",
        "silver_table": "silver_sales_orders",
        "quarantine_table": "quarantine_sales_orders",
        "rules": {
            "valid_order_id": "order_id IS NOT NULL",
            "positive_amount": "total_amount > 0"
        }
    },
    {
        "dataset_id": "customers",
        "source_type": "json",
        "source_path": "/databricks-datasets/retail-org/customers/",
        "bronze_table": "bronze_customers",
        "silver_table": "silver_customers",
        "quarantine_table": "quarantine_customers",
        "rules": {
            "valid_customer_id": "customer_id IS NOT NULL"
        }
    }
]


# ==============================================================================
# 2. FACTORY FUNCTIONS (Encapsulate scope for loop execution)
# ==============================================================================

def build_bronze_table(table_name: str, source_path: str, source_format: str):
    """Generates an append-only Bronze streaming table using Auto Loader."""
    @dlt.table(
        name=table_name,
        comment=f"Raw ingested streaming dataset for {table_name}."
    )
    def bronze_func():
        return (
            spark.readStream
            .format("cloudFiles")
            .option("cloudFiles.format", source_format)
            .load(source_path)
        )
    return bronze_func


def build_silver_table(silver_name: str, bronze_name: str, rules: dict):
    """Generates a cleansed Silver table, dropping records that fail expectations."""
    @dlt.table(
        name=silver_name,
        comment=f"Cleansed dataset for {silver_name} passing all data quality rules."
    )
    @dlt.expect_all_or_drop(rules)  # Automatically drops records failing ANY rule
    def silver_func():
        return dlt.read_stream(bronze_name)
    return silver_func


def build_quarantine_table(quarantine_name: str, bronze_name: str, rules: dict):
    """Generates a Quarantine table collecting records that failed quality rules."""
    @dlt.table(
        name=quarantine_name,
        comment=f"Audit table containing invalid records from {bronze_name}."
    )
    def quarantine_func():
        # Combine rules into a single condition: NOT ((rule1) AND (rule2))
        combined_valid_condition = " AND ".join([f"({expr})" for expr in rules.values()])
        quarantine_filter = f"NOT ({combined_valid_condition})"
        
        return (
            dlt.read_stream(bronze_name)
            .filter(quarantine_filter)
        )
    return quarantine_func


# ==============================================================================
# 3. DYNAMIC PIPELINE INSTANTIATION
# ==============================================================================
# Loop over configurations to generate the full pipeline DAG
for config in TABLE_CONFIGS:
    
    # 1. Instantiate Bronze Ingestion Table
    build_bronze_table(
        table_name=config["bronze_table"],
        source_path=config["source_path"],
        source_format=config["source_type"]
    )
    
    # 2. Instantiate Silver Cleansed Table
    build_silver_table(
        silver_name=config["silver_table"],
        bronze_name=config["bronze_table"],
        rules=config["rules"]
    )
    
    # 3. Instantiate Quarantine Audit Table
    build_quarantine_table(
        quarantine_name=config["quarantine_table"],
        bronze_name=config["bronze_table"],
        rules=config["rules"]
    )

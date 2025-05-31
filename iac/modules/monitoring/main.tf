resource "google_monitoring_dashboard" "featherweight" {
  dashboard_json = jsonencode({
    displayName = "Featherweight Benchmark Dashboard"
    gridLayout = {
      columns = 2
      widgets = [
        {
          title = "CPU Usage"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                  unitOverride = "1"
                }
              }
            ]
          }
        },
        {
          title = "Memory Usage"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/memory/utilization\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                  unitOverride = "1"
                }
              }
            ]
          }
        },
        {
          title = "Disk IOPS"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/disk/read_ops_count\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                }
              },
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/disk/write_ops_count\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                }
              }
            ]
          }
        },
        {
          title = "Network Traffic"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/network/received_bytes_count\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                }
              },
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/network/sent_bytes_count\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
                  }
                }
              }
            ]
          }
        }
      ]
    }
  })
}

# Log sink for benchmark metrics
resource "google_logging_project_sink" "benchmark" {
  name        = "featherweight-benchmark-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.benchmark_logs.dataset_id}"
  filter      = "resource.type=\"gce_instance\" AND resource.labels.instance_id=\"${var.instance_id}\""

  unique_writer_identity = true
}

# BigQuery dataset for log analytics
resource "google_bigquery_dataset" "benchmark_logs" {
  dataset_id  = "featherweight_benchmark_logs"
  description = "Dataset for Featherweight benchmark logs and metrics"
  location    = var.location

  labels = {
    environment = "benchmark"
  }

  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }

  access {
    role          = "READER"
    user_by_email = var.reader_email
  }
}

# Alert policy for high CPU usage
resource "google_monitoring_alert_policy" "cpu_usage" {
  display_name = "High CPU Usage Alert"
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"instance_id\"=\"${var.instance_id}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels
}

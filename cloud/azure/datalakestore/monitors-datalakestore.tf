resource "datadog_monitor" "datalakestore_status" {
  count = "${var.status_enabled == "true" ? 1 : 0}"

  name    = "${var.prefix_slug == "" ? "" : "[${var.prefix_slug}]"}[${var.environment}] Datalake Store is down"
  message = "${coalesce(var.status_message, var.message)}"

  query = <<EOQ
      ${var.status_time_aggregator}(${var.status_timeframe}): (
        avg:azure.datalakestore_accounts.status${module.filter-tags.query_alert} by {resource_group,region,name}
      ) < 1
  EOQ

  type = "metric alert"

  silenced = "${var.status_silenced}"

  notify_no_data      = true
  evaluation_delay    = "${var.evaluation_delay}"
  renotify_interval   = 0
  notify_audit        = false
  timeout_h           = 0
  include_tags        = true
  locked              = false
  require_full_window = false
  new_host_delay      = "${var.new_host_delay}"

  tags = ["env:${var.environment}", "type:cloud", "provider:azure", "resource:datalakestore", "team:claranet", "created-by:terraform", "${var.status_extra_tags}"]
}

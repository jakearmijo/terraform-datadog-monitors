resource "datadog_monitor" "VPN_status" {
  name    = "[${var.environment}] VPN tunnel down"
  message = "${coalesce(var.vpn_status_message, var.message)}"

  query = <<EOF
        ${var.vpn_status_time_aggregator}(${var.vpn_status_timeframe}): (
          min:aws.vpn.tunnel_state{${var.filter_tags}} by {region,tunnelipaddress}
        ) < 1
  EOF

  type = "metric alert"

  notify_no_data      = true
  renotify_interval   = 0
  evaluation_delay    = "${var.delay}"
  new_host_delay      = "${var.delay}"
  notify_audit        = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false

  silenced = "${var.vpn_status_silenced}"

  tags = ["env: ${var.environment}", "resource:vpn", "team:aws", "provider:aws"]
}

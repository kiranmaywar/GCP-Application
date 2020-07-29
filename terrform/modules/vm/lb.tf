resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "webapp-global-forwarding-rule"
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name        = "webapp-proxy"
  url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_url_map" "url_map" {
  name            = "webappurl-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "webapp-backend-service"
  port_name             = "http"
  protocol              = "HTTP"
  backend {
    group                 = google_compute_instance_group_manager.webapp.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }

  health_checks = [google_compute_http_health_check.healthcheck.self_link]
}

resource "google_compute_http_health_check" "healthcheck" {
  name         = "webapp-healthcheck"
  port         = 80
  request_path = "/"
}

resource "google_compute_instance_group_manager" "webapp" {
  name               = "webapp-instance-group-manager"
  base_instance_name = "webserver-instance"
  zone               = var.zone
  version {
    instance_template  = google_compute_instance_template.webapp.id
  }
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "autoscaler" {
  name    = "webapp-scaler"
  zone    = var.zone
  target  = google_compute_instance_group_manager.webapp.self_link

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 90

    cpu_utilization {
      target = 0.8
    }
  }
}
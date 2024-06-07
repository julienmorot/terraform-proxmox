variable "pm_api_url" {
  type    = string
  default = "https://localhost:8006/api2/json"
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}



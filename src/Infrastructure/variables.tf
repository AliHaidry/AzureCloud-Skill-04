variable rg_name {
  type    = string
  default = "rg-python-function-smah01"
}

variable location {
  type    = string
  default = "East US"
}

variable "function_app_name" {
  type    = string
  default = "func-python-smah01"
}

variable "function_service_plan_name" {
  type    = string
  default = "plan-func-python-smah01"
}

variable "function_storage_name" {
  type    = string
  default = "stfuncpythonsmah01"
}

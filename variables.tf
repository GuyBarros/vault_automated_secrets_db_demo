variable "namespaces" {
  description = "set of strings containg the paths(names) of namespaces to be created"
  type        = set(string) 
  default     = ["Engineering","IT"]
}

variable "secret_count" {
  description = "how many secrets should be created"
  type        = number
  default     = 100
}

variable "secret_owner_name" {
  description = "Name owner of the above secrets"
  type        = string
  default     = "big boss"
}

variable "secret_owner_phone" {
  description = "Phone numberof the  owner of the above secrets"
  type        = number
  default     = 8675409
}

variable "secret_owner_email" {
  description = "Phone numberof the  owner of the above secrets"
  type        = string
  default     = "d@boss.com"
}

variable "secret_owner_department_code" {
  description = "Phone numberof the  owner of the above secrets"
  type        = string
  default     = "ABCD1234"
}

variable "secret_owner_department_boolean" {
  description = "Phone numberof the  owner of the above secrets"
  type        = bool
  default     = false
}


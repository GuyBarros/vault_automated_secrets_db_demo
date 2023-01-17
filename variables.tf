variable "namespaces" {
  description = "set of strings containg the paths(names) of namespaces to be created"
  type        = set(string) 
  default     = ["Engineering","IT"]
}

variable "secret_count" {
  description = "how many secrets should be created"
  type        = number
  default     = 10
}


variable "region" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Dono da conta"
  type        = string
  default     = "fasteats"
}

variable "managedby" {
  description = "Quem gerencia fasteats"
  type        = string
  default     = "terraform"
}
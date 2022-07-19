variable "vpc_private_subnets" {
  description = "List of CIDR blocks of private subnets"
  type        = list(string)
  default     = ["10.100.110.0/24","10.100.111.0/24"]
}

variable "aws_region" {
  description = "AWS region where EC2 will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
  default     = "launch-tech-journey-demo"
}

variable "instance_type" {
  description = "EC2 instance type for the demo"
  type        = string
  default     = "t2.micro"
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to access HTTP. For demo, 0.0.0.0/0 is okay, but restrict in production."
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to access SSH. Set to your public IP/32."
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_ssh" {
  description = "Whether to allow SSH. For classroom demo, false is safer."
  type        = bool
  default     = false
}

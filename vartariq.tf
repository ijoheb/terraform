variable "new-port-ssl" {
  default     = "12111"
  tag = "prod"
  placement = "aws"
  child = "irha"
  description = "Only use for custom web server port"

}

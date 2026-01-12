
 resource "local_sensitive_file" "mysecfile" {
   content = "sup3rpass0W207$"
   filename = "password.txt"
 }

 output "outpass" {
   value = local_sensitive_file.mysecfile
   sensitive = true
 }
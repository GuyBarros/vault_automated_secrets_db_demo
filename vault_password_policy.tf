resource "vault_password_policy" "default" {
  name = "default"
  depends_on = [vault_namespace.namespaces]
 # for_each = vault_namespace.namespaces
 #  namespace = trimsuffix(each.value.id, "/")
  policy = <<EOT
    length=20
rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
  min-chars = 1
}
rule "charset" {
  charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  min-chars = 1
}
rule "charset" {
  charset = "0123456789"
  min-chars = 1
}
rule "charset" {
  charset = "!@#$%^&*"
  min-chars = 1
}
  EOT
}


data "vault_generic_secret" "password" {
    depends_on = [vault_password_policy.default]
    count = var.secret_count
  path = "sys/policies/password/default/generate"
}


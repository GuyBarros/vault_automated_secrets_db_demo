resource "vault_policy" "admin_policy" {
     depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
   namespace = trimsuffix(each.value.id, "/")
  name = "${each.value.path}_admin_policy"

  policy = <<EOT

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "Secret_Store/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "Secret_Store/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List enabled secrets engines
path "secret/metadata/*" {
   capabilities = ["list"]
}

EOT
}

resource "vault_policy" "readonly_policy" {
     depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
   namespace = trimsuffix(each.value.id, "/")
  name = "${each.value.path}_readonly_policy"

  policy = <<EOT

path "*" {
  capabilities = [ "read", "list"]
}

path "Secret_Store/*" {
  capabilities = [ "read", "list"]
}


path "Secret_Store/data/*" {
  capabilities = [ "read", "list"]
}

# List enabled secrets engines
path "secret/metadata/*" {
   capabilities = [ "read", "list"]
}

EOT
}
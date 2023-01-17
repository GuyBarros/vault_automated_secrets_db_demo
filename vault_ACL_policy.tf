resource "vault_policy" "example" {
     depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
   namespace = trimsuffix(each.value.id, "/")
  name = "${each.value.path}_policy"

  policy = <<EOT

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "example/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "example/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List enabled secrets engines
path "secret/metadata/*" {
   capabilities = ["list"]
}

EOT
}


resource "vault_namespace" "namespaces" {
    for_each = var.namespaces
  path =  each.value
}

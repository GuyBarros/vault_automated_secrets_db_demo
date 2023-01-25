resource "vault_auth_backend" "userpass" {
  depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
   namespace = trimsuffix(each.value.id, "/")
  type = "userpass"
}

resource "vault_generic_endpoint" "admin_users" {
  depends_on           = [vault_auth_backend.userpass]
  for_each             = vault_auth_backend.userpass
  namespace            = each.value.namespace
  path                 = "auth/userpass/users/admin_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${trimprefix(each.value.namespace, "admin/")}_admin_policy"],
  "password": "changeme"
}
EOT
}

resource "vault_generic_endpoint" "readonly_users" {
  depends_on           = [vault_auth_backend.userpass]
  for_each             = vault_auth_backend.userpass
  namespace            = each.value.namespace
  path                 = "auth/userpass/users/readonly_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${trimprefix(each.value.namespace, "admin/")}_readonly_policy"],
  "password": "changeme"
}
EOT
}
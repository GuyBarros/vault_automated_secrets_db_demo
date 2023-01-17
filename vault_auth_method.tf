resource "vault_auth_backend" "userpass" {
  depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
   namespace = trimsuffix(each.value.id, "/")
  type = "userpass"
}

resource "vault_generic_endpoint" "users" {
  depends_on           = [vault_auth_backend.userpass]
  for_each             = vault_auth_backend.userpass
  namespace            = each.value.namespace
  path                 = "auth/userpass/users/TestUser"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${trimprefix(each.value.namespace, "admin/")}_policy"],
  "password": "changeme"
}
EOT
}
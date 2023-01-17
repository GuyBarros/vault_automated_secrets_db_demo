resource "vault_mount" "kvv2" {
  depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
  path        = "example"
  type        = "kv"
  namespace = trimsuffix(each.value.id, "/")
  // namespace = each.value.path_fq
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}




resource "time_sleep" "wait_5_seconds" {
  depends_on = [vault_mount.kvv2]

  create_duration = "5s"
}


resource "vault_kv_secret_v2" "secrets" {
    depends_on = [time_sleep.wait_5_seconds,data.vault_generic_secret.password]
    for_each = vault_mount.kvv2
    namespace                 = trimsuffix(each.value.namespace, "/")
  mount                      = each.value.path
  name                       = "example_app"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "hello",
    password       = data.vault_generic_secret.password[0].data["password"]
  }
  )
}

resource "vault_kv_secret_v2" "test-IT" {
    depends_on = [time_sleep.wait_5_seconds,vault_mount.kvv2]
    count = var.secret_count
  namespace                 = trimsuffix(vault_mount.kvv2["IT"].namespace, "/")
  mount                      = vault_mount.kvv2["IT"].path
  name                       = "example-app-${count.index}"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "hello",
    password       = data.vault_generic_secret.password[count.index].data["password"]
  }
  )
}

resource "vault_kv_secret_v2" "test-Engineering" {
    depends_on = [time_sleep.wait_5_seconds,vault_mount.kvv2]
    count = var.secret_count
  namespace                 = trimsuffix(vault_mount.kvv2["Engineering"].namespace, "/")
  mount                      = vault_mount.kvv2["Engineering"].path
  name                       = "example-app-${count.index}"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "hello",
    password       = data.vault_generic_secret.password[count.index].data["password"]
  }
  )
}


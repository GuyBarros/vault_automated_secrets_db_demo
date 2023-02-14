resource "vault_mount" "kvv2" {
  depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
  path        = "Secret_Store_1"
  type        = "kv"
  namespace = trimsuffix(each.value.id, "/")
  // namespace = each.value.path_fq
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}


resource "vault_mount" "Secondkvv2" {
  depends_on = [vault_namespace.namespaces]
  for_each = vault_namespace.namespaces
  path        = "Secret_Store_2"
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


resource "time_sleep" "wait_5_seconds_again" {
  depends_on = [vault_mount.Secondkvv2]

  create_duration = "5s"
}



resource "vault_kv_secret_v2" "secrets" {
    depends_on = [time_sleep.wait_5_seconds_again,data.vault_generic_secret.password]
    for_each = vault_mount.Secondkvv2
    namespace                 = trimsuffix(each.value.namespace, "/")
  mount                      = each.value.path
  name                       = "Customers/${uuid()}/System1"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "hello",
    password       = data.vault_generic_secret.password[0].data["password"]
    description       = "a hard coded description"
  }
  )
  custom_metadata {
    data = {
      owner = var.secret_owner_name ,
      phone = var.secret_owner_phone
      department_code = var.secret_owner_department_code
      
    }
  }
}

resource "vault_kv_secret_v2" "IT-Secrets" {
    depends_on = [time_sleep.wait_5_seconds,vault_mount.kvv2]
    count = var.secret_count
  namespace                 = trimsuffix(vault_mount.kvv2["IT"].namespace, "/")
  mount                      = vault_mount.kvv2["IT"].path
  name                       = "Application-${count.index}"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "IT-App-User-${count.index}",
    password       = data.vault_generic_secret.password[count.index].data["password"]
    description       = "IT-App-User-${count.index}'s password for Application-${count.index}"
  }
  )
    custom_metadata {
    data = {
      owner = var.secret_owner_name ,
      phone = var.secret_owner_phone
      department_code = var.secret_owner_department_code
      
    }
  }
}

resource "vault_kv_secret_v2" "Engineering-Secrets" {
    depends_on = [time_sleep.wait_5_seconds,vault_mount.kvv2]
    count = var.secret_count
  namespace                 = trimsuffix(vault_mount.kvv2["Engineering"].namespace, "/")
  mount                      = vault_mount.kvv2["Engineering"].path
  name                       = "Application-${count.index}"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    username       = "Eng-App-User-${count.index}",
    password       = data.vault_generic_secret.password[count.index].data["password"]
    description       = "Eng-App-User-${count.index}'s password for Application-${count.index}"
  }
  )
  custom_metadata {
    data = {
      owner = var.secret_owner_name ,
      phone = var.secret_owner_phone
      department_code = var.secret_owner_department_code
      
    }
  }
}


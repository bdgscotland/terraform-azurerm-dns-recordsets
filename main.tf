
  resource_group_name = data.azurerm_dns_zone.example.resource_group_name
  zone_name           = data.azurerm_dns_zone.example.name

  name = local.srv_recordsets[count.index].name
  ttl  = local.srv_recordsets[count.index].ttl

  dynamic "record" {
    for_each = local.srv_recordsets[count.index].records
    content {
      priority = split(" ", record.value)[0]
      weight   = split(" ", record.value)[1]
      port     = split(" ", record.value)[2]
      target   = split(" ", record.value)[3]
    }
  }
}

resource "azurerm_dns_txt_record" "this" {
  count = length(local.txt_recordsets)

  resource_group_name = data.azurerm_dns_zone.example.resource_group_name
  zone_name           = data.azurerm_dns_zone.example.name

  name = (
    local.txt_recordsets[count.index].name != "" ?
    local.txt_recordsets[count.index].name :
    "@"
  )
  ttl = local.txt_recordsets[count.index].ttl

  dynamic "record" {
    for_each = local.txt_recordsets[count.index].records
    content {
      value = record.value
    }
  }
}

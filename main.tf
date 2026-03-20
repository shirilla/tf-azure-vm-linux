#================================================================================
// Resource Group
#================================================================================
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.az_location
  tags = merge(
    var.tags,
    {
      tf-module = "tf-azure-vm"
    }
  )
}

#================================================================================
// Private NIC
#================================================================================
resource "azurerm_network_interface" "networkInterface0" {
  name                = "${var.servername}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.publicIp1[0].id : null
  }

  tags = merge(
    var.tags,
    {
      tf-module = "tf-azure-vm"
    }
  )
}

resource "azurerm_public_ip" "publicIp1" {
  count               = var.assign_public_ip ? 1 : 0
  name                = "${var.servername}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.public_ip_allocation_method
  tags = merge(
    var.tags,
    {
      tf-module = "tf-azure-vm"
    }
  )
}

#================================================================================
# Public DNS
#================================================================================
resource "azurerm_dns_a_record" "record" {
  count               = (var.assign_public_ip == true && 
                        var.public_dns_zone_name != "" &&
                        var.public_dns_zone_rg != ""
                        )? 1 : 0
  name                = var.servername
  resource_group_name = var.public_dns_zone_rg
  zone_name           = var.public_dns_zone_name
  ttl                 = 60
  records             = [azurerm_public_ip.publicIp1[count.index].ip_address]
}

#================================================================================
# VM
#================================================================================
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.servername
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.size
  admin_username                  = var.admin_user
  disable_password_authentication = true
  allow_extension_operations      = var.allow_extension_operations
  secure_boot_enabled             = var.secure_boot_enabled

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_public_key_path)
  }

  network_interface_ids = [
    azurerm_network_interface.networkInterface0.id
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  custom_data = var.init_script_path != "" ? filebase64(var.init_script_path) : null

  lifecycle {
    ignore_changes = [
      custom_data,
    ]
  }

  tags = merge(
    var.tags,
    {
      tf-module = "tf-azure-vm"
    }
  )
}

#================================================================================
# Auto Shutdown Schedule
#================================================================================
resource "azurerm_dev_test_global_vm_shutdown_schedule" "autoshutdown" {
  count              = var.autoshutdown_time != "" ? 1 : 0
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  location           = azurerm_resource_group.rg.location
  enabled            = true

  daily_recurrence_time = var.autoshutdown_time
  timezone              = var.autoshutdown_timezone

  notification_settings {
    enabled = false
  }

  tags = merge(
    var.tags,
    {
      tf-module = "tf-azure-vm"
    }
  )
}

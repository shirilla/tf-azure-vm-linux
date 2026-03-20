variable "rg_name" {
  description = "The name of the Azure Resource Group in which resources will be created."
  type        = string
}

variable "az_location" {
  description = "The Azure region where all resources will be deployed (e.g., eastus, westus2)."
  type        = string
}

variable "servername" {
  description = "The name of the Linux virtual machine to be created."
  type        = string
}

variable "admin_user" {
  description = "The admin username for the Linux VM."
  type        = string
}

variable "size" {
  description = "The size (SKU) of the Azure Linux VM (e.g., Standard_B1s, Standard_DS1_v2)."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to which the VM will be attached (e.g., /subscriptions/xxxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx)."
  type        = string
}

variable "init_script_path" {
  description = "Path to the initialization (cloud-init) script to be run on VM creation. Leave empty to skip custom initialization."
  type        = string
  default     = ""
  validation {
    condition     = var.init_script_path == "" || can(file(var.init_script_path))
    error_message = "If provided, init_script_path must point to a readable file."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to be added for admin access to the VM."
  type        = string
  validation {
    condition     = var.ssh_public_key_path == "" || can(file(var.ssh_public_key_path))
    error_message = "If provided, ssh_public_key_path must point to a readable file."
  }
}

variable "public_ip_allocation_method" {
  description = "Public address is Dynamic or Static address"
  default = "Dynamic"
  type        = string
  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "public_ip_allocation_method must be either 'Static' or 'Dynamic'."
  }
}

variable "assign_public_ip" {
  description = "Boolean flag to determine if a public IP should be assigned to the VM."
  type        = bool
  default     = false
}

variable "allow_extension_operations" {
  description = "Boolean flag to determine if extensions are allowed VM."
  type        = bool
  default     = false
}

variable "secure_boot_enabled" {
  description = "Boolean flag secure boot should be enabled on the virtual machine."
  type        = bool
  default     = true
}

variable "public_dns_zone_name" {
  description = "The name of a pre-existing public DNS zone that the VM will be assigned to. If assign_public_ip=false, this variable should not be set."
  type        = string
  default     = ""
}

variable "public_dns_zone_rg" {
  description = "The resource group name of a pre-existing public DNS zone that the VM will be assigned to. If assign_public_ip=false, this variable should not be set."
  type        = string
  default     = ""
}


variable "tags" {
  description = "A map of tags to assign to all resources. These will be merged with module-defined tags."
  type        = map(string)
  default     = {}
}

variable "image_publisher" {
  description = "The publisher of the image used to create the VM."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the image used to create the VM."
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "image_sku" {
  description = "The SKU of the image used to create the VM."
  type        = string
  default     = "server"
}

variable "image_version" {
  description = "The version of the image used to create the VM."
  type        = string
  default     = "latest"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in GB. If not specified, uses the default size from the image."
  type        = number
  default     = null
}

variable "os_disk_type" {
  description = "The storage account type for the OS disk (e.g., Standard_LRS, Premium_LRS, StandardSSD_LRS)."
  type        = string
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "Premium_ZRS", "StandardSSD_ZRS"], var.os_disk_type)
    error_message = "os_disk_type must be one of: Standard_LRS, Premium_LRS, StandardSSD_LRS, Premium_ZRS, StandardSSD_ZRS."
  }
}

variable "autoshutdown_time" {
  description = "Daily auto-shutdown time in HHmm 24h format (e.g. '2000' = 8:00 PM). Set to '' to disable auto-shutdown."
  type        = string
  default     = "2000"
}

variable "autoshutdown_timezone" {
  description = "Timezone for the auto-shutdown schedule. Uses Windows timezone names (e.g. 'Central Standard Time')."
  type        = string
  default     = "Central Standard Time"
}

variable "os_disk_caching" {
  description = "The caching type for the OS disk (None, ReadOnly, ReadWrite)."
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "os_disk_caching must be one of: None, ReadOnly, ReadWrite."
  }
}

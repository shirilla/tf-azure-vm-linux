# Module description and use case
I prototype and test solutions almost daily and have created modules that are optimized for the "way that I work".

---
This module spins up an Azure VM with (optionally) a public IP address. It has other optional variables that I regularly use to spin up an Azure VM for my work:
- The cloud-init / user_data bash script path
- The ssh key of my choosing
- Tags
- more...

Once provisioned I can quickly ssh into the VM using my ssh key. No clumsy passwords. When I login the script will have configured the VM and I will not need to run `apt` or whatever.

Simplicity is beauty. 

---
# The most handy module module options

These are the variables that I find the most handy:

The `init_script_path` variable is usually the path to a `kubeadm` or `mitm` setup script.

The `tags` variable will get merged with the tags that are are set inside main.tf.

There are also variables for the OS and more, I usually go with the default values.

---
# Example: Bastion server with public IP address

```tf
module "bastion_eastus2" {
  source                      = "git::ssh://git@github.com/shirilla/tf-azure-vm.git?ref=v1.0.3"
  providers = {
    azurerm = azurerm.outpost_subscription
  }
  rg_name                     = "bastion_eastus2"
  servername                  = "bastion_eastus2"
  az_location                 = "eastus2"
  size                        = "Standard_D2as_v4"
  admin_user                  = "ubuntu"
  ssh_public_key_path         = "~/.ssh/id_rsa.pub"
  subnet_id                   = data.azurerm_subnet.op_useast2_subnet.id
  init_script_path            = "/Users/myprofile/Documents/github/bash_common_tools/startup-with-common-tools.sh"
  assign_public_ip            = true
  public_ip_allocation_method = "Static"
  tags = {
    managed-by  = "personal tf project"
    description = "bastion host"
  }
}
```

---
# Example: server with no public IP address

```tf
module "kubeadm_eastus2" {
  source                      = "git::ssh://git@github.com/shirilla/tf-azure-vm.git?ref=v1.0.3"
  providers = {
    azurerm = azurerm.outpost_subscription
  }
  rg_name                     = "kubeadm-eastus2"
  servername                  = "kubeadm-eastus2"
  az_location                 = "eastus2"
  size                        = "Standard_D2as_v4"
  admin_user                  = "ubuntu"
  ssh_public_key_path         = "~/.ssh/id_rsa.pub"
  subnet_id                   = data.azurerm_subnet.op_useast2_subnet.id
  init_script_path            = "/Users/myprofile/Documents/github/bash_common_tools/startup-with-common-tools.sh"
  assign_public_ip            = false
  tags = {
    managed-by  = "personal tf project"
    description = "bastion host"
  }
}
```

Terradocs was used to generate this next section
```
docker run --rm -v "$(pwd):/terraform-docs" -u $(id -u) \
  quay.io/terraform-docs/terraform-docs:0.20.0 \
  --output-file README.md \
  --output-mode inject \
  markdown /terraform-docs
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.networkInterface0](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_public_ip.publicIp1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | The admin username for the Linux VM. | `string` | n/a | yes |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Boolean flag to determine if a public IP should be assigned to the VM. | `bool` | `false` | no |
| <a name="input_az_location"></a> [az\_location](#input\_az\_location) | The Azure region where all resources will be deployed (e.g., eastus, westus2). | `string` | n/a | yes |
| <a name="input_image_offer"></a> [image\_offer](#input\_image\_offer) | The offer of the image used to create the VM. | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| <a name="input_image_publisher"></a> [image\_publisher](#input\_image\_publisher) | The publisher of the image used to create the VM. | `string` | `"Canonical"` | no |
| <a name="input_image_sku"></a> [image\_sku](#input\_image\_sku) | The SKU of the image used to create the VM. | `string` | `"22_04-lts-gen2"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of the image used to create the VM. | `string` | `"latest"` | no |
| <a name="input_init_script_path"></a> [init\_script\_path](#input\_init\_script\_path) | Path to the initialization (cloud-init) script to be run on VM creation. Leave empty to skip custom initialization. | `string` | `""` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | The caching type for the OS disk (None, ReadOnly, ReadWrite). | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The size of the OS disk in GB. If not specified, uses the default size from the image. | `number` | `null` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | The storage account type for the OS disk (e.g., Standard\_LRS, Premium\_LRS, StandardSSD\_LRS). | `string` | `"Standard_LRS"` | no |
| <a name="input_public_ip_allocation_method"></a> [public\_ip\_allocation\_method](#input\_public\_ip\_allocation\_method) | Public address is Dynamic or Static address | `string` | `"Dynamic"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the Azure Resource Group in which resources will be created. | `string` | n/a | yes |
| <a name="input_servername"></a> [servername](#input\_servername) | The name of the Linux virtual machine to be created. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | The size (SKU) of the Azure Linux VM (e.g., Standard\_B1s, Standard\_DS1\_v2). | `string` | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to the SSH public key file to be added for admin access to the VM. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to which the VM will be attached (e.g., /subscriptions/xxxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources. These will be merged with module-defined tags. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | A User Assigned Managed Identity ID to be assigned to the VM. If empty, SystemAssigned will be used. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address of the VM. |
| <a name="output_private_nic_id"></a> [private\_nic\_id](#output\_private\_nic\_id) | The ID of the private network interface. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The public IP address of the VM (if assigned). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group. |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The ID of the Linux virtual machine. |
| <a name="output_vm_identity_principal_id"></a> [vm\_identity\_principal\_id](#output\_vm\_identity\_principal\_id) | The principal ID of the VM's identity. If SystemAssigned is used, this will be the VM's principal ID. |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the Linux virtual machine. |
<!-- END_TF_DOCS -->
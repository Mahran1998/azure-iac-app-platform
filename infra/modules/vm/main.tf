resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.name_prefix}-vm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [var.nic_id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml.tftpl", {
    app_image = var.app_image
  }))
}

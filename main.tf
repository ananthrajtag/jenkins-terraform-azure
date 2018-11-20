module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = "${var.prefix}-rg"
  location            = "${var.location}"
  address_space       = "10.20.0.0/16"
  subnet_prefixes     = ["10.20.10.0/24", "10.20.20.0/24", "10.20.30.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "${var.prefix}"
    costcenter  = "${var.costcenter}"
  }
}

resource "azurerm_subnet" "subnet" {
  name  = "subnet1"
  address_prefix = "10.20.10.0/24"
  resource_group_name = "${var.prefix}-rg"
  virtual_network_name = "acctvnet"
  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
}

resource "azurerm_network_security_group" "ssh" {
  depends_on          = ["module.network"]
  name                = "ssh"
  location            = "${var.location}"
  resource_group_name = "${var.prefix}-rg"

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "217.33.210.119"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "217.33.210.119"
    destination_address_prefix = "*"
  }

}

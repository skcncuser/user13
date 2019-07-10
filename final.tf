provider "azurerm" {
    subscription_id = "e0fae348-f6c2-45f5-87b7-c41c22782d8f"
    client_id       = "bba9e850-d8cd-4c9d-8173-a2824ad581cd"
    client_secret   = "Mnr-toF03cLk40_gW?PKrkvUGbRf+O.w"
    tenant_id       = "96e3cac9-1ab3-436b-9f79-2a0a4b687f1b"
}


resource "azurerm_resource_group" "user13-Final-myterraformgroup" {
    name     = "user13-Final"
    location = "koreasouth"

    tags= {
        environment = "user13-Final-Terraform Demo"
    }
}


resource "azurerm_virtual_network" "user13-Final-myterraformnetwork" {
    name                = "user13-Final-myVnet"
    address_space       = ["13.0.0.0/16"]
    location            = "korea south"
    resource_group_name = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"

}

resource "azurerm_subnet" "user13-Final-myterraformsubnet" {
    name                 = "user13-Final-mySubnet1"
    resource_group_name  = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.user13-Final-myterraformnetwork.name}"
    address_prefix       = "13.0.1.0/24"
}


resource "azurerm_public_ip" "user13-Final-myterraformpublicip" {
    name                         = "user13-Final-myPublicIP"
    location                     = "koreasouth"
    resource_group_name          = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    allocation_method            = "Dynamic"
    tags = {
        environment = "User13-Final-PublicIP"
    }
}


resource "azurerm_network_security_group" "user13-Final-myterraformnsg" {
    name                = "user13-Final-myNetworkSecurityGroup"
    location            = "korea south"
    resource_group_name = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

 security_rule {
        name                       = "HTTP"
        priority                   = 2001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


    tags ={
        environment = "user13-Final-Terraform Demo"
    }
}


resource "azurerm_network_interface" "user13-Final-myterraformnic" {
    name                = "user13-Final-myNIC"
    location            = "korea south"
    resource_group_name = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    network_security_group_id = "${azurerm_network_security_group.user13-Final-myterraformnsg.id}"

    ip_configuration {
        name                          = "user13-Final-myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.user13-Final-myterraformsubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.user13-Final-myterraformpublicip.id}"
    }

    tags = {
        environment = "user13-Final-Terraform Demo"
    }
}


resource "azurerm_virtual_machine" "user13-Final-myterraformvm" {
    name                  = "user13-Final-myVM"
    location              = "korea south"
    resource_group_name   = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.user13-Final-myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "user13-Final-myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }
os_profile {
        computer_name  = "user13-Final-myvm"
        admin_username = "azureuser"
        admin_password = "SKCNC!23"
    }

 os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFQsSMCdf3GthJbQgWHv9Winvwyx0Hjo1aqqbIiYDRWCkRSpZveNKv4ywI+rfccNhNoxZLTZxLItroUq1ER8v5CZGZ03WQpJwP+0SuAh2vTxo/b5Zt9fBeVoOS6UrGgYANQaynqSBS7v/626RmCd3SDmcvNRLz4kbZ/x9ZfK2xRCUgtByPyCcJ1FlwpM6XYwIphpk6Ze5mE4mZG0FuUqo3kQXxWz+K7BcCwd52p8x5JrsGioFs7Z8/slGL3era+Ff236CruBoXCzgZ0+9tp4vUYNY6PTKvWh1C73y37GBg6QfeziwMakjCytYCFXNwA9IRIr2z8CgkYmR31an+LNKT user13@cc-8650845e-678fd4bc79-x4txf"        
}
    }

    tags = {
        environment = "User13-Final Terraform Demo"
    }
}

resource "azurerm_virtual_machine" "user13-Final-2-myterraformvm" {
    name                  = "user13-Final-2-myVM"
    location              = "korea south"
    resource_group_name   = "${azurerm_resource_group.user13-Final-myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.user13-Final-myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "user13-Final-2-myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }
os_profile {
        computer_name  = "user13-Final-2-myvm"
        admin_username = "azureuser"
        admin_password = "SKCNC!23"
    }

 os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFQsSMCdf3GthJbQgWHv9Winvwyx0Hjo1aqqbIiYDRWCkRSpZveNKv4ywI+rfccNhNoxZLTZxLItroUq1ER8v5CZGZ03WQpJwP+0SuAh2vTxo/b5Zt9fBeVoOS6UrGgYANQaynqSBS7v/626RmCd3SDmcvNRLz4kbZ/x9ZfK2xRCUgtByPyCcJ1FlwpM6XYwIphpk6Ze5mE4mZG0FuUqo3kQXxWz+K7BcCwd52p8x5JrsGioFs7Z8/slGL3era+Ff236CruBoXCzgZ0+9tp4vUYNY6PTKvWh1C73y37GBg6QfeziwMakjCytYCFXNwA9IRIr2z8CgkYmR31an+LNKT user13@cc-8650845e-678fd4bc79-x4txf"
        }
    }

    tags = {
        environment = "User13-Final-2 Terraform Demo"
    }
}

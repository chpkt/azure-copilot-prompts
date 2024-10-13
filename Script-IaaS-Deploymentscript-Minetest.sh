# --> Update '--admin-username' and '--admin-password' with your desired password before running the command
# see step Create a virtual machine

# Create a resource group
az group create --name RG-Demo-Minetest-01 --location germanywestcentral
	 
# Create a virtual network
az network vnet create --name vnet1 --resource-group RG-Demo-Minetest-01 --subnet-name subnet1
	 
# Create a public IP address
az network public-ip create --name publicIp1 --resource-group RG-Demo-Minetest-01 --allocation-method Static
	 
# Create a network security group
az network nsg create --name nsg1 --resource-group RG-Demo-Minetest-01
	 
# Create a network security group rule to allow traffic on port 30000 UDP
az network nsg rule create --name allow_udp_30000 --resource-group RG-Demo-Minetest-01 --nsg-name nsg1 --priority 100 --destination-port-ranges 30000 --protocol UDP --access Allow
	 
# Create a network interface with the specified settings
az network nic create --name nic1 --resource-group RG-Demo-Minetest-01 --vnet-name vnet1 --subnet subnet1 --public-ip-address publicIp1 --network-security-group nsg1
	 
# Create a virtual machine with the specified settings
# 
# Update --admin-username and --admin-password with your desired password before running the command
# The password length must be between 12 and 72. Password must have the 3 of the following:
# 1 lower case character, 1 upper case character, 1 number and 1 special character.
az vm create --name Minetest-Server-01 --resource-group RG-Demo-Minetest-01 --image Ubuntu2204 --admin-username 'xxx' --admin-password 'xxx' --nics nic1
	 
# Run a command on the virtual machine to install and start the Minetest server
az vm run-command invoke -g RG-Demo-Minetest-01 -n Minetest-Server-01 --command-id RunShellScript --scripts '
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:minetestdevs/stable
sudo apt-get update
sudo apt-get install -y minetest-server
sudo systemctl start minetest-server
'
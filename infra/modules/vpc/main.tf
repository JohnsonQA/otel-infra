resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default" #what is this for? what is shared tenancy? -> you explain? -> This setting determines whether instances launched in the VPC use shared or dedicated hardware. "default" means shared tenancy, where multiple customers' instances can run on the same physical hardware. "dedicated" means that instances run on hardware dedicated to a single customer, which can provide additional isolation and security but at a higher cost.

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-vpc"
        }
    )
}

#Internet Gateway to allow public access to VPC because by default VPC is private
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-igw"
        }
    )
}

#Create public subnets to host public resources like bastion host and why 2 subnets? -> For high availability and fault tolerance
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

    map_public_ip_on_launch = true #why this? -> This setting ensures that instances launched in this subnet automatically receive a public IP address, allowing them to communicate directly with the internet.

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${count.index + 1}"
        }
    )
}

# Create private subnets to host private resources like application servers and databases
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${count.index+1}"
        }
    )
}

#NAT Gateway to allows private instances to access the internet
#Before this create an Elastic IP for NAT gateway because IP address won't chanage when instance is stopped/started
resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-nat-eip"
        }
    )
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public[0].id #why NAT should be in public subnet? -> Because NAT gateway needs to have a public IP to route traffic to the internet

    depends_on = [aws_internet_gateway.igw]
}

#Route table for public subnets because by default there is no route to internet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-rt"
        }
    )
}

#Route table for private subnets to route traffic through NAT gateway
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw.id
    }

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-rt"
        }
    )
}

#Associate public subnets with public route table
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id 
    route_table_id = aws_route_table.public.id
}

#Associate private subnets with private route table
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}


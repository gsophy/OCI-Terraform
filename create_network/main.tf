provider "oci" {
    tenancy_ocid = "${var.tenancy_ocid}"
    user_ocid = "${var.user_ocid}"
    fingerprint = "${var.fingerprint}"
    private_key_path = "${var.private_key_path}"
    region = "${var.region}"
}

module "user" {
    source = "../users"
    user_name = "${var.user_name}"
    user_description = "${var.user_description}"
}

module "compartment" {
    source = "../compartments"
    tenancy_ocid = "${var.tenancy_ocid}"
    user_name = "${var.user_name}"
    compartment_name = "${var.user_name}--Compartment"
    compartment_description = "${var.user_name}--Compartment"
}

module "group" {
    source = "../groups"
    tenancy_ocid = "${var.tenancy_ocid}"
    group_name = "${var.group_name}"
    group_description = "${var.group_description}"
    compartment_ocid = "${module.compartment.new_compartment_id}"
}

module "group_policy" {
    source = "../policy"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_name = "${module.compartment.new_compartment_name}"
    compartment_ocid = "${module.compartment.new_compartment_id}"
    policy_name = "${var.policy-name}-${var.user_name}"
    group_id = "${module.group.group_id}"
}

module "group_attachment" {
    source = "../group_attachment"
    group_id = "${module.group.group_id}"
    user_id = "${module.user.user_id}"
}
module "vcn_main" {
    source = "../vcn"
    compartment_ocid = "${module.compartment.new_compartment_id}"
    vcn_cidr_block = "${var.vcn_cidr_block}"
    display_name = "${var.display_name}"
    dns_label = "${var.dns_label}"
}

module "igw" {
    source = "../igw"
    compartment_ocid = "${module.compartment.new_compartment_id}"
    vcn_id = "${module.vcn_main.vcn_id}"
    tenancy_ocid = "${var.tenancy_ocid}"
    internet_gateway_display_name = "IGWForPublic"
    internet_gateway_enabled = "true"
}

module "routetopublic" {
  source = "../routetable"
  compartment_ocid = "${module.compartment.new_compartment_id}"
  vcn_id = "${module.vcn_main.vcn_id}"
  tenant_ocid = "${var.tenancy_ocid}"
  route_table_route_rules_cidr-block = "0.0.0.0/0"
  network_id = "${module.igw.igw_id}"
  route_table_display_name = "PublicRoute"
}

module "publicsecuritylist" {
    source = "../securitylists"
    compartment_id = "${module.compartment.new_compartment_id}"
    vcn_id = "${module.vcn_main.vcn_id}"
    tenancy_ocid = "${var.tenancy_ocid}"
    sl_display_name = "PublicSecurityList"
}

module "subnet_1" {
    source = "../subnets"
    vcn_id = "${module.vcn_main.vcn_id}"
    compartment_id = "${module.compartment.compartment_id}"
    vcn_default_security_list_id = "${module.vcn_main.vcn_default_security_list_id}"
    vcn_default_route_table_id = "${module.vcn_main.vcn_default_route_table_id}"
    vcn_default_dhcp_options_id = "${module.vcn_main.vcn_default_dhcp_options_id}"
    sub_cidr_block = "${var.private_cidr_block}"
    sub_display_name = "${var.private_display_name}"
    sub_dns_label = "${var.private_dns_label}"
    tenancy_ocid = "${var.tenancy_ocid}"
    prohibit_public_ip_on_vnic = "true"  #set to true for private subnet
}

module "subnet_2" {
    source = "../subnets"
    vcn_id = "${module.vcn_main.vcn_id}"
    compartment_id = "${module.compartment.compartment_id}"
    vcn_default_security_list_id = "${module.publicsecuritylist.security_list_id}"
    vcn_default_route_table_id = "${module.routetopublic.public.route_id}"
    vcn_default_dhcp_options_id = "${module.vcn_main.vcn_default_dhcp_options_id}"
    sub_cidr_block = "${var.public_cidr_block}"
    sub_display_name = "${var.public_display_name}"
    sub_dns_label = "${var.public_dns_label}"
    tenancy_ocid = "${var.tenancy_ocid}"
    prohibit_public_ip_on_vnic = "false"  #set to true for private subnet
}

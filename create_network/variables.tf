variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

variable "vcn_cidr_block" {default = "10.0.0.0/16"}
variable "display_name" {default = "Test VCN"}
variable "dns_label" {default = "southernco"}
variable "public_cidr_block" {default = "10.0.2.0/24"}
variable "private_cidr_block" {default = "10.0.1.0/24"}
variable "public_display_name" {default = "PublicMain"}
variable "private_display_name" {default = "PrivateMain"}
variable public_dns_label {default = "public"}
variable "private_dns_label" {default = "private"}

variable "user_name" {default = "Developer1"}
variable "user_description" {default = "This is the Developer Account"}
variable "group_name" {default = "Development-Group"}
variable "group_description" {default = "This is a group for Developers"}
variable "policy_name" {default = "Developer-Compartment_Policy"}
variable "policy_description" {default = "This is the policy for Developers to access Compartment resources"}




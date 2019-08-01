resource "oci_identity_tag_namespace" "test_tag_namespace" {
    #Required
    compartment_id = "${var.compartment_id}"
    description = "${var.tag_namespace_description}"
    name = "${var.tag_namespace_name}"
}
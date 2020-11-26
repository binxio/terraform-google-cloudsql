#######################################################################################################
#
# Terraform does not have a easy way to check if the input parameters are in the correct format.
# On top of that, terraform will sometimes produce a valid plan but then fail during apply.
# To handle these errors beforehad, we're using the 'file' hack to throw errors on known mistakes.
#
#######################################################################################################
locals {
  # Regular expressions

  regex_instance_name = "(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)"

  # Terraform assertion hack
  assert_head = "\n\n-------------------------- /!\\ ASSERTION FAILED /!\\ --------------------------\n\n"
  assert_foot = "\n\n-------------------------- /!\\ ^^^^^^^^^^^^^^^^ /!\\ --------------------------\n"
  asserts = {
    instance_name_too_long = length(local.instance_name_no_random) > 100 ? file(format("%sCloudsql [%s]'s generated name is too long:\n%s\n%s > 100 chars!%s", local.assert_head, var.purpose, local.instance_name_no_random, length(local.instance_name_no_random), local.assert_foot)) : "ok"
    instance_name_regex    = length(regexall("^${local.regex_instance_name}$", local.instance_name_no_random)) == 0 ? file(format("%sCloudsql [%s]'s generated name [%s] does not match regex ^%s$%s", local.assert_head, var.purpose, local.instance_name_no_random, local.regex_instance_name, local.assert_foot)) : "ok"
    #master_cidr_prefix_28  = length(regex("/28$", var.master_ipv4_cidr_block)) != 3 ? file(format("%sMaster IPv4 CIDR block should be a /28!%s", local.assert_head, local.assert_foot)) : "ok"
    #subnet_exists = coalesce(data.google_compute_subnetwork.subnet.self_link, "!") == "!" ? file(format("%sSubnet [%s] could not be found!%s", local.assert_head, var.subnet, local.assert_foot)) : "ok"
    #secondary_range_pods   = ! contains(data.google_compute_subnetwork.subnet.secondary_ip_range.*.range_name, format("k8pods-%s", var.purpose)) ? file(format("%sPods secondary range [k8pods-%s] could not be found in subnet [%s]!%s", local.assert_head, var.purpose, var.subnet, local.assert_foot)) : "ok"
    #secondary_range_svc    = ! contains(data.google_compute_subnetwork.subnet.secondary_ip_range.*.range_name, format("k8services-%s", var.purpose)) ? file(format("%sServices secondary range [k8services-%s] could not be found in subnet [%s]!%s", local.assert_head, var.purpose, var.subnet, local.assert_foot)) : "ok"

    ip_configuration_valid = var.ip_configuration.ipv4_enabled == false && var.ip_configuration.private_network == null ? file(format("%sNo private_network provided while ipv4_enabled is false!%s", local.assert_head, local.assert_foot)) : "ok"
  }
}

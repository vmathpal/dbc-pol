  

variable "team" {
  description = "Team that performs the work"
  default = "prod"
}
  
  locals{
    allowed_ec2 = {    
    "node_type_id":{
    "type": "allowlist",
    "values": [
      "i3.xlarge",
      "i3.2xlarge"
    ],
    "defaultValue": "i3.xlarge"
  }
  }

  }

  resource "databricks_cluster_policy" "personal_vm" {
  policy_family_id                   = "personal-vm"
  policy_family_definition_overrides = jsonencode(local.allowed_ec2)
  name                               = "amitjain-policy"
}

resource "databricks_permissions" "can_use_cluster_policyinstance_profile" {
  cluster_policy_id = databricks_cluster_policy.personal_vm.id
  access_control {
    group_name       = var.team
    permission_level = "CAN_USE"
  }
}
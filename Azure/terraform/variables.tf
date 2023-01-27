variable "location" {
    default = "westeurope"
    type = string
    description = "location name"
}

variable "project_name" {
    default = "edu-klv"
    type = string
    description = "project name"
}

variable "resource_group_name" {
    default = "ResourceGroup1"
    type = string
    description = "resource group name"
}

variable "env" {
    default = "dev"
    type = string
    description = "environment"
}
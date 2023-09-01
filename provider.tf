terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  # client_id       = "4b2fa82a-35ed-4da5-a320-35aa866805f5"
  # client_secret   = "lX18Q~VCE3gpDpLBrMpinXW0AFXdt5mmhqPL.bqX"
  # subscription_id = "ba3ceec8-c343-46c0-9180-217762f60e1a"
  # tenant_id       = "79642c80-1492-4124-a20c-be4e8f38f99a"
}
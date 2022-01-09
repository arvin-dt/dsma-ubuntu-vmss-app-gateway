# Fortanix DSMA on Ubuntu VM Scale Set with Application Gateway Integration

This template deploys an Ubuntu VM Scale Set integrated with Azure Application Gateway and installs a systemd daemon to run DSM Accelerator (Tomcat server) using a Custom Extension.

It is based on the [Azure Quickstart Template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.compute/vmss-ubuntu-app-gateway)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Farvin-dt%2Fdsma-ubuntu-vmss-app-gateway%2Fmain%2Fdsma-az-vmss.json)

[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Farvin-dt%2Fdsma-ubuntu-vmss-app-gateway%2Fmain%2Fdsma-az-vmss.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Farvin-dt%2Fdsma-ubuntu-vmss-app-gateway%2Fmain%2Fdsma-az-vmss.json)

The Application Gateway is configured for round robin load balancing of incoming connections at port 80 (of the gateway's public IP address) to VMs in the scale set.

This template supports VM scale sets of up to 1,000 VMs, and uses Azure Managed Disks.

# Usage:

**1:** Validate and Create (deploys and/or updates resources as needed)

- `az deployment group validate -g POV -f dsma-az-vmss.json -p dsma-az-vmss.params.json --name azDSMATest --verbose`

- `az deployment group create -g POV -f dsma-az-vmss.json  -p dsma-az-vmss.params.json --name azDSMATest`
  
  

**2:** When updating/patching deployment, if the App Gateway backend pool is unhealthy, stop and correct the VMSS before restarting the App Gateway.

- `az network application-gateway stop -g az-resource-group --name dsmazDev-appGw`
- `az network application-gateway start -g az-resource-group --name dsmazDev-appGw`



**3:** Delete the deployment or Cleanup (purge all resources) using an special template that drains the group

- `az deployment group delete -g az-resource-group --name azDSMATest`

*Note: DRAIN-group.json purges all resources in the group, so override with caution.*

- `az deployment group create --mode complete -g az-resource-group -f DRAIN-group.json --name azDSMATest`

  


# References:

- https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli
- https://docs.microsoft.com/en-us/cli/azure/deployment/group

- https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.compute
- https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-compute

- https://docs.microsoft.com/en-us/azure/virtual-machines/windows/template-description
- https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/features-linux
- https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux
- https://github.com/Azure/custom-script-extension-linux

- https://docs.microsoft.com/en-us/azure/application-gateway/quick-create-template
- https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-networking
- https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-backend-health-troubleshooting

# Packer Proxmox tempalte builder

## Requirements

Create user with required role and create Token:
 
```
pveum user add terraform@pve --password terraform
pveum aclmod / -user terraform@pve -role Administrator
pveum user token add terraform@pve terraform -expire 0 -privsep 0
```

Set Credentials

```
export TF_VAR_proxmox_token_id="terraform@pve!terraform"
export TF_VAR_proxmox_token_secret="token_secret"
export TF_VAR_proxmox_url="https://localhost:8006/api2/json"
```


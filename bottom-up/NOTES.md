

```shell

terraform init -upgrade
terraform apply -target module.net -auto-approve
terraform apply -target module.management -auto-approve
terraform apply -target module.fw -auto-approve
```
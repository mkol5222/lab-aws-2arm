

```shell

terraform init -upgrade
terraform apply -target module.net -auto-approve
terraform apply -target module.management -auto-approve
terraform apply -target module.fw -auto-approve
terraform apply -target module.instances -auto-approve
```



```shell
terraform destroy -target module.instances -auto-approve
terraform destroy -target module.fw -auto-approve
terraform destroy -target module.management -auto-approve
terraform destroy -target module.net -auto-approve




```
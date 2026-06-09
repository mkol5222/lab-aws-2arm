```shell

aws ec2 describe-images   --executable-users self   --region eu-north-1 | jq '.Images[]|.Description'
# "[Copied ami-0a5d541ad8a40bf7e (2-arm ipv6 fix R82) from eu-west-3] AUTO Check Point CloudGuard IaaS GW BYOL R82-779.000 202605191358"

aws ec2 describe-images   --executable-users self   --region eu-north-1 | jq '.Images[]|select(.Description == "[Copied ami-0a5d541ad8a40bf7e (2-arm ipv6 fix R82) from eu-west-3] AUTO Check Point CloudGuard IaaS GW BYOL R82-779.000 202605191358")'

# image id ami-0348887d3658708bb (vs wromg ami-09cb628948e5da4b1)
```


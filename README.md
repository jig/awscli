```
docker run -e LANG=C.UTF-8 -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -ti awscli3 aws ec2 describe-instances --query 'Reservations[].Instances[].{group:Tags[?Key==`Group`].Value,name:Tags[?Key==`Name`].Value,ip:PublicIpAddress,status:State.Name} | [].{Name:name[0],group:group[0],ip:ip,status:status}' --output table
```


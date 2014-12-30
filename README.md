Usage
-----

You can use it passing credentials through ENV variables like this:

```
$ docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -ti safelayer/awscli ec2 aws describe-instances 
```

Or configuring the container first:

```
$ docker run --name myawscli -ti safelayer/awscli bash
root@7a8b715ffece:/# aws configure
AWS Access Key ID [None]: ...
```

And then use this personal container (and do not share it!):

```
$ docker start myawscli
$ docker attach myawscli
root@7a8b715ffece:/# aws ec2 describe-instances
...
```

Browse AWS EC2 images (my) Cheat Sheet
--------------------------------------

If you use `describe-instances` you usually receive a lot of unneeded info. We usually tag images with a variable named `Group` with the name of the Department that uses the machine. 

To show machine names, groups, IP addresses and running status, use this "simple" JMESpath'd sentence:

```
$ docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -ti safelayer/awscli aws ec2 describe-instances --query 'Reservations[].Instances[].{group:Tags[?Key==`Group`].Value,name:Tags[?Key==`Name`].Value,ip:PublicIpAddress,status:State.Name} | [].{Name:name[0],group:group[0],ip:ip,status:status}' --output table

---------------------------------------------------------------------------------------
|                                  DescribeInstances                                  |
+------------------------------------------+---------+-----------------+--------------+
|                   Name                   |  group  |       ip        |   status     |
+------------------------------------------+---------+-----------------+--------------+
|  DEMO-Marketing                          |  mkting |  None           |  terminated  |
|  Public-artifacts                        |  devops |  54.11.11.11    |  running     |
...
```

If you just want to see DevOps team machines, filter it:

```
$ docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -ti safelayer/awscli aws ec2 describe-instances --query 'Reservations[].Instances[].{group:Tags[?Key==`Group`].Value,name:Tags[?Key==`Name`].Value,ip:PublicIpAddress,status:State.Name} | [?group[0]==`devops`].{Name:name[0],group:group[0],ip:ip,status:status}' --output table

---------------------------------------------------------------------------------------
|                                  DescribeInstances                                  |
+------------------------------------------+---------+-----------------+--------------+
|                   Name                   |  group  |       ip        |   status     |
+------------------------------------------+---------+-----------------+--------------+
|  Public-artifacts                        |  devops |  54.11.11.11    |  running     |
|  Private-artifacts                       |  devops |  54.12.11.11    |  running     |
...
```



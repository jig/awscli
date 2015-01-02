Usage
-----

You can use this image with the convenient `daws` script, included here as well. You must have your credentials stored in `~/.aws/config` in order to work:

```
$ ./daws ec2 describe-instances
...
```

Check https://github.com/aws/aws-cli#getting-started for more info about `.aws/config` format.

Or you can use the image directly without any script:

```
$ docker run --name myawscli -ti safelayer/awscli bash
root@7a8b715ffece:/# aws configure
...
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
$ ./daws ec2 describe-instances --query 'Reservations[].Instances[].{group:Tags[?Key==`Group`].Value,name:Tags[?Key==`Name`].Value,ip:PublicIpAddress,status:State.Name} | [].{Name:name[0],group:group[0],ip:ip,status:status}' --output table

---------------------------------------------------------------------------------------
|                                  DescribeInstances                                  |
+------------------------------------------+---------+-----------------+--------------+
|                   Name                   |  group  |       ip        |   status     |
+------------------------------------------+---------+-----------------+--------------+
|  DEMO-Marketing                          |  mkting |  None           |  terminated  |
|  Public-artifacts                        |  devops |  54.11.11.11    |  running     |
...
```

If you just want to see DevOps team machines (tagged `devops`), filter it:

```
$ ./daws ec2 describe-instances --query 'Reservations[].Instances[].{group:Tags[?Key==`Group`].Value,name:Tags[?Key==`Name`].Value,ip:PublicIpAddress,status:State.Name} | [?group[0]==`devops`].{Name:name[0],group:group[0],ip:ip,status:status}' --output table

---------------------------------------------------------------------------------------
|                                  DescribeInstances                                  |
+------------------------------------------+---------+-----------------+--------------+
|                   Name                   |  group  |       ip        |   status     |
+------------------------------------------+---------+-----------------+--------------+
|  Public-artifacts                        |  devops |  54.11.11.11    |  running     |
|  Private-artifacts                       |  devops |  54.12.11.11    |  running     |
...
```
Create (and destroy) AWS EC2 instances (my random) Cheat Sheet
------------------------------------------------

This creates an Ubuntu instances (from `ami-9eaa1cf6`) in `t2.micro` hardware with the 30 GB of disk. It passes `user-data` file to clout-init. I returns InstanceId conveniently formatted for bash further process.

```
$ ./daws ec2 run-instances \
--image-id ami-9eaa1cf6 --instance-type t2.micro \
--block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":true}}]" \
--subnet-id subnet-XXXXX \
--enable-api-termination \
--user-data user-data-docker \
--associate-public-ip-address \
--query 'Instances[].InstanceId' \
--output text
```

You can assign the InstanceId to a environment variable and use that variable to destroy the instance:

```
$ INSTANCE_ID=$(docker ...)
...
$ ./daws ec2 terminate-instance $INSTANCE_ID
```

Notes
-----

Tested with aws version 1.6.10
I had a lot of trouble trying to connect AWS quicksight with an RDS following this guide: https://docs.aws.amazon.com/quicksight/latest/user/enabling-access-rds.html

Here is my own guide for the next one trying to get the security groups in place. I still reccomend to read the guide as I will not explain some basics here.

What we want to achieve is connecting quicksight to an RDS instance in a VPC without giving it public access.

So we need a user with enough permission to modifiy quicksight, rds and security groups.

The diagram shows what we want to achieve:
 ![Diagram](quicksight-connect.png)


Therefore we need to do as following:
1. Create a security group SG-1 "quicksight-vpc" to allow traffic incoming from quicksight to the RDS instance and outgoing traffic from the RDS instance to quicksight in two steps 1 and 3 as:
* Inbound rules: All TCP,	TCP,	0 - 65535,	-
* Outbound rules: Custom TCP,	TCP,	your RDS PORT, sg-2, -
2. Create SG-2 to allow incoming traffic from SG-1 to your RDS instance as:
* Inbound rules: Custom TCP,	TCP,	your RDS port,	SG-1
* Outbound rules: All traffic,	All,	All,	0.0.0.0/0
3. Modify SG-1 to accept connections from SG-2 as:
* Inbound rules: All TCP,	TCP,	0 - 65535,	SG-2
* Outbound rules: Custom TCP,	TCP,	your RDS PORT, sg-2, SG-2
4. Go to quicksights and create a VPC connection with the ID SG-1 and any subnet group which is used by your RDS instance
5. After this you can check that a network interface was created with SG-1 allowing the desited incoming and outgoing traffic 
6. Go to quicksights > data source and use the created VPC connection to reach your RDS instance

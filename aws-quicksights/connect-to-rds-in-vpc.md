I had a lot of trouble trying to connect AWS quicksight with an RDS following this guide: https://docs.aws.amazon.com/quicksight/latest/user/enabling-access-rds.html

Here is my own guide for the next one trying to get the security groups in place. I still reccomend to read the guide as I will not explain some basics here.

What we want to achieve is connecting quicksight to an RDS instance in a VPC without giving it public access.

So we need a user with enough permission to modifiy quicksight, rds and security groups.

This diagram is what we want to achieve:


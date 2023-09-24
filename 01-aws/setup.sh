#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Hello, World from $(hostname -f)" > /var/www/html/index.html
echo "Hello, World" > something.txt
echo "Hello, World" > something2.txt
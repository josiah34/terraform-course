# Notes on Storing Terraform State on a Remote Backend 




- In a production environment we usually use store the state file remotely instead of locally. The reason for this is to prevent conflicts and the corruption of the state file. For example say you have a team of Developers who all have a local copy of a state file. Developer A destroys a resource while Developer B is modifiying that resource. 





### Storing State File on an AWS S3 Bucket


# infra-labs-aws
Ce repo a vocation à accueillir les modules et scripts terraforms utilisé pour déployer les lab de formation sur des vms aws.
Les formations concernées sont les suivantes:
- Préparation CKA
- Docker
- Ansible
- Gitlab
## Module Formation
#### Le module formation utilisé déploie l'infrastructure suivante:
##### Pour tout le monde:
- Une paire de clé SSH
- Un fichier CSV contenant la liste des IPs publiques des instances déployées
##### Pour chaque stagiaire:
- Un VPC
- Un subnet (CIDR par défaut 10.20.30/24)
- Un groupe de sécurité (par défaut allow-all)
- Une Internet Gateway
- Une route vers la Gateway dans la table de routage du VPC
- Des instances AWS avec les paramètres suivants:

| Argument | Variable associée | Valeur par défaut |
| :---: | :---: | :---: |
| ami | data.aws_ami.ubuntu.image_id | ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230517 |
| instance_type | var.instance_type | t2.medium|


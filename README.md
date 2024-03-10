# infra-labs-aws


Ce repo a vocation à accueillir les modules et scripts terraforms utilisé pour déployer les lab de formation sur des vms aws.
Les formations concernées sont les suivantes:
- Préparation CKA
- Docker
- Ansible
- Gitlab
## Utilisation

Ce Module et son sous-module viennent avec des fichiers .tfvars permettant de charger les paramètres spécifiques à chaque formation

Le formateur devra se munir de credentials AWS (via awscli ou une clé d'accès/clé secrète) et d'une paire de clé ssh.

1. Téléchargez le repo
```
git clone https://github.com/ilkilab/infra-labs-aws.git
```
2. Dans le dossier, créez la clé ssh
```
ssh-keygen -f ssh-formation
```
3. Créez un fichier login.tf avec vos infos de connexions ou connectez-vous à awscli
```
aws configure
```
ou, dans un fichier login.tf
```
provider "aws" {
    region = REGION DE DEPLOIEMENT DES VMs
    access_key = CLE D'ACCES AWS
    secret_key = CLE SECRETE AWS
}
```
4. Téléchargez les providers
```
terraform init
```
5. Testez le déploiement d'une infra
```
terraform plan --var-file docker.tfvars
```


## Module Formation
#### Le module formation utilisé déploie l'infrastructure suivante:
##### Pour tout le monde:
- Une paire de clé SSH
- Un fichier CSV contenant la liste des IPs publiques des instances déployées
##### Pour chaque stagiaire:
- Un VPC
- Un subnet (CIDR par défaut 10.20.30/24)
- Un groupe de sécurité (par défaut allow-all)- Une Internet Gateway
- Une route vers la Gateway dans la table de routage du VPC
- Des instances AWS avec les paramètres suivants:
  - image par défaut: ubuntu 20.04
  - gabarit par défaut: t2.medium (2vCPU 4Go)

## Variables du module
Ces variables sont a indiquer dans un fichier "NOM_DE_FORMATION.tfvars"

| Variable | Description | Valeur par défaut |
| :---: | :---: | :---: |
| ami | data.aws_ami.ubuntu.image_id | ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230517 |
| instance_type | var.instance_type | t2.medium|


# Ressource pour le module InfraVM (OpenTofu) - Infrastructure Hybride

Déploiement de deux Wordpress sur deux distribution Linux différentes (Ubuntu 24.04, Rocky Linux 9) ainsi qu'une solution de monitoring Zabbix (Docker)

**WARNING**

**Ce projet est un support de formation et n'est pas sécurisé. Veuillez ne pas le déployer en production!!!**

## Points d'attention

1. SSH keys

L'automatisation de la saisie de passphrase doit se faire en amont du lancement des scripts:

```sh
eval "$(ssh-agent -s)"
ssh-add /path/to/privkey
```
2. Configuration Qemu

Dans /etc/libvirt/qemu.conf, désactivez les configurations de sécurité:

security_driver = "none"

3. Installer les modules ansible necéssaires

*N'oubliez pas le --force pour prendre la dernière version possible*

```sh
ansible-galaxy collection install community.zabbix --force
```

4. Les variables

Completez le fichier .env et l'exécuter:

```sh
. .env
```

## Déploiement

```sh
tofu init
tofu plan
tofu apply -auto-approve
```

## Destruction

```sh
tofu apply -auto-approve -destroy
```

# Petit plus

Pour voir le détail du déroulé, commentez chaque attribut "sensitive" dans le fichier "variables.tf"
# Ansible Azure Lab - Inventario y Ad-Hoc Commands

## Objetivo
Comprender el uso de inventarios estáticos y dinámicos, además de ejecutar comandos ad-hoc para tareas comunes en Azure.

## Prerrequisitos
- Azure CLI (`az login`)
- Terraform (opcional)
- Ansible 2.9+
- Python 3.6+

## Configuración inicial

1. Ejecutar el script de setup:
```bash
export AZURE_SUBSCRIPTION_ID="your-sub-id"
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-secret"
export AZURE_TENANT_ID="your-tenant-id"

chmod +x scripts/setup_environment.sh
./scripts/setup_environment.sh
```

2. Desplegar infraestructura (opcional con Terraform):
```bash
cd terraform
terraform init
terraform apply -auto-approve
cd ..
```

## Uso básico

### Inventario estático
```bash
# Reemplazar IPs en inventory.ini con las obtenidas de Terraform
export TF_OUTPUT_VM1_IP=$(terraform -chdir=terraform output -json vm_public_ips | jq -r '.vm1')
export TF_OUTPUT_VM2_IP=$(terraform -chdir=terraform output -json vm_public_ips | jq -r '.vm2')
envsubst < inventory/inventory.ini.tpl > inventory/inventory.ini

# Verificar conexión
ansible all -i inventory/inventory.ini -m ping
```

### Inventario dinámico
```bash
ansible-inventory -i inventory/azure_rm.yml --graph
ansible all -i inventory/azure_rm.yml -m ping
```

### Comandos Ad-Hoc
```bash
# Instalar paquetes en web servers
ansible web_servers -i inventory/inventory.ini -b -m apt -a "name={{item}} state=present" --extra-vars "@group_vars/web_servers.yml" --loop "{{web_packages}}"

# Copiar archivo
ansible all -i inventory/inventory.ini -m copy -a "src=files/test.txt dest=/tmp/test.txt"

# Ejecutar comando
ansible all -i inventory/inventory.ini -m shell -a "cat /tmp/test.txt"
```

## Limpieza
```bash
cd terraform
terraform destroy -auto-approve
```
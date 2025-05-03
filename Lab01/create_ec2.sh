# 1. Variables comunes
AMI_ID=$(aws ec2 describe-images --owners amazon \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query 'Images[0].ImageId' --output text)

KEY_NAME="ansible-key"
SEC_GROUP="ansible-sg"

# 2. Crear par de claves SSH
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
chmod 400 $KEY_NAME.pem

# 3. Crear grupo de seguridad y reglas
aws ec2 create-security-group --group-name $SEC_GROUP --description "Ansible Security Group"
SEC_GROUP_ID=$(aws ec2 describe-security-groups --group-names $SEC_GROUP --query 'SecurityGroups[0].GroupId' --output text)

aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

# 4. Crear instancia Controlador (Ansible master)
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro \
    --key-name $KEY_NAME --security-group-ids $SEC_GROUP_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Ansible-Master}]'

# 5. Crear instancia Nodo remoto (Host gestionado)
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro \
    --key-name $KEY_NAME --security-group-ids $SEC_GROUP_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Ansible-Node}]'

# 6. Verificar instancias
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress]' --output table

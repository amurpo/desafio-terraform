# Desafío Terraform: Despliegue de Infraestructura Básica en AWS

## Descripción General del Proyecto

Este proyecto utiliza Terraform para desplegar una infraestructura básica en AWS, diseñada para alojar servidores web. La infraestructura incluye una VPC, subredes, un gateway de internet, una tabla de rutas, un grupo de seguridad e instancias EC2.

## Instrucciones de Despliegue

### Prerrequisitos
* **Cuenta de AWS:** Necesaria una cuenta de AWS con las credenciales configuradas.
* **Terraform:** Descargar e instalar Terraform.

### Pasos
1. **Inicializar Terraform**

```sh
cd desafio-terraform
terraform init
```

Inicialización de backend e instalación de providers, revisión de configuración básica.

2. **Planificar los Cambios**

```sh
terraform plan
```

Este comando te mostrará un resumen de los cambios que se realizarán antes de aplicarlos.

3. **Aplicar los Cambios**

```sh
terraform apply
```

Este comando creará los recursos en AWS. Revisar cuidadosamente el plan antes de ejecutarlo.

3. **Destruir los Recursos**

```sh
terraform destroy
```

Este comando eliminará todos los recursos creados por Terraform.

## Estructura de Archivos

### `data.tf`
Contiene las definiciones de fuentes de datos de AWS:
* **amazon_linux_2**: Obtiene la AMI más reciente de Amazon Linux 2
* **aws_availability_zones**: Obtiene las zonas de disponibilidad de la región

### `locals.tf`
Define variables locales para uso interno:
* **instance_name**: Nombre base para las instancias ("web-server")
* **environment**: Entorno de despliegue ("development")
* **common_tags**: Etiquetas comunes para todos los recursos
  - Project: "desafio-terraform"
  - Environment: Valor del entorno local

### `main.tf`
Define los recursos principales de AWS:
* **VPC**: Red virtual privada con CIDR personalizable
* **Subnets**: Subredes públicas en diferentes zonas de disponibilidad
* **Internet Gateway**: Para acceso a Internet
* **Route Tables**: Tablas de enrutamiento para tráfico público
* **Security Group**: Grupo de seguridad para servidores web con reglas para:
  - SSH (puerto 22)
  - HTTP (puerto 80)
  - HTTPS (puerto 443)
* **EC2 Instances**: Instancias web distribuidas en las subredes, se usa count a partir de los subnet CIDR en variables, en este caso serán dos instancias.

### `outputs.tf`
Define las salidas después del despliegue:
* **ec2_instance_ids**: IDs de todas las instancias EC2
* **ec2_public_ips**: IPs públicas de las instancias
* **security_group_details**: Detalles del grupo de seguridad incluyendo:
  - ID
  - Nombre
  - ARN
  - URL de la consola AWS

### `provider.tf`
Configura el proveedor de AWS:
* Utiliza el perfil "mfa"
* Región definida por variable

### `terraform.tfvars`
Contiene los valores específicos de las variables:
* **aws_region**: "sa-east-1"
* **environment**: "development"
* **vpc_cidr**: "192.168.0.0/16"
* **subnet_cidrs**: ["192.168.1.0/24", "192.168.2.0/24"]
* **instance_type**: "t2.micro"
* **ssh_key_name**: "desafiolatam-cursodevops"
* **availability_zone**: "sa-east-1a"

> ⚠️ **Advertencia:** Normalmente están en un .gitignore pero se muestran por ser una práctica.

### `variables.tf`
Define las variables utilizadas en el proyecto:
* **aws_region**: Región de AWS (default: "sa-east-1")
* **environment**: Nombre del entorno (default: "development")
* **vpc_cidr**: CIDR de la VPC (default: "192.168.0.0/16")
* **subnet_cidrs**: Lista de CIDRs para subnets
* **instance_type**: Tipo de instancia EC2 (default: "t2.micro")
* **ssh_key_name**: Nombre de la llave SSH
* **availability_zone**: Zona de disponibilidad (default: "sa-east-1a")

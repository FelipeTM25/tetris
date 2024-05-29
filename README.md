# Tetris App Deployment

Este repositorio contiene los archivos necesarios para desplegar una aplicación de Tetris en un contenedor Docker, y la infraestructura para desplegar esta aplicación automáticamente en AWS usando Terraform.

## Requisitos Previos

Antes de empezar, asegúrate de tener instalados los siguientes requisitos:

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/get-started)
- [Terraform](https://www.terraform.io/)

## Pasos para el Despliegue

### 1. Clonar el Repositorio

Primero, clona este repositorio en tu máquina local usando Git.

```bash
git clone https://github.com/FelipeTM25/tetris.git
cd tetris
2. Instalar Terraform
Terraform se puede instalar de dos maneras: usando comandos o descargándolo directamente desde la página oficial.

Instalación por Comandos (en sistemas basados en Unix)
bash
Copiar código
# En macOS con Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# En Ubuntu
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp-archive-keyring.gpg
sudo mv hashicorp-archive-keyring.gpg /usr/share/keyrings/
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
Instalación por Descarga Directa
Ve a la página de descargas de Terraform.
Descarga el paquete adecuado para tu sistema operativo.
Extrae el archivo y mueve el ejecutable a un directorio incluido en tu variable PATH.
3. Configurar Credenciales de AWS
Para que Terraform pueda interactuar con tu cuenta de AWS, necesitas configurar tus credenciales en el archivo ~/.aws/credentials.

Crea el archivo si no existe y agrega tus credenciales de AWS:

ini
Copiar código
[default]
aws_access_key_id = TU_ACCESS_KEY_ID
aws_secret_access_key = TU_SECRET_ACCESS_KEY
4. Iniciar Terraform
Navega al directorio donde se encuentra tu archivo de configuración de Terraform (normalmente main.tf) y sigue estos pasos:

bash
Copiar código
# Inicializa los plugins y módulos de Terraform
terraform init

# Revisa el plan de ejecución para la infraestructura
terraform plan

# Aplica el plan para crear la infraestructura
terraform apply

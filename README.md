# Informe Completo de Configuración del Juego "Mario Bros" en Azure

## Resumen
Se llevó a cabo la implementación de un juego "Mario Bros" en un contenedor Docker en una máquina virtual de Azure. El proceso incluyó la instalación de Docker, la configuración del Docker SDK para Python, la creación y ejecución de un contenedor, y la configuración de las reglas de seguridad de red para permitir el acceso al juego.

## 1. Preparación del Entorno

### 1.1. Configuración de Ansible
Se configuró un entorno de Ansible para automatizar la instalación de Docker y la ejecución del contenedor. 

### 1.2. Archivos de Playbook
Se crearon los siguientes playbooks:

- **`install_docker.yml`**: Encargado de instalar Docker en la máquina virtual.
- **`install_docker_sdk.yml`**: Instala el SDK de Docker para Python.
- **`run_container.yml`**: Ejecuta el contenedor que aloja el juego "Mario Bros".

## 2. Instalación de Docker

### 2.1. Ejecución del Playbook
Se ejecutó el playbook para instalar Docker:

```
ansible-playbook -i inventory/hosts.ini playbooks/install_docker.yml
```

Resultados de la ejecución:

Se instalaron las dependencias necesarias para Docker.
Se agregó la clave GPG oficial de Docker.
Se configuró el repositorio de Docker.
Se instaló Docker CE.

2.2. Instalación del Docker SDK para Python
Se ejecutó el playbook para instalar el Docker SDK:
```
ansible-playbook -i inventory/hosts.ini playbooks/install_docker_sdk.yml
```
Resultados de la ejecución:

Se instaló pip si no estaba presente.
Se instaló el Docker SDK para Python.

## 3. Ejecución del Contenedor
3.1. Ejecución del Playbook
Se ejecutó el playbook para correr el contenedor que ejecuta el juego:
```
ansible-playbook -i inventory/hosts.ini playbooks/run_container.yml
```
Resultados de la ejecución:

Se creó y ejecutó el contenedor de Docker que aloja el juego "Mario Bros".

## 4. Configuración de Reglas de Seguridad en Azure
4.1. Verificación de NSG
Se verificó el grupo de seguridad de red (vm-nsg) asociado con la máquina virtual para revisar las reglas de entrada existentes.

4.2. Adición de Regla para el Puerto 8787
Se creó una nueva regla de entrada para permitir el acceso al puerto 8787:

Nombre: Allow-Mario-Game
Prioridad: 1000
Origen: Cualquiera
Puerto de origen: *
Protocolo: TCP
Puerto de destino: 8787
Acción: Permitir
Descripción: Acceso al juego Mario Bros

4.3. Verificación de la Nueva Regla
Después de agregar la regla, se verificó que estuviera activa en la lista de Reglas de entrada.

## 5. Acceso al Juego
Se probó el acceso al juego en el navegador utilizando la dirección IP pública de la máquina virtual:

http://13.64.238.39:8787

## Evidencias

Juego corriendo
![](/imgs/Mario.PNG)

Configuracion de la regla de seguridad
![](/imgs/security_rule.PNG)

VM en AZURE
![](/imgs/VM.PNG)
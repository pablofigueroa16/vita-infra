> [!TIP] `Comandos`
> ```bash
> terraform init
> ```
> **Descripción:** Prepara el directorio de trabajo: descarga providers, configura el backend y actualiza el archivo de bloqueo.
> ```bash
> terraform fmt
> ```
> **Descripción**: Ejecuta formateo standard de nuestro código en terraform
> ```bash
> terraform plan
> ```
> **Descripción**: ejecuta el plan y aplica los cambios a la infraestructura: crea/actualiza/borra recursos
> ```bash
> terraform destroy
> ```
> **Descripción**: Elimina todos los recursos gestionados por el estado de Terraform
> ```bash
> terraform (apply | destroy) -auto-approve
> ```
> **Descripción**: Forza la ejecución sin parada para confirmación. Muy práctico en pipelines/automatización donde ya se revisó el plan
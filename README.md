# 🔐 GPO Inventory Exporter (PowerShell)

Este script PowerShell coleta e exporta informações detalhadas de **todas as Group Policy Objects (GPOs)** do domínio, incluindo status de usuário/computador, filtros WMI, vinculações com OUs e presença de modelos administrativos.

## 📋 Funcionalidades

- Lista todas as GPOs do domínio.
- Exporta dados como:
  - Nome da GPO
  - GUID
  - Status de usuário e computador
  - OUs vinculadas
  - Status de "Enforced"
  - Filtro WMI
  - Presença de "Administrative Templates"
  - Datas de criação e modificação
- Gera um relatório em `.csv` para fácil análise.

## 🛠️ Requisitos

- PowerShell 5.1+
- Módulo `GroupPolicy`
- Módulo `ActiveDirectory`
- Permissões para ler GPOs e OUs no domínio

> 💡 Recomenda-se executar em um ambiente com RSAT (Remote Server Administration Tools) instalado.

## 🚀 Como usar

1. Abra o PowerShell como **Administrador**.
2. Execute o script:

```powershell
.\Export-GPO-Details.ps1
```

3. O relatório será salvo no caminho:

```
C:\Temp\All-GPOs-Export.csv
```

## 🧪 Exemplo de saída

| GPO_Name       | GUID                                   | UserStatus | ComputerStatus | LinkedOUs              | Enforced         | WMI_Filter | HasTemplates | CreationTime         | ModificationTime     |
|----------------|----------------------------------------|------------|----------------|-------------------------|------------------|------------|---------------|----------------------|----------------------|
| Default Domain Policy | {31B2F340-016D-11D2-945F-00C04FB984F9} | Enabled    | Enabled        | OU=TI,DC=empresa,DC=com | OU=TI            | null       | Yes           | 01/01/2020 10:00:00  | 25/03/2025 15:42:00  |

## 📎 Observações

- O script faz um loop por todas as OUs do domínio para identificar vinculações — isso pode levar algum tempo em ambientes grandes.
- Se necessário, ajuste o caminho do arquivo CSV (`$csvPath`) conforme sua preferência.

## 📄 Licença

Distribuído sob a licença MIT.

---

**Autor**: Erick Medeiros  
**Função**: Azure Solution Architect

# Azure Learning Labs

This repository is a collection of hands-on Azure exercises that I developed as part of my personal learning journey to deepen my knowledge of:

- Azure Infrastructure as Code (IaC)
- Bicep
- ARM Templates
- Azure CLI
- PowerShell automation

The exercises are based on the official Microsoft Learning labs for the AZ-104: Microsoft Azure Administrator certification and are inspired by the scenarios and activities available in the Microsoft Learning documentation:

- [AZ-104: Microsoft Azure Administrator Labs](https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/)

 
The goal of this repository is not to reproduce the official lab guides, but to implement the same concepts, tasks, and learning objectives using Infrastructure as Code, Azure CLI, and PowerShell automation whenever possible.

 
Each exercise focuses on a specific Azure topic and includes:

- Azure CLI scripts
- PowerShell scripts
- Bicep templates
- ARM templates
- Parameter files
- Supporting documentation

 
In addition to serving as a learning platform, this repository follows software engineering and cloud automation best practices, including:

- Continuous Integration using GitHub Actions
- Secret scanning with Gitleaks
- PowerShell linting with PSScriptAnalyzer
- Azure CLI script linting and formatting
- Bicep validation and formatting
- ARM template validation
- Infrastructure-as-Code quality controls

---

## Repository Structure

Each exercise is self-contained and can be completed independently.

```text
.
├── .github/
│   └── workflows/
│       └── quality-checks.yml
│
├── .editorconfig
├── .gitleaks.toml
├── bicepconfig.json
├── PSScriptAnalyzerSettings.psd1
│
├── shared/
│   ├── modules/
│   └── scripts/
│
├── exercise01-deploy-storage/
│   ├── README.md
│   ├── powershell/
│   ├── azure-cli/
│   ├── bicep/
│   ├── arm/
│   └── parameters/
│
└── exercise02-deploy-vnet/
    ├── README.md
    ├── powershell/
    ├── azure-cli/
    ├── bicep/
    ├── arm/
    └── parameters/
```

---

## Exercise Structure

Each exercise contains:

| Folder     | Purpose                       |
| ---------- | ----------------------------- |
| powershell | PowerShell scripts            |
| azure-cli  | Azure CLI scripts             |
| bicep      | Bicep templates               |
| arm        | ARM templates                 |
| parameters | ARM and Bicep parameter files |
| README.md  | Exercise instructions         |

Example:

```text
exercise01-deploy-storage/
│
├── README.md
│
├── powershell/
│   ├── deploy.ps1
│   └── cleanup.ps1
│
├── azure-cli/
│   ├── deploy.sh
│   └── cleanup.sh
│
├── bicep/
│   └── main.bicep
│
├── arm/
│   └── storage.arm.json
│
└── parameters/
    ├── dev.bicepparam
    └── dev.parameters.json
```

---

## Prerequisites

Before completing the exercises, install the following tools:

### Azure CLI

```bash
az version
```

Minimum recommended version:

```text
2.70+
```

### PowerShell

```powershell
$PSVersionTable.PSVersion
```

Minimum recommended version:

```text
7.x
```

### Bicep

```bash
az bicep version
```

Install:

```bash
az bicep install
```

---

## Authentication

Authenticate to Azure before running any exercise:

```bash
az login
```

Verify the selected subscription:

```bash
az account show
```

Set a subscription if needed:

```bash
az account set \
  --subscription "<subscription-name-or-id>"
```

---

## Running an Exercise

Navigate to the desired exercise folder.

Example:

```bash
cd exercise01-deploy-storage
```

Deploy using Azure CLI:

```bash
./azure-cli/deploy.sh
```

Deploy using PowerShell:

```powershell
./powershell/deploy.ps1
```

---

## Shared Components

The `shared` folder contains reusable assets that may be referenced by multiple exercises.

Examples:

- Common Bicep modules
- Common PowerShell functions
- Shared Azure CLI utilities

```text
shared/
├── modules/
└── scripts/
```

Changes to shared content trigger validation of all exercises in the CI/CD pipeline.

---

## PowerShell Validation

Implemented through PSScriptAnalyzer.

Checks include:

- Approved verbs
- Unused variables
- Secure password handling
- Script best practices
- Common PowerShell issues

Example forbidden pattern:

```powershell
$password = "P@ssw0rd!"
```

---

## Azure CLI Validation

Shell scripts are validated using:

- ShellCheck
- shfmt

Checks include:

- Syntax errors
- Unquoted variables
- Unsafe shell patterns
- Formatting compliance

---

## Bicep Validation

The pipeline validates:

- Bicep compilation
- Parameter files
- Formatting standards
- Linter rules

Example:

```bash
az bicep build --file main.bicep
```

---

## ARM Template Validation

The pipeline validates:

- JSON syntax
- Parameter file syntax

Example file:

```text
storage.arm.json
```

---

## Secret Detection

Gitleaks scans the entire repository looking for:

- Passwords
- API Keys
- Access Tokens
- Azure Storage Keys
- Connection Strings
- SAS Tokens
- Service Principal Secrets

Example of forbidden content:

```powershell
$password = "SuperSecretPassword123!"
```

```text
AccountKey=xxxxxxxxxxxxxxxxxxxxxxxx
```

Pull requests containing secrets will fail automatically.

`.gitleaks.toml` is the configuration file used by **Gitleaks** to define what should be considered a secret, what should be ignored, and how scanning should behave.

When GitHub Actions runs:

```yaml
- uses: gitleaks/gitleaks-action@v2
```

---

## License

This repository is provided for educational and training purposes.

Use the materials at your own risk and ensure all deployments comply with your organization's governance and security requirements.

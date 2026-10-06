# `bicepconfig`

`bicepconfig.json` is the configuration file used by the Bicep compiler and linter to control how Bicep templates are validated and analyzed.

When you run:

```shell
az bicep build --file main.bicep
```

Bicep automatically looks for a `bicepconfig.json` file in the current directory or one of its parent directories.

## Repository-Level Configuration

The file is in the root to ensure that all exercises use the same standards:

```text
├── bicepconfig.json
├── exercise01/
├── exercise02/
└── exercise03/
```

## Properties

Main properties:

```json
{
  "analyzers": {
    "core": {
      "enabled": true,
      "verbose": true,
      "rules": {
        ...
      }
    }
  }
}
```

- **enabled**: specify true to enable the linter, false to disable it.
- **verbose**: specify true to show the bicepconfig.json file used by Visual Studio Code.
- **rules**: specify rule-specific values. Each rule has a level that determines how the linter responds when it finds a violation.

## Rules

Since this repository is intended to help me learn Azure administration, Azure CLI, PowerShell, ARM, and Bicep through the AZ-104 labs, I decided to start with all rules set to warning so that exercises remain easy to run while still highlighting improvements.

Microsoft documentation [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter).

### `no-hardcoded-env-urls`

Flags hardcoded cloud environment URLs:

```json
"no-hardcoded-env-urls": {
    "level": "warning"
}
```

### `no-unused-parameters`

Flags parameters that are defined but never referenced:

```json
"no-unused-parameters": {
    "level": "warning"
}
```

### `no-unused-vars`

Flags variables that are defined but never referenced:

```json
"no-unused-vars": {
    "level": "warning"
}
```

### `use-resource-symbol-reference`

Detects suboptimal uses of the reference and list functions:

```json
"use-resource-symbol-reference": {
    "level": "warning"
}
```

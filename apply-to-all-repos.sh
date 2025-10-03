#!/bin/bash

echo "🏆 Aplicando Reusable Workflow a todos los repositorios de la organización..."

# Configuración
GITHUB_ORG="AGRARIAN-Application-Repository"
TOKEN="${GITHUB_TOKEN:-}"

if [ -z "$TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN no está configurado"
    echo "Ejecuta: export GITHUB_TOKEN=tu_token_aqui"
    exit 1
fi

# Workflow template
WORKFLOW_CONTENT=$(cat << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  workflow_dispatch:

permissions:
  contents: read
  packages: write
  id-token: write

jobs:
  ci-pipeline:
    name: Agrarian CI Pipeline
    uses: AGRARIAN-Application-Repository/ci-cd-pipeline/.github/workflows/agrarian-ci-pipeline.yml@main
    with:
      python-version: '3.10'
      app-port: '3000'
    secrets:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
EOF
)

# Función para aplicar workflow a un repositorio
apply_workflow_to_repo() {
    local repo_name=$1
    local temp_dir="/tmp/$repo_name-workflow-apply"

    echo "🔧 Aplicando workflow a: $repo_name"

    # Clonar repositorio
    git clone "https://${TOKEN}@github.com/$GITHUB_ORG/$repo_name.git" "$temp_dir"
    if [ $? -ne 0 ]; then
        echo "❌ Error clonando el repositorio $repo_name"
        return 1
    fi
    cd "$temp_dir"

    # Configurar git user
    git config user.email "actions@github.com"
    git config user.name "GitHub Actions"

    # Crear directorio de workflows si no existe
    mkdir -p .github/workflows

    # Escribir el workflow
    echo "$WORKFLOW_CONTENT" > .github/workflows/ci.yml

    # Añadir, commitear y push
    git add .github/workflows/ci.yml
    git commit -m "feat: Apply professional reusable workflow from ci-cd-pipeline"
    git push "https://${TOKEN}@github.com/$GITHUB_ORG/$repo_name.git" main

    if [ $? -ne 0 ]; then
        echo "❌ Error haciendo push del workflow a $repo_name"
        return 1
    fi

    echo "✅ Workflow aplicado a $repo_name"
    rm -rf "$temp_dir"
    return 0
}

# Obtener lista de repositorios
echo "📋 Obteniendo lista de repositorios..."
REPOS=$(curl -s -H "Authorization: token $TOKEN" \
             "https://api.github.com/orgs/$GITHUB_ORG/repos?per_page=100" | \
             jq -r '.[].name')

if [ -z "$REPOS" ]; then
    echo "❌ No se encontraron repositorios"
    exit 1
fi

echo "📦 Repositorios encontrados:"
echo "$REPOS"

# Aplicar workflow a cada repositorio
for repo in $REPOS; do
    # Excluir el repositorio de CI/CD
    if [ "$repo" != "ci-cd-pipeline" ]; then
        apply_workflow_to_repo "$repo"
    fi
done

echo "🎉 ¡Workflow aplicado a todos los repositorios!"
echo "🔗 Verifica en: https://github.com/orgs/$GITHUB_ORG"

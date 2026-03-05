#!/bin/bash
set -e

echo "Initializing Terraform modules..."

# Initialize root directory
echo "==> Initializing root directory"
terraform init -upgrade

# Initialize examples
echo "==> Initializing examples/simple"
cd examples/simple
terraform init -upgrade
cd ../..

# Initialize all module directories that have tests
for module_dir in modules/*/; do
  if [ -d "${module_dir}tests" ]; then
    echo "==> Initializing ${module_dir}"
    cd "$module_dir"
    terraform init -upgrade
    cd ../..
  fi
done

echo "✅ All Terraform modules initialized successfully!"

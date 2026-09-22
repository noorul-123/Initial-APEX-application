#!/bin/bash

REPO_DIR="$HOME/Documents/GitHub/Initial-APEX-application"
SQLCL="/c/Users/Agile/Downloads/sqlcl-latest/sqlcl/bin/sql.exe"

cd "$REPO_DIR" || exit 1

echo "========================================"
echo " SQLcl APEX + Database Object Export"
echo "========================================"

echo "Setting DEV wallet..."
export TNS_ADMIN="/c/Users/Agile/Downloads/Wallet_agilesuitedev"

echo "Exporting DEV database project..."

"$SQLCL" -name DEV_CICD <<EOFSQL
project export
exit
EOFSQL

if [ $? -ne 0 ]; then
    echo "ERROR: SQLcl project export failed."
    exit 1
fi

echo "SQLcl project export completed."

echo "Checking for changes..."

git add .dbtools src

if git diff --cached --quiet; then
    echo "No APEX or database object changes detected."
    exit 0
fi

git commit -m "Update APEX and database objects"
git push origin main

echo "========================================"
echo " APEX + Database CI/CD source updated"
echo "========================================"

#!/bin/bash

APP_ID=100
REPO_DIR="$HOME/Documents/GitHub/Initial-APEX-application"
SQLCL="/c/Users/Agile/Downloads/sqlcl-latest/sqlcl/bin/sql.exe"

cd "$REPO_DIR" || exit 1

echo "========================================"
echo " APEX Export - Application $APP_ID"
echo "========================================"

echo "Setting DEV wallet..."
export TNS_ADMIN="/c/Users/Agile/Downloads/Wallet_agilesuitedev"

echo "Exporting APEX application..."

"$SQLCL" -name DEV_CICD <<EOFSQL
apex export -applicationid $APP_ID
exit
EOFSQL

if [ ! -f "f${APP_ID}.sql" ]; then
    echo "ERROR: APEX export failed."
    exit 1
fi

mv "f${APP_ID}.sql" "apex/f${APP_ID}.sql"

echo "APEX export completed."

git add "apex/f${APP_ID}.sql"

if git diff --cached --quiet; then
    echo "No APEX changes detected."
    exit 0
fi

git commit -m "Update APEX application $APP_ID"
git push origin main

echo "========================================"
echo " APEX Export + Git Push completed"
echo "========================================"

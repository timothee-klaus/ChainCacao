#!/bin/bash
cd blockchain/scripts
echo "Starting Chaincode Deployment..."
./deploy-chaincode.sh >> setup.log 2>&1
if [ $? -ne 0 ]; then
    echo "Chaincode deployment failed. Check setup.log"
    exit 1
fi

echo "Starting Gateway..."
cd ../gateway
npm install --quiet
npm start > gateway.log 2>&1 &
GATEWAY_PID=$!

echo "Starting Backend..."
cd ../../backend
python -m pip install -r requirements.txt --quiet
python -m uvicorn main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1 &
BACKEND_PID=$!

echo "Systems starting up..."
echo "Gateway PID: $GATEWAY_PID"
echo "Backend PID: $BACKEND_PID"
echo "Check http://localhost:8000/docs in a few seconds."
sleep 5

#!/bin/bash

# Setup script for GCP Document AI

echo "🤖 Setting up GCP Document AI for Financial Statements Merger"
echo "=============================================================="
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI is not installed"
    echo "Please install: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Get project ID
read -p "Enter your GCP Project ID: " PROJECT_ID

# Set the project
gcloud config set project $PROJECT_ID

# Enable Document AI API
echo ""
echo "📋 Enabling Document AI API..."
gcloud services enable documentai.googleapis.com

# Get location
echo ""
read -p "Enter your preferred location (us, eu, or asia): " LOCATION
LOCATION=${LOCATION:-us}

# Create Document AI Processor
echo ""
echo "🔧 Creating Document AI Processor..."
echo "Opening Document AI console for you to create a processor..."
echo ""

# Open the console
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "https://console.cloud.google.com/ai/document-ai?project=${PROJECT_ID}"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "https://console.cloud.google.com/ai/document-ai?project=${PROJECT_ID}"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    start "https://console.cloud.google.com/ai/document-ai?project=${PROJECT_ID}"
fi

echo ""
read -p "Enter your Processor ID: " PROCESSOR_ID

# Store in secrets
echo ""
echo "🔐 Creating secrets..."
echo -n "$PROCESSOR_ID" | gcloud secrets create docai_processor_id --data-file=-
echo -n "$LOCATION" | gcloud secrets create docai_location --data-file=-

# Get project number
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

# Grant permissions
echo ""
echo "🔑 Granting permissions to service account..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/documentai.apiUser"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
  --role="roles/documentai.apiUser"

# Create .env file
echo ""
echo "📝 Creating .env file..."
cat > .env << EOF
USE_DOCUMENT_AI=true
GCP_PROJECT_ID=$PROJECT_ID
DOCUMENT_AI_PROCESSOR_ID=$PROCESSOR_ID
GCP_LOCATION=$LOCATION
EOF

echo ""
echo "✅ Setup complete!"
echo ""
echo "Configuration saved in .env file"
echo "You can now deploy your application with AI capabilities enabled!"
echo ""
echo "To deploy:"
echo "  gcloud builds submit --config cloudbuild.yaml"

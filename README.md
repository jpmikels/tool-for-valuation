# Financial Statements Merger with GCP AI 🚀

A Flask web application that processes PDF financial statements (P&L, Income Statements, and Cash Flow Statements) and merges them into a single Excel workbook. **Enhanced with GCP Document AI for intelligent extraction!**

## ✨ Features

- 📄 Upload multiple PDF financial statements
- 🤖 **AI-Powered Extraction** using GCP Document AI
- 🔍 Automatic financial data classification
- 📊 Merge data into organized Excel sheets
- 🎨 Modern, user-friendly web interface
- ☁️ Deployable on Google Cloud Platform
- 🔄 Fallback to pdfplumber if AI is unavailable

## 🤖 AI Capabilities

This application leverages **Google Cloud Document AI** for:
- Superior table extraction from PDFs
- Better handling of complex financial layouts
- More accurate data classification
- Support for scanned documents (via Document AI OCR)

## Local Development

### Prerequisites

- Python 3.11+
- pip
- (Optional) GCP Project with Document AI enabled

### Setup

1. **Install dependencies:**
```bash
pip install -r requirements.txt
```

2. **Configure GCP AI (Optional):**
```bash
# Set environment variables
export USE_DOCUMENT_AI=true
export GCP_PROJECT_ID="your-project-id"
export DOCUMENT_AI_PROCESSOR_ID="your-processor-id"
export GCP_LOCATION="us"
```

3. **Run the application:**
```bash
python app.py
```

4. Open your browser and navigate to `http://localhost:8080`

## 🤖 Setting Up GCP Document AI

### Step 1: Enable Document AI API

```bash
gcloud services enable documentai.googleapis.com
```

### Step 2: Create a Document AI Processor

1. Go to [GCP Console - Document AI](https://console.cloud.google.com/ai/document-ai)
2. Click "Create Processor"
3. Choose one of:
   - **Form Parser**: For standard forms
   - **OCR Processor**: For scanned documents
   - **General Form Parser**: For general financial documents
4. Note your **Processor ID**

### Step 3: Grant Permissions

```bash
# Grant Document AI permissions to Cloud Run service
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:YOUR_PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/documentai.apiUser"
```

## 🚀 Deployment on Google Cloud Platform

### Option 1: Quick Deploy (AI Disabled)

```bash
# Build and deploy
gcloud builds submit --config cloudbuild.yaml

# Or manually:
docker build -t gcr.io/YOUR_PROJECT_ID/financial-merger .
docker push gcr.io/YOUR_PROJECT_ID/financial-merger
gcloud run deploy financial-merger \
  --image gcr.io/YOUR_PROJECT_ID/financial-merger \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Option 2: Deploy with AI Enabled

1. **Create Document AI processor** (see steps above)
2. **Store secrets in Secret Manager:**
```bash
# Create secrets
echo -n "your-processor-id" | gcloud secrets create docai_processor_id --data-file=-
echo -n "us" | gcloud secrets create docai_location --data-file=-
```

3. **Deploy with AI:**
```bash
gcloud run deploy financial-merger \
  --image gcr.io/YOUR_PROJECT_ID/financial-merger \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars USE_DOCUMENT_AI=true,GCP_PROJECT_ID=YOUR_PROJECT_ID \
  --set-secrets DOCUMENT_AI_PROCESSOR_ID=docai_processor_id:latest,GCP_LOCATION=docai_location:latest \
  --service-account YOUR_PROJECT_NUMBER-compute@developer.gserviceaccount.com
```

## 📊 How It Works

1. **User uploads PDF files** containing financial statements
2. **Application checks for AI availability:**
   - If AI is enabled: Uses GCP Document AI for extraction
   - If AI is disabled: Falls back to pdfplumber
3. **AI/Extraction engine identifies** and categorizes financial data:
   - Income Statement
   - Profit & Loss
   - Cash Flow Statement
4. **Data is merged** into Excel workbook with styled sheets
5. **Excel file is automatically downloaded**

## 💰 GCP Costs

- **Document AI**: ~$1.50 per 1,000 pages
- **Cloud Run**: Pay for what you use (first 2M requests free)
- **Storage**: Free for small files in temp storage

**Cost-effective**: Most users process <100 documents/month, costing <$1 in Document AI fees.

## 🎯 Use Cases

- ✅ Real estate valuation companies
- ✅ Financial advisors processing client statements
- ✅ Accounting firms consolidating reports
- ✅ Investment analysts merging quarterly reports

## 🔧 Architecture

- **Backend**: Flask (Python)
- **PDF Processing**: 
  - Primary: **GCP Document AI** (intelligent extraction)
  - Fallback: pdfplumber
- **Excel Generation**: openpyxl
- **Deployment**: Docker + Cloud Run

## 🐛 Troubleshooting

### AI features not working

- Ensure Document AI API is enabled: `gcloud services enable documentai.googleapis.com`
- Check processor ID is correct
- Verify service account has Document AI permissions
- Check logs: `gcloud run services logs read financial-merger`

### PDFs not being processed

- Ensure PDFs contain actual text (not just scanned images without OCR)
- Check PDFs are not password-protected
- Verify financial statements have standard layouts

### Excel sheets are empty

- Try with different PDF formats
- Enable Document AI for better extraction
- Check PDF has searchable text (not just images)

## 📚 Additional Resources

- [Document AI Documentation](https://cloud.google.com/document-ai/docs)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)
- [Flask Documentation](https://flask.palletsprojects.com/)

## License

MIT

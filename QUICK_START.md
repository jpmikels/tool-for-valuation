# Quick Start Guide

## Your application now supports GCP AI! 🤖

### What's New:
✅ **GCP Document AI Integration** - Super accurate PDF table extraction
✅ **Fallback Support** - Works without AI (uses pdfplumber)
✅ **Smart Detection** - Automatically uses best available method
✅ **Easy Setup** - One script to configure everything

### Quick Deploy (Without AI):
```bash
cd financial_merger
gcloud builds submit --config cloudbuild.yaml
```

### Deploy with AI (Recommended):
```bash
# 1. Run setup script
./setup_ai.sh

# 2. Deploy
gcloud builds submit --config cloudbuild.yaml
```

### Local Testing:
```bash
# Install dependencies
pip install -r requirements.txt

# Run without AI
python app.py

# Or with AI (set environment variables)
export USE_DOCUMENT_AI=true
export GCP_PROJECT_ID="your-project"
export DOCUMENT_AI_PROCESSOR_ID="your-processor"
python app.py
```

### Benefits of Using GCP AI:
- ✨ Better accuracy on complex PDFs
- 🔍 Handles scanned documents (OCR)
- 📊 Intelligent table recognition
- 🎯 Superior data extraction quality

### Cost:
- Document AI: ~$1.50 per 1,000 pages
- Cloud Run: Free tier available
- Most users: <$5/month

Visit: http://localhost:8080

# SmartAR Tailor

**SmartAR Tailor** is a fashion-tech solution that enables users to capture accurate body measurements and 3D reconstructions using just a smartphone video. It eliminates the need for physical tailor visits and unlocks AR-based virtual try-on experiences.

---

## 🚀 Features

- 📹 **Video Capture**: 15-second 360° body video input via Flutter app  
- 🧍 **3D Reconstruction**: Gaussian Splatting + SMPL pipeline for photorealistic meshes  
- 📏 **Measurements**:  
  - 3 free standard measurements (freemium)  
  - 9 standard body measurements (paid tier)  
  - Dynamic point-to-point measurement (Pro subscription)  
- 🗂️ **Export**: Shareable PDF/JSON reports for tailors and designers  
- 🧥 **Virtual Try-On** (upcoming): Overlay garments on reconstructed models (₦500/session for Pro users)  
- 💳 **Monetization**: Pay-as-you-go, subscriptions, and API pricing for tailors  

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (cross-platform mobile)  
- **Backend**: Node.js + Python microservice (Flask/FastAPI)  
- **Database**: PostgreSQL  
- **AI/ML Server**:  
  - Gaussian Splatting for 3D reconstruction  
  - SMPL for predictive measurements  
- **Cloud**: AWS linux g4dn.xlarge (GPU), S3 for storage (Pendiing....) 
- **Payments**: Paystack / Flutterwave / Paypal (Pendiing....)

---

## 📊 Current Progress

- ✅ Flutter app built (signup, login, video capture working)  
- ✅ Backend skeleton live on AWS (Node.js API + MongoDB)  
- 🚧 3D Reconstruction pipeline integration (Gaussian Splatting + SMPL)  
- 🚧 Measurement extraction (dynamic + predictive standard)  
- 🔜 Export of measurement sheet (PDF/JSON)  
- 🔜 Wallet system + payment integration (₦ credits, subscriptions)  
- 🔮 AR Try-On MVP (Q1 2026 roadmap)  

---

## 🗓️ Roadmap (12 Weeks MVP Plan)

- **Month 1**:  
  - Finish dynamic + predictive measurement integration  
  - First end-to-end flow (video → mesh → measurements → export)  

- **Month 2**:  
  - Launch credit/payment system  
  - Tailor export portal + onboarding boutique partners  

- **Month 3**:  
  - Virtual try-on MVP (Pro users only)  
  - Pilot testing with 5 tailors & early adopters  
  - Prepare pitch/demo for grants & partnerships  

---

## Progress
-  .....

## 📌 License

Proprietary — All rights reserved.   

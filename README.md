# 🩸 Bloodity

### AI-Based Blood Stock Forecasting and Donor Matching System

> **SIKAPTala 2026: The National CS & IT Competition — IDEATHON**  
> by **Team LWKY**

---

## 📋 Overview

Bloodity is a real-time blood donor matching and transfusion management platform designed to solve the Philippines' critical blood shortage crisis. Inspired by the speed and immediacy of ride-hailing applications, Bloodity enables recipients or hospital staff to post a blood request that is instantly broadcast to compatible, available donors within a configurable geographic radius.

The platform features a **complete donor-to-hospital transfusion lifecycle** — from matching and navigation to doctor-confirmed extraction — and an **AI-powered blood stock prediction engine** that proactively identifies shortages before they become emergencies, shifting blood supply management from reactive to predictive.

---

## 🏥 The Problem

- The Philippines requires **~1.5 million units** of blood annually
- Only **500,000–700,000 units** are collected each year
- Families must personally call blood banks one by one or rely on social media
- No unified, real-time visibility into donor availability or hospital stock levels

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Dual-Role User System** | Any user can act as both a donor and recipient |
| **Real-Time Location Matching** | ABO/Rh-compatible donors ranked by proximity |
| **Live Navigation & Tracking** | Animated MapKit route with ETA, distance, and progress |
| **Full Transfusion Lifecycle** | Donor accepts → navigates → arrives → doctor extracts → complete |
| **Hospital Command Center** | Live metrics, active requests, transfusion management |
| **Doctor Extraction Panel** | Hospital confirms or rejects transfusion with stock sync |
| **AI Blood Stock Prediction** | 30-day depletion forecast — updates dynamically with live stock |
| **Sourcing Cascade** | Individual Donors → Partner Hospitals → Blood Banks |
| **Smart Fallback** | Auto-expands radius or reroutes to blood banks |
| **56-Day Safety Lockout** | WHO-compliant donor eligibility tracking |
| **Urgency Level System** | Critical (broadcast all), Urgent, Standard |
| **Admin Dashboard** | Platform-wide oversight with hospital verification |
| **Reset Demo** | One-tap reset for seamless re-demonstration |

---

## 🔄 Transfusion Lifecycle

The app implements a **complete end-to-end transfusion workflow**:

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Searching   │───▶│ Donor Found  │───▶│ Donor Arrived│───▶│  Transfusion  │───▶│  Fulfilled   │
│  (Hospital)  │    │  (Accepted)  │    │  (Notified)  │    │  (Extraction) │    │  (Complete)  │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
     Hospital           Donor               Donor              Hospital           System
   posts request     accepts &            arrives &          completes or       stock updated,
                     navigates           notifies doc        rejects            cooldown starts
```

1. **Hospital** creates a blood request with urgency level
2. **Donor** sees matching requests, accepts, and navigates via MapKit
3. **Donor** arrives and taps "Notify Doctor You've Arrived"
4. **Hospital** sees the donor in the "Active Transfusions" panel
5. **Doctor** taps "Complete Transfusion" or "Reject"
6. **System** increments blood stock, starts 56-day cooldown, sends thank-you notification

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| **Platform** | iOS (iPhone & iPad) |
| **Framework** | SwiftUI |
| **Architecture** | MVVM with Observable |
| **Maps** | Apple MapKit (polyline routes, animated markers) |
| **Language** | Swift 6 |
| **AI Integration** | Gemini API (forecasting), GPT-4.1 Mini (lightweight tasks) |
| **Minimum iOS** | iOS 17+ |

---

## 📱 App Structure

The app provides **four distinct experiences** based on user role:

### 🩸 Donor / Recipient Dashboard
- Availability toggle with animated status indicator
- Nearby compatible blood request feed
- Accept/decline flow with **live MapKit navigation** (animated route, ETA, distance)
- "Notify Doctor You've Arrived" button on arrival
- Blood request submission form for recipients
- Real-time fulfillment progress tracker
- Donation history with 56-day eligibility countdown

### 🏨 Hospital Dashboard
- 4 KPI metric cards (Active Requests, Available Donors, Units in Stock, Fulfilled Today)
- **Active Transfusions panel** — see arrived donors, complete or reject extraction
- AI critical shortage alert banners
- Searchable donor pool with blood type filtering (auto-filtered from request cards)
- AI Prediction Engine with 30-day depletion forecasts
- 3-step sourcing cascade (Donors → Hospitals → Blood Banks)
- Smart fallback with expanding radius visualization

### 🛡 Admin Dashboard
- Platform-wide overview with system metrics
- Hospital verification and approval management
- User management across all roles
- System-wide notification monitoring

### 👤 Profile
- Donor status and eligibility tracking
- Account information and stats
- **Reset Demo** button — resets all data for repeat presentations

---

## 🤖 AI Features

### Blood Stock Prediction Engine
- **Dynamically computed** from live inventory and daily usage rates
- Forecasts blood type shortages up to **30 days in advance**
- Categorizes alerts by severity: **Watch**, **Warning**, **Critical**
- **Updates in real-time** — when donations add stock, predictions immediately recalculate
- Weekly forecast charts show projected depletion curves

### Sourcing Cascade
1. **Individual Donors** — Notify nearby registered donors with matching blood types
2. **Partner Hospitals** — Request stock transfers from hospitals with surplus
3. **Blood Banks** — Emergency sourcing from accredited facilities (e.g., Philippine Red Cross)

---

## 🔐 Security & Privacy

- Phone OTP verification at registration
- Encrypted data transmission (HTTPS)
- Compliant with **R.A. 10173** (Philippine Data Privacy Act of 2012)
- Role-based access control (RBAC)
- Donor medical history never publicly exposed

---

## 🚀 Getting Started

### Prerequisites
- Xcode 16+ (with iOS 17+ SDK)
- macOS Sonoma or later
- iPhone 15 Pro simulator or physical device

### Build & Run
1. Clone this repository:
   ```bash
   git clone https://github.com/ryujiinnn08/Bloodity.git
   ```
2. Open `Bloodity.xcodeproj` in Xcode
3. Select a simulator (iPhone 17 Pro recommended)
4. Press `Cmd + R` to build and run

### Demo Accounts
The app includes pre-configured demo accounts accessible via **Quick Access** on the login screen:

| Role | Name | Description |
|------|------|-------------|
| **User** | Juan Dela Cruz | Donor & recipient — A+ blood type |
| **Hospital** | Dr. Elena Reyes | Hospital staff — B+ blood type |
| **Admin** | Demo Admin | Full system access — Dashboard & AI |

### Demo Flow (Recommended)
1. Log in as **Hospital** → observe active requests and stock levels
2. Log out → Log in as **User (Juan)** → accept a request → navigate → notify doctor
3. Log out → Log in as **Hospital** → see donor in "Active Transfusions" → complete extraction
4. Observe: stock incremented, prediction updated, donor now on 56-day cooldown
5. Use **Reset Demo** in Profile to start fresh

---

## 👥 Team LWKY

Built for **SIKAPTala 2026: The National CS & IT Competition**

---

## 📄 License

This project is developed for academic and competition purposes.

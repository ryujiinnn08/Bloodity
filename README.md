# 🩸 Bloodity

### AI-Based Blood Stock Forecasting and Donor Matching System

> **SIKAPTala 2026: The National CS & IT Competition — IDEATHON**  
> by **Team LWKY**

---

## 📋 Overview

Bloodity is a real-time blood donor matching platform designed to solve the Philippines' critical blood shortage crisis. Inspired by the speed and immediacy of ride-hailing applications, Bloodity enables recipients or hospital staff to post a blood request that is instantly broadcast to compatible, available donors within a configurable geographic radius.

The platform also includes an **AI-powered blood stock prediction engine** that proactively identifies shortages before they become emergencies — shifting blood supply management from reactive to predictive.

---

## 🏥 The Problem

- The Philippines requires **~1.5 million units** of blood annually
- Only **500,000–700,000 units** are collected each year
- Families must personally call blood banks one by one or rely on social media
- No unified, real-time visibility into donor availability

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Dual-Role User System** | Any user can act as both a donor and recipient |
| **Real-Time Location Matching** | ABO/Rh-compatible donors ranked by proximity |
| **Instant Push Notifications** | Accept/decline directly from notification |
| **Hospital Command Center** | Live metrics, active requests, donor pool management |
| **AI Blood Stock Prediction** | 30-day depletion forecast with severity levels |
| **Sourcing Cascade** | Individual Donors → Partner Hospitals → Blood Banks |
| **Smart Fallback** | Auto-expands radius or reroutes to blood banks |
| **56-Day Safety Lockout** | WHO-compliant donor eligibility tracking |
| **Urgency Level System** | Critical (broadcast all), Urgent, Standard |

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| **Platform** | iOS (iPhone & iPad) |
| **Framework** | SwiftUI |
| **Architecture** | MVVM |
| **Data** | SwiftData (local persistence) |
| **Language** | Swift 6 |
| **AI Integration** | Gemini API (forecasting), GPT-4.1 Mini (lightweight tasks) |
| **Minimum iOS** | iOS 17+ |

---

## 📱 App Structure

The app provides **three distinct experiences** based on user role:

### 🩸 Donor Dashboard
- Availability toggle with animated status indicator
- Nearby compatible blood request feed
- Accept/decline flow with hospital navigation
- Donation history with 56-day eligibility countdown

### 💉 Requester Dashboard
- Blood request submission form
- Real-time fulfillment progress tracker (Searching → Donor Found → On the Way → Fulfilled)
- Active and past request management

### 🏨 Hospital Dashboard
- 4 KPI metric cards (Active Requests, Available Donors, Units in Stock, Fulfilled Today)
- AI critical shortage alert banners
- Searchable donor pool with blood type filtering
- AI Prediction Engine with 30-day depletion forecasts
- 3-step sourcing cascade (Donors → Hospitals → Blood Banks)
- Smart fallback with expanding radius visualization

---

## 🤖 AI Features

### Blood Stock Prediction Engine
- Analyzes historical consumption patterns, current inventory, and seasonal trends
- Forecasts blood type shortages up to **30 days in advance**
- Categorizes alerts by severity: **Watch**, **Warning**, **Critical**
- Automatically triggers sourcing recommendations

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
The app includes pre-configured demo accounts for each role:

| Role | Name | Phone |
|------|------|-------|
| **Donor** | Juan Dela Cruz | +63 917 123 4567 |
| **Requester** | Maria Santos | +63 918 987 6543 |
| **Hospital** | Dr. Elena Reyes | +63 919 555 0123 |

Use the "Quick Access" buttons on the login screen to instantly log in as any role.

---

## 👥 Team LWKY

Built for **SIKAPTala 2026: The National CS & IT Competition**

---

## 📄 License

This project is developed for academic and competition purposes.

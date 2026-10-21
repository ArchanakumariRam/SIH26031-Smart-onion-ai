# 🧅 Smart Onion AI (स्मार्ट कांदा AI)
> **"कांदा ओळखा. अचूक भाव मिळवा."**  
> *(मराठी, हिंदी आणि इंग्रजी त्रिभाषिक शेतकरी-केंद्रित ॲप)*

Production-ready Flutter Android Application built with **Google Gemini Multimodal Vision AI**, real-time APMC Mandi rates, and smart post-harvest storage advisory for Indian farmers.

---

## 📦 Build APK

Generated APK files are not tracked in this repository. Build separate APKs for each Android ABI with:

```bash
flutter build apk --split-per-abi
```

The APKs are written to `build/app/outputs/flutter-apk/`.

---

## 🌟 Key Features (प्रमुख वैशिष्ट्ये)

1. **AI Onion Scanner ("कांदा ओळखा"):**
   - **जात (Variety):** उन्हाळ/गरवा (Garwa), रांगडा (Rangda), लाल/पोळ (Pol), पांढरा (White).
   - **आकार (Size):** मोठा (>६०mm), मध्यम (४५-६०mm), गोळटा (३०-४५mm), गोळटी (<३०mm).
   - **प्रतवारी (Grading):** Grade A (Export), Grade B (Domestic), Grade C (Defective).
   - **दोष तपासणी (Defects):** Sprouting (मोड), Black Mold (काजळी), Soft Rot (सड), Twins (जोड).
   - **चाळ साठवणूक क्षमता:** किती दिवस टिकू शकतो (उदा. ९० दिवस).
   - **अंदाजित भाव:** गुणवत्तेनुसार अपेक्षित भाव (उदा. ₹२,३५० ते ₹२,७५०/क्विंटल).

2. **Live Mandi & Profit Calculator ("अचूक भाव मिळवा"):**
   - लासलगाव, पिंपळगाव बसवंत, येवला, सोलापूर, पुणे, अहिल्यानगर, आझादपूर दिल्ली इत्यादींचे थेट दर.
   - **स्मार्ट नफा शोधक:** कांद्याचे प्रमाण (क्विंटल) टाकून डिझेल व वाहतूक खर्च वजा जाता कोणत्या बाजारात सर्वात जास्त निव्वळ नफा मिळेल याची अचूक शिफारस.

3. **कांदा पीक डॉक्टर (Crop Health Doctor):**
   - जांभळा करपा (Purple Blotch), फुलकिडे (Thrips), काजळी (Black Mold), मूळकुज (Basal Rot) यांवरील रासायनिक व जैविक फवारणीचे अचूक डोस.

4. **कांदा चाळ सल्लागार (Storage Advisor):**
   - चाळीतील थर उंची, तापमान (२५°-३०°C), आर्द्रता (६५%-७०%) आणि हवा खेळती ठेवण्याचे नियम.

5. **शेतकरी मित्र AI (Voice Assistant):**
   - मराठी, हिंदी व इंग्रजीत बोलून प्रश्न विचारण्याची सोय व ऑडिओद्वारे उत्तर ऐकण्याची सोय.

---

## 📱 How to Run / Build

### Deploy the web app

The `main` branch is deployed to Vercel by the
`.github/workflows/deploy-vercel.yml` workflow.

1. Install the [Vercel CLI](https://vercel.com/docs/cli) and sign in:
   ```bash
   npm install --global vercel
   vercel login
   ```
2. From the project root, run `vercel link` and create or select the Vercel
   project. This creates `.vercel/project.json`; copy its `orgId` and
   `projectId` values.
3. In Vercel, create a token under **Account Settings → Tokens**.
4. In the GitHub repository, open **Settings → Secrets and variables →
   Actions → New repository secret**. Add `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`,
   and `VERCEL_TOKEN` using the values from the previous steps.
5. Push to `main`, or run **Deploy Flutter web app to Vercel** from the
   repository's Actions tab.

The workflow builds Flutter for web and deploys the static output to Vercel.
The production URL is shown in the successful workflow run.

### 1. Test in Chrome / Web:
```bash
flutter run -d chrome
```

### 2. Run on Android Phone / Emulator:
```bash
flutter run
```

### 3. Build APK:
```bash
flutter build apk --split-per-abi
```

### 4. Install on Phone:
Copy the appropriate APK from `build/app/outputs/flutter-apk/` to your phone and tap to install.

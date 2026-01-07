# GA4 E-commerce EDA (BigQuery → Python)

## 📌 Project Overview

This project performs an exploratory and behavioral analysis of the **GA4 public e-commerce dataset** using **BigQuery** for data extraction and **Python** for data cleaning, categorization, and analysis.

The goal is not to replicate standard dashboard metrics, but to understand **how users move through the purchase journey**, where friction occurs, and which dimensions (traffic source, product type, brand, audience, geography) drive real purchase intent rather than surface-level activity.

- The analysis focuses on identifying:
- Funnel leakage across key commerce events
- Differences between product discovery, checkout, and conversion behavior
- The quality of traffic sources beyond raw session volume
- Product and brand performance at each stage of intent
- Geographic patterns where interest is high but conversion is weak
---

## 📊 Business Questions Answered

1. Where do users drop off the most in the purchase funnel?
2. Are users failing more at product decision or during checkout?
3. How many users show genuine purchase intent versus casual browsing?
4. Which traffic sources bring high-intent users, not just volume?
5. Which traffic sources drive consistent conversions over time?
6. How does engagement relate to conversion?
7. Which product types convert views into cart adds most effectively?
8. How do brand and audience segments differ in conversion performance?
9. Which countries show strong product interest (add-to-cart) but weak conversion to purchase?
---

## 🧠 Approach

### BigQuery — Data Extraction

BigQuery is used exclusively for data extraction and schema flattening:
- Convert GA4 event timestamps into usable date and timestamp formats
- Unnest GA4 nested fields (`event_params`, `items`)
- Select required event-, user-, session-, and item-level fields
- Produce raw tables at the correct grain (event-level and item-level)

---

### Python — Cleaning, Categorization, and Analysis

Python is responsible for all downstream transformations and analysis:
- Data cleaning and standardization
- Regex-based product categorization derived from item names
- Audience and brand classification
- Exploratory Data Analysis (EDA)
- Funnel drop-off and intent progression analysis
- Traffic source quality evaluation
- Engagement and conversion analysis
- Product-level view-to-cart gap analysis
- Time-based trend and consistency analysis


## 🧱 Data
- **Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
- **Grain:**
  - Event-level data (user, session, traffic, engagement context)
  - Item-level data (product interactions via `unnest(items)`)

### Key Challenges Addressed
- Nested GA4 schema complexity
- Inconsistent and unreliable product taxonomy
- Noisy and partially anonymized traffic attribution fields
- Mixed event intent within the same dataset

---

## 🔍 Funnel & Behavioral Scope

### Funnel Events Used
- `view_item`
- `select_item`
- `add_to_cart`
- `begin_checkout`
- `add_shipping_info`
- `add_payment_info`
- `purchase`
- `view_item_list`
- `view_search_results`

These events are used to model **intent progression**, not just conversion.

---
## 🔑 Key Insights

## 1. Where do users drop off the most in the purchase funnel?

![funnel_insights](images\funnel_drop_off_insights.png)

- **The largest drop occurs at the product decision stage.**  
  - Nearly **80% of users who view a product do not add it to cart**, making the transition from `view_item` to `add_to_cart` the dominant point of funnel leakage. This indicates that most friction occurs **before checkout begins**, likely driven by factors such as product relevance, pricing, presentation, or perceived value.

- **Checkout initiation is comparatively stable.**  
  - Once users reach `add_to_cart`, the majority proceed into checkout. The drop from `add_to_cart` to `begin_checkout` is moderate (−22.6%), and the transition from `begin_checkout` to `add_shipping_info` is effectively flat, suggesting minimal friction at this step.

- **A secondary drop occurs at payment.**  
  - The step from `add_shipping_info` to `add_payment_info` shows a significant decline (−40.8%), highlighting the **payment stage as the second most critical friction point**. This may reflect issues such as payment method limitations, trust, or unexpected costs.

### Interpretation:

User drop-off is **not mainly a checkout problem**. The biggest loss happens **before users ever commit to purchase intent**, at the product decision stage. While checkout optimization remains important, especially around payment, the data suggests that improving **product discovery, relevance, and decision clarity** would yield the largest impact on overall conversion.

## 2. Are users failing more at product decision or during checkout?

![decision_vs_checkout](images\decision_vs_checkout.png)

- **Users fail significantly more at the product decision stage.**  
  - Nearly **80% of users who view a product do not add it to cart**, indicating that most users disengage before showing strong purchase intent. This points to friction in areas such as product relevance, pricing, perceived value, or presentation.

- **Checkout failure is substantial but secondary.**  
  - While **54.5% of users who begin checkout do not complete a purchase**, this drop is meaningfully lower than at the decision stage. Checkout processes still present friction, but they are not the primary barrier to conversion.

### Interpretation:

- The dominant conversion bottleneck occurs **before checkout begins**. This suggests that optimization efforts focused solely on checkout experience would address only a secondary issue. The larger opportunity lies in improving **product discovery, clarity, and decision confidence**—ensuring that users who reach product pages are more likely to perceive sufficient value to proceed.

- It reinforces the earlier funnel analysis: **conversion challenges are driven more by product-level decision friction than by checkout mechanics**.

## 3️⃣How many users actually show purchase intent vs just browsing?

![purchase_intent_vs_browsing](images\purchase_intent_vs_browsing.png)

- **The majority of users exhibit browsing-only behavior.**  
  - Nearly **73% of users** interact with products without progressing beyond viewing. This confirms that most traffic represents **low commercial intent**.

- **Only one in five users demonstrates strong purchase intent.**  
  - Just **19.9% of users** reach high-intent actions such as adding items to cart or initiating checkout. This indicates that meaningful engagement is concentrated within a relatively small subset of the user base.

- **Final conversion represents a narrow segment of total traffic.**  
  - Only **7.2% of users** ultimately convert, highlighting the steep narrowing of the funnel from exposure to transaction.

### Interpretation:

- User behavior is heavily skewed toward **exploration rather than commitment**. While a large volume of users interacts with product pages, only a small fraction progresses into intent-driven actions, and fewer still complete purchases. This reinforces the importance of:

  - Evaluating **traffic quality**, not just quantity  
  - Identifying which segments (channels, products, audiences, geographies) disproportionately contribute to the high-intent and converted users.  

##  4️⃣Which traffic sources bring high-intent users, not just volume?
![addtocart_rate_by_marketing_channel](images\addtocart_rate_by_marketing_channel.png)

- **1. High-intent traffic does not align with traffic volume.**  
  - Organic and Direct channels drive the largest number of product views, yet their intent rates remain below 21%. In contrast, the **Unknown/Privacy segment shows the highest intent rate (27.4%)** despite lower overall volume.

- **2. Referral and Direct traffic exhibit stronger intent than Paid and Organic.**  
  - Referral (21.2%) and Direct (20.2%) outperform Paid (17.8%) and Organic (18.7%), indicating that users arriving through these channels are **more likely to progress beyond browsing**.

- **3. Paid traffic underperforms on intent quality.**  
  - Although Paid channels contribute traffic, they produce one of the lowest add-to-cart rates, suggesting that **visibility does not translate directly into purchase motivation**.

### Interpretation:

- Traffic sources differ substantially in **intent quality**, not just scale. Channels that appear less significant by volume may deliver users who are more likely to make a purchase.

## 5️⃣Which traffic sources drive consistent conversions over time?
![conversion_over_time](images\conversion_over_time.png)
To evaluate conversion volume and also the **conversion reliability**, daily purchases were analyzed by marketing channel using:

- A **7-day rolling average** of daily conversions (trend behavior)
- **Volatility (Coefficient of Variation, CV)** to measure stability  
  *(Lower CV = more consistent performance over time)*


### Channel Stability Summary

| Marketing Channel | Avg. Daily Conversions | Volatility (CV) |
|------------------|------------------------|-----------------|
| Organic          | ~14.5                  | **0.66** |
| Direct           | ~12.0                  | **0.64** |
| Referral         | ~11.5                  | **0.66** |
| Others           | ~5.5                   | 0.69 |
| Unknown / Privacy| ~7.5                   | 0.70 |
| Paid             | ~2.0                   | **0.73** |

*(Lower CV indicates more consistent performance.)*

### Key Findings

- **Direct and Organic traffic provide the most reliable conversion base.**  
  - Direct and Organic channels combine **high average daily conversions** with the **lowest volatility**, making them the most stable contributors to long-term performance.

- **Referral traffic offers scale with moderate stability.**  
  - Referral maintains relatively strong average conversions with only slightly higher volatility, positioning it as a dependable secondary channel.

- **Paid traffic is both low-volume and highly volatile.**  
  - Paid channels exhibit the **highest variability** and the **lowest average conversions**, indicating that performance is likely campaign-driven rather than sustained.

- **Privacy-affected and residual channels are inconsistent.**  
  - The `unknown_privacy` and `others` segments show moderate volume but elevated volatility, suggesting less predictable contribution.

### Interpretation

- Channels differ not only in how much they convert, but in **how consistently they convert**. The most reliable drivers of sustained performance are **Direct and Organic traffic**, followed by Referral. In contrast, Paid traffic demonstrates unstable, low-volume conversion patterns, making it less suitable as a primary growth engine.


## 6️⃣How does engagement relate to conversion?
![session_engagement_distribution](images\session_engagement_distribution.png)

To examine the relationship between user engagement and conversion, session-level **engagement time** was compared between:

- **Converted sessions** (sessions with a purchase)
- **Non-converted sessions** (sessions without a purchase)

Engagement time is measured in seconds and visualized on a **log scale** to account for the highly skewed distribution typical of behavioral data.


- **Converted sessions are substantially more engaged.**  
  - The median engagement time for converted sessions (**59.0 seconds**) is more than **10× higher** than for non-converted sessions (**5.3 seconds**). This indicates that sessions resulting in purchase involve significantly deeper interaction.

- **Engagement is strongly associated with conversion, but not deterministic.**  
  - While higher engagement increases the likelihood of conversion, the distributions overlap: some highly engaged sessions still do not convert, and a small number of low-engagement sessions do. Engagement is therefore a **strong behavioral signal**, not a guarantee.

- **Non-converted sessions are heavily concentrated at low engagement levels.**  
  - The majority of non-converting sessions cluster at very short durations, suggesting that a large portion of traffic reflects **quick exits or low-intent exploration**.

### Interpretation:

- Engagement time shows a clear and meaningful relationship with conversion: **users who convert spend substantially more time interacting with the site**. However, engagement should be treated as a **directional indicator rather than a causal driver**. High engagement increases the probability of purchase, but conversion ultimately depends on factors such as product relevance, pricing, trust, and checkout experience.

## 7️⃣Which Product Types Convert Views into Cart Adds?
![product_type_addtocart](images\product_type_addtocart.png)

- **Lightweight, low-commitment products convert interest most effectively.**  
  - Gift cards, headwear, stickers, drinkware, and sweatshirts all show add-to-cart rates above 25%, indicating that users are more willing to commit to items that are either lower cost, lower risk, or highly utilitarian.

- **Core apparel categories perform moderately but not exceptionally.**  
  - T-shirts, hoodies, and outerwear exhibit solid but lower conversion rates compared to accessories and consumables, suggesting greater hesitation at the decision stage—potentially due to sizing, style preferences, or price sensitivity.

- **Accessories and novelty items underperform.**  
  - Pins and socks show the weakest performance, indicating limited purchase intent despite visibility.

- **Volume and efficiency are not the same.**  
  - High-visibility categories (e.g., T-shirts, hoodies) attract many views, but smaller categories (e.g., headwear, drinkware) are often more efficient at converting those views into cart actions.

### Interpretation:

- Product categories differ substantially in how effectively they translate interest into intent. Items that are **simple, low-risk, or utility-driven** consistently outperform more discretionary or preference-sensitive products. 

This highlights a strategic distinction between:
- **Traffic drivers** (high-view categories) and  
- **Intent drivers** (high conversion-efficiency categories)

## 8️⃣Brand X Audience → which converts better?
![brand_x_audience](images\brand_x_audience.png)

- **Social Impact / Pride** products show the strongest intent, indicating that cause-driven or identity-aligned merchandise resonates more strongly at the decision stage.  
- **Gender-targeted segments (Men, Women)** perform slightly better than Unisex, suggesting clearer audience positioning improves conversion efficiency.  
- **Pet-related products** underperform significantly, indicating lower commercial intent despite niche appeal.



### Interpretation:

**Audience targeting has a stronger effect on conversion than brand alone.**  
While brand-level differences are modest, audience segmentation reveals clearer variation in decision-stage behavior. Products aligned with **identity, values, or specific use contexts** (e.g., Pride/Social Impact, Men’s apparel) consistently convert better than broadly targeted or novelty segments.

- **Who a product is for matters more than which brand it carries**, and  
- Conversion performance can be improved by sharper audience positioning rather than brand expansion alone.

## 9️⃣Distribution of countries showing strong product interest (Add-to-Cart) but weak conversion to purchase?

![distribution_by_countries](images\distribution_by_countries.png)

- **Several countries exhibit strong intent but weak purchase completion.**  
  - A visible cluster of countries falls into the **High Interest, Low Conversion** quadrant, indicating that users in these regions frequently express purchase intent (via add-to-cart) but disproportionately fail to convert.

- **Interest does not guarantee revenue.**  
  - Some countries show add-to-cart rates comparable to top-performing markets, yet purchase rates remain well below average. This highlights a disconnect between **product appeal** and **transaction completion**.

- **Because interest levels are high, the barrier is unlikely to be product relevance. More plausible factors include:**
    - Payment method availability
    - Shipping constraints or costs
    - Currency and tax visibility
    - Trust, compliance, or regulatory friction
    - Delivery timelines or regional logistics


### Interpretation:

- Geographic performance is **not uniform**: strong interest alone does not ensure revenue. Countries in the **High Interest, Low Conversion** segment represent **untapped opportunity**—markets where demand exists but operational, financial, or UX constraints suppress final purchases.

- From a strategic perspective:
  - These regions are better candidates for **checkout optimization, localization, and operational fixes** than for increased acquisition spend.
  - Addressing region-specific friction can unlock conversion gains without changing product mix or traffic strategy.

---
## 🚀 Future Scope & Improvements

### 1️⃣ Checkout Friction Diagnostics
Current analysis identifies where users drop off but not **why**.

- **Extension:**  
Break down checkout abandonment by device, country, and payment step (`add_shipping_info → add_payment_info → purchase`) to isolate operational, pricing, or trust-related friction.

- **Impact:** Enables targeted conversion optimization instead of broad UX changes.

---

### 2️⃣ Product & Revenue Optimization
The project evaluates conversion behavior but not financial efficiency.

- **Extension:**  
Incorporate revenue metrics (AOV, revenue per session) and, where available, cost data to identify:
  - High-intent but low-revenue products  
  - Low-volume but high-margin categories  

- **Impact:** Shifts analysis from “what converts” to “what drives profitable growth”.

---

## ⚠️ Limitations
- Public GA4 sample data (not full production fidelity)
- No cost or margin data (no profitability analysis)
- Limited long-term user tracking (no LTV or retention cohorts)
- Engagement metrics are directional, not causal

These constraints are acknowledged and do not affect the core behavioral insights.

---
### 🐍Libraries used:
- `pandas`
- `pathlib`
- `gcloud`
- `seaborn`
- `numpy`
- `matplotlib`

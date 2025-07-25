# 📈 Forecasting U.S. Corporate Profits Using ARIMA (1980–2028)

## Project Overview
This project performs a **time series analysis and forecasting** of U.S. corporate profits after tax, covering **1980 Q1 to 2024 Q3**.  
Using **ARIMA modeling** techniques, we explored the data, transformed it for stationarity, and identified an optimal model to forecast corporate profits for **2025 Q1 to 2028 Q4**.

This work was completed as part of **ECON 803 – Quantitative Analysis of Business Conditions and Forecasting** at Wichita State University.

---

## 🗂 Dataset
- **Source:** [Federal Reserve Economic Data (FRED)](https://fred.stlouisfed.org/series/CP)  
- **Series ID:** CP (Corporate Profits After Tax)  
- **Frequency:** Quarterly  
- **Period:** 1980 Q1 – 2024 Q3  
- **Units:** Billions of USD, Seasonally Adjusted Annual Rate (SAAR)  

---

## 🛠 Tools & Techniques
| Tool | Purpose |
|------|---------|
| **Stata** | Data cleaning, ARIMA modeling, diagnostics, and forecasting |
| **Excel** | Data extraction and initial inspection |
| **Statistical Methods** | ADF Test, ACF/PACF analysis, ARIMA identification |

---

## 🔑 Key Steps
✅ **Data Preparation**:  
- Converted raw dates to quarterly format, declared time series structure (`tsset` in Stata).  
- Applied log transformation to stabilize variance and first differencing to achieve stationarity.

✅ **Model Selection**:  
- Explored ACF & PACF plots to identify potential models.
- Compared ARIMA(1,1,1) and ARIMA(2,1,1) using AIC/BIC.
- Selected **ARIMA(1,1,1)** as best fit.

✅ **Diagnostics**:  
- Residuals confirmed to behave as white noise (Ljung–Box Q test p > 0.95).

✅ **Forecasting**:  
- Generated forecasts for 16 quarters (2025 Q1 – 2028 Q4).
- Results show a **steady upward trend** in corporate profits.

---

## 📈 Results
**Forecasted Corporate Profits (Billions USD):**
| Year/Quarter | Forecast |
|--------------|----------|
| 2025 Q1 | 3515.46 |
| 2025 Q4 | 3681.99 |
| 2026 Q4 | 3915.86 |
| 2027 Q4 | 4164.60 |
| 2028 Q4 | 4429.12 |

**Trend:** A moderate, consistent increase in corporate profits over the forecast horizon.

---


---

## ✨ Key Learnings
- Applied real-world time series forecasting on macroeconomic data.
- Learned ARIMA model identification, selection, and validation.
- Interpreted results for financial and business planning contexts.

---

## 👥 Authors
- **Haribabu Ambati** – MSBA Graduate Student, Wichita State University  
- **Sreemanth Chaganti** – MSBA Graduate Student, Wichita State University  

*Course:* ECON 803 – Quantitative Analysis of Business Conditions and Forecasting  
*Instructor:* Prof. Xiaoyang Zhu

---

## 📌 References
1. Box, G. E. P., & Jenkins, G. M. (1976). *Time Series Analysis: Forecasting and Control*.  
2. Montgomery, D. C., Jennings, C. L., & Kulahci, M. *Introduction to Time Series Analysis and Forecasting*.  
3. Santhosh, R., & Kumar, P. (2019). *Forecasting Profitability Using ARIMA*. Int. Journal of Management Studies.

---

⭐ **If you find this project useful, feel free to star the repository**


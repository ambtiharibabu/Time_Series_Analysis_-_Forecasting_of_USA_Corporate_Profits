**********************************
      ** LOADING DATA **
**********************************
* Step 1: Import Excel file
// Note: Replace with your actual file path
import excel "C:\Users\Hari\Downloads\CP.xlsx", firstrow clear

* Step 2: Convert observation_date to quarterly date variable
gen qdate = qofd(observation_date)
format qdate %tq

* Step 3: Set time series structure (Assuming Step 2 generates 'qdate')
tsset qdate

* Step 4: Quick check to confirm
list observation_date qdate CP in 1/5


**********************************
      ** EDA **
**********************************
* Step 1: Summary statistics for Corporate Profits
sum CP

* Step 2: Visualize the time series trend
tsline CP, title("Corporate Profits Over Time (1980q1–2024q3)")

* Step 3: Check distribution shape (optional)
histogram CP, normal title("Distribution of Corporate Profits with Normal Curve") // Added normal option

* Step 4: Check for outliers visually using Box Plot (optional)
graph box CP, title("Boxplot of Corporate Profits")


**********************************
     ** Log Transformation **
**********************************
* Step 1: Generate log of corporate profits
gen l_cp = log(CP)

* Step 2: Visualize the log-transformed series
tsline l_cp, title("Log of Corporate Profits Over Time (1980q1–2024q3)")

* Step 3: Check distribution shape (optional)
histogram l_cp, normal title("Distribution of Log of Corporate Profits with Normal Curve") // Added normal option

* Step 4: Boxplot for log profits (optional)
graph box l_cp, title("Boxplot of Log of Corporate Profits")


**********************************
     ** ADF Test for Stationarity **
**********************************
* Step 1: Run ADF test on log-transformed series
* Note: Choosing lags often involves checking info criteria or ACF/PACF of differenced series
* Assuming lags(4) was appropriate based on prior analysis
dfuller l_cp, lags(4)
* Result noted: p=0.9558 - Series is non-stationary


**********************************
     ** Differencing **
**********************************
* Step 1: Create first difference of log profits
generate dl_cp = D.l_cp

* Step 2: Plot differenced series
tsline dl_cp, title("First Difference of Log Corporate Profits")

* Step 3 : Run ADF test again on the differenced series
dfuller dl_cp, lags(4) // Assuming 4 lags still appropriate
* Result noted: At d=1, series became stationary


**********************************
     ** ACF and PACF plots **
**********************************
* Step 1: Plot Autocorrelation Function (ACF) for differenced series
ac dl_cp, title("ACF of Differenced Log Corporate Profits") lags(20) // Added lags() option

* Step 2: Plot Partial Autocorrelation Function (PACF) for differenced series
pac dl_cp, title("PACF of Differenced Log Corporate Profits") lags(20) // Added lags() option

* Interpretation noted: Suggests ARIMA(1,1,1) or ARIMA(2,1,1)


**********************************
     ** Estimating ARIMA Models **
**********************************
* Step 1: Estimate ARIMA(1,1,1) model on original log profits & display AIC and BIC
arima l_cp, arima(1,1,1)
estat ic

* Step 2: Estimate ARIMA(2,1,1) model on original log profits & display AIC and BIC
arima l_cp, arima(2,1,1)
estat ic

* Comparison noted: Lower AIC/BIC for ARIMA(1,1,1)
* Final Model Selection: ARIMA(1,1,1)

* Re-estimate the final model where stata takes this as our finalised model 
arima l_cp, arima(1,1,1)
estat ic


**********************************
     ** Residual Diagnostics **
**********************************
* Step 1: Predict residuals after final ARIMA(1,1,1) estimation
predict resid_final, residuals

* Step 2: Plot residuals over time
tsline resid_final, title("Residuals from ARIMA(1,1,1) Model")

* Step 3: Check ACF of residuals (should show no significant spikes)
ac resid_final, title("ACF of Residuals from ARIMA(1,1,1)") lags(20)

* Step 4: Ljung-Box Q Test (tests for overall autocorrelation in residuals)
* Null Hypothesis: Residuals are white noise
wntestq resid_final, lags(20) // Use a reasonable number of lags

* Note: ARCH LM test skipped as mentioned by user.

**********************************
     ** Forecasting **
**********************************
* Step 1: Extend dataset for 16 future quarters (4 years)
tsappend, add(16)

* Step 2: Re-estimate the final model using only the actual data range
* (Ensures coefficients aren't influenced by the appended missing values)
arima l_cp if tin(, 2024q3), arima(1,1,1)

* Step 3: Predict the in-sample fitted values of l_cp (the level)
predict fitted_lcp, y // <--- CORRECTED: Use option y
replace fitted_lcp = . if missing(l_cp) // Ensure fitted only where actual exists


* Step 4: Generate dynamic forecasts for l_cp (the level) starting after 2024q3
* The dynamic forecast uses predicted values once real values run out.
predict forecast_lcp, y dynamic(tq(2024q4)) // <--- CORRECTED: Use option y and specify start quarter


* Step 5: Create an indicator for the sample period vs forecast period
gen sample_indicator = !missing(l_cp)

* Step 6: Plot actual, fitted, and forecast values
twoway ///
    (line l_cp qdate if sample_indicator, lcolor(blue) lwidth(medium)) ///       // Actual data
    (line fitted_lcp qdate if sample_indicator, lcolor(red) lpattern(dash)) ///   // In-sample fit
    (line forecast_lcp qdate if !sample_indicator, lcolor(green) lpattern(dot)), /// // Out-of-sample forecast
    title("Corporate Profits: Actual, Fitted, and Forecast (+4 years)") ///
    subtitle("ARIMA(1,1,1) Model on Log Profits") ///
    legend(order(1 "Actual Log CP" 2 "Fitted Log CP" 3 "Forecasted Log CP") ring(0) pos(5) col(1)) /// // Improved legend position
    ytitle("Log Corporate Profits") ///
    xtitle("Quarterly Date")
	
	* (Optional) To see the forecast values in the original scale (Billions of Dollars)
gen forecast_CP = exp(forecast_lcp)
list qdate forecast_CP if !sample_indicator
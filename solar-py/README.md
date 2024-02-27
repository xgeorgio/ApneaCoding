Title:<br/>
<b>Solar flux hourly estimation in Python</b>

Description:<br/>
<p>Estimating the solar intensity on the Earth's surface at a specific geographical area is perhaps the most important factor when planning for solar panel installations. Given an accurate predictive model, it can enable the efficient integration of solar power units in the electrical grid, as well as predicting high and low periods in electric power output.</p>
<p>In this example, an analytical model is implemented for solar flux estimation, with code simple enough to be integrated even in ultra-low spec IoT computing such as Arduino/RPi MCUs. Specifically, the full model with full-year 24-hour orbital calculations have been approximated with a system of polynomial/periodic functions, parameterized here for the Mediterranean region (optimized for Lat/Log). The code demonstrates a 365-days, 24-hour flux hourly estimation plus graphical plots of the corresponding time series; it can be easily adapted to a function for "snappshot" estimation on demand based on a specific timestamp.</p>
<p>* Details: ASHRAE, "HVAC Applications Handbook", American Society of Heating, Refrigerating and Air Conditioning Engineers (Atlanta, US: 1995).</p>

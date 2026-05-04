# Task 3 Dual-Sensor Version

This is an improved version of Task 3 using two MCP9700A temperature sensors.

## Connection

- Sensor 1 output -> `A0`
- Sensor 2 output -> `A1`
- Both sensor power pins -> `5V`
- Both sensor ground pins -> `GND`
- Green LED -> `D8`
- Yellow LED -> `D9`
- Red LED -> `D10`

## Idea

The original Task 3 used only one sensor, so the rate of change could jump because of noise.  
This version reads both sensors and uses the average temperature:

\[
T_{avg} = \frac{T_{A0} + T_{A1}}{2}
\]

This makes the prediction more stable and gives a simple check by comparing the two sensor values.

## What the program does

1. Read the voltages from `A0` and `A1`
2. Convert both voltages to temperatures
3. Calculate the average temperature
4. Smooth the data using recent values
5. Estimate the temperature rate of change
6. Predict the temperature after 5 minutes
7. Control the LEDs:
   - Green: temperature is in the comfort range and stable
   - Red: temperature is rising faster than `+4 degC/min`
   - Yellow: temperature is falling faster than `-4 degC/min`

## MATLAB command

```matlab
a = arduino("COM4","Uno");
temp_prediction_dual(a);
```

## Why this version is better

- Two sensors help reduce random noise
- Average temperature is more stable than one reading
- Prediction is less likely to jump to unrealistic values
- The difference between the two sensors can be observed during testing

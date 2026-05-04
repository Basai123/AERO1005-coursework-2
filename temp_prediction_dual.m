function temp_prediction_dual(a)
% TEMP_PREDICTION_DUAL Predict temperature using two sensors.
% This function reads two MCP9700A temperature sensors connected to A0 and
% A1. It uses the average temperature to reduce noise, estimates the rate
% of change, predicts the temperature after 5 minutes, and controls the
% LEDs. Use temp_prediction_dual(a), where a is the Arduino object created
% in the main script. Stop the function manually in MATLAB when testing is
% complete.

% Sensor pins.
sensorPin1 = "A0";
sensorPin2 = "A1";

% LED pins.
greenPin = "D8";
yellowPin = "D9";
redPin = "D10";

% MCP9700A constants.
V0 = 0.5;
TC = 0.01;

% Arrays for time and averaged temperature.
timeData = [];
temperatureData = [];

% Start timer.
startTime = tic;

% Settings used to make the result more stable.
sampleCount = 5;
smoothSize = 8;
rateWindow = 12;

while 1
    % Time since the function started.
    currentTime = toc(startTime);

    % Read sensor 1 several times and average the voltage.
    totalVoltage1 = 0;
    for k = 1:sampleCount
        totalVoltage1 = totalVoltage1 + readVoltage(a, sensorPin1);
        pause(0.02);
    end
    voltage1 = totalVoltage1 / sampleCount;

    % Read sensor 2 several times and average the voltage.
    totalVoltage2 = 0;
    for k = 1:sampleCount
        totalVoltage2 = totalVoltage2 + readVoltage(a, sensorPin2);
        pause(0.02);
    end
    voltage2 = totalVoltage2 / sampleCount;

    % Convert voltages to temperatures.
    temperature1 = (voltage1 - V0) / TC;
    temperature2 = (voltage2 - V0) / TC;

    % Use the average of both sensors as the main temperature value.
    averageTemperature = (temperature1 + temperature2) / 2;
    sensorDifference = abs(temperature1 - temperature2);

    % Store time and temperature data.
    timeData(end + 1) = currentTime;
    temperatureData(end + 1) = averageTemperature;

    % Smooth the average temperature.
    if length(temperatureData) < smoothSize
        smoothTemperature = averageTemperature;
    else
        smoothTemperature = mean(temperatureData(end - smoothSize + 1:end));
    end

    % Estimate the rate of change from recent data.
    if length(temperatureData) < rateWindow
        rateValue = 0;
    else
        oldTemp = mean(temperatureData(end - rateWindow + 1:end - rateWindow/2));
        newTemp = mean(temperatureData(end - rateWindow/2 + 1:end));
        deltaTime = timeData(end) - timeData(end - rateWindow/2);
        rateValue = (newTemp - oldTemp) / deltaTime;
    end

    % Predict the temperature after 5 minutes.
    predictedTemperature = smoothTemperature + rateValue * 300;
    ratePerMinute = rateValue * 60;

    % Print the results.
    fprintf("Sensor A0 temperature = %.2f C\n", temperature1);
    fprintf("Sensor A1 temperature = %.2f C\n", temperature2);
    fprintf("Average temperature = %.2f C\n", smoothTemperature);
    fprintf("Sensor difference = %.2f C\n", sensorDifference);
    fprintf("Rate of change = %.2f C/s\n", rateValue);
    fprintf("Predicted temperature in 5 minutes = %.2f C\n\n", predictedTemperature);

    % LED control logic.
    if smoothTemperature >= 18 && smoothTemperature <= 24 && abs(ratePerMinute) <= 4
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);

    elseif ratePerMinute > 4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);

    elseif ratePerMinute < -4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);

    else
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    end

    % Update every second.
    pause(1);
end

end

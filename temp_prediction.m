function temp_prediction(a)
% TEMP_PREDICTION Predict future temperature and control LEDs.
% This function reads temperature data from an MCP9700A sensor connected
% to an Arduino, estimates the temperature rate of change, and predicts
% the temperature after 5 minutes. It also controls three LEDs to show
% whether the temperature is stable in the comfort range, increasing too
% quickly, or decreasing too quickly. Use temp_prediction(a), where a is
% the Arduino object created in the main script. Stop the function
% manually in MATLAB when testing is complete.

% Define the sensor pin and LED pins.
sensorPin = "A0";
greenPin = "D8";
yellowPin = "D9";
redPin = "D10";

% MCP9700A constants used to convert voltage into temperature.
V0 = 0.5;
TC = 0.01;

% Create arrays to store time and temperature values.
timeData = [];
temperatureData = [];

% Start a timer for the monitoring loop.
startTime = tic;

% averageSize is used to smooth the temperature values.
% rateWindow is used to estimate the temperature rate of change.
% sampleCount is the number of voltage readings averaged each cycle.
% Larger windows make the output more stable but also less responsive.
averageSize = 10;
rateWindow = 20;
sampleCount = 5;

while 1
    % Find the time since the function started.
    currentTime = toc(startTime);

    % Read the sensor several times and take the average voltage.
    totalVoltage = 0;
    for k = 1:sampleCount
        totalVoltage = totalVoltage + readVoltage(a, sensorPin);
        pause(0.05);
    end
    voltageValue = totalVoltage / sampleCount;

    % Convert the voltage value to temperature.
    temperatureValue = (voltageValue - V0) / TC;

    % Add the new temperature reading to the arrays.
    % These stored values are used later for smoothing and prediction.
    timeData(end + 1) = currentTime;
    temperatureData(end + 1) = temperatureValue;

    % Smooth the temperature using the latest values.
    if length(temperatureData) < averageSize
        smoothTemperature = temperatureValue;
    else
        smoothTemperature = mean(temperatureData(end - averageSize + 1:end));
    end

    % Estimate the rate of change using a larger window to reduce noise.
    if length(temperatureData) < rateWindow
        rateValue = 0;
    else
        oldAverage = mean(temperatureData(end - rateWindow + 1:end - rateWindow/2));
        newAverage = mean(temperatureData(end - rateWindow/2 + 1:end));
        deltaTime = timeData(end) - timeData(end - rateWindow/2);
        rateValue = (newAverage - oldAverage) / deltaTime;
    end

    % Predict the temperature after 5 minutes.
    predictedTemperature = smoothTemperature + rateValue * 300;
    ratePerMinute = rateValue * 60;

    % Print the temperature, rate of change and prediction.
    fprintf("Current temperature = %.2f C\n", smoothTemperature);
    fprintf("Rate of change = %.2f C/s\n", rateValue);
    fprintf("Predicted temperature in 5 minutes = %.2f C\n\n", predictedTemperature);

    % Green LED stays on when the temperature is stable in the comfort range.
    if smoothTemperature >= 18 && smoothTemperature <= 24 && abs(ratePerMinute) <= 4
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);

    % Red LED stays on when the temperature is increasing too quickly.
    elseif ratePerMinute > 4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);

    % Yellow LED stays on when the temperature is decreasing too quickly.
    elseif ratePerMinute < -4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);

    % Turn all LEDs off in any other case.
    else
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    end

    % Wait for about 1 second before the next update.
    pause(1);
end

end

function temp_monitor(a)
% TEMP_MONITOR Monitor temperature using an Arduino.
% This function reads temperature data from an MCP9700A sensor connected
% to the Arduino, shows a live temperature graph, and controls three LEDs.
% The green LED stays on when the temperature is between 18 and 24 degC.
% The yellow LED blinks when the temperature is below 18 degC.
% The red LED blinks when the temperature is above 24 degC.
% Use temp_monitor(a), where a is the Arduino object created in the main
% script. Stop the function manually in MATLAB when testing is complete.

% Define the sensor pin and the three LED pins.
sensorPin = "A0";
greenPin = "D8";
yellowPin = "D9";
redPin = "D10";

% MCP9700A constants used to convert voltage into temperature.
V0 = 0.5;
TC = 0.01;

% Create arrays to store the live graph data.
timeData = [];
temperatureData = [];

% Start the timer for the live plot.
startTime = tic;

% Quick LED test at the start.
% This is useful for checking that each LED is wired to the correct pin.
writeDigitalPin(a, greenPin, 1);
pause(0.5);
writeDigitalPin(a, greenPin, 0);
writeDigitalPin(a, yellowPin, 1);
pause(0.5);
writeDigitalPin(a, yellowPin, 0);
writeDigitalPin(a, redPin, 1);
pause(0.5);
writeDigitalPin(a, redPin, 0);

% Open a new figure window for the live graph.
figure;

while 1
    % Work out how much time has passed since the function started.
    elapsedTime = toc(startTime);

    % Read the sensor voltage and convert it to temperature.
    voltageValue = readVoltage(a, sensorPin);
    temperatureValue = (voltageValue - V0) / TC;

    % Add the new point to the arrays.
    % These arrays grow during the loop and are used for the live graph.
    timeData(end + 1) = elapsedTime;
    temperatureData(end + 1) = temperatureValue;

    % Update the live graph.
    plot(timeData, temperatureData, "b-", "LineWidth", 1.5);
    xlabel("Time (s)");
    ylabel("Temperature (degC)");
    title("Live Temperature Monitor");
    grid on;
    xlim([0 max(10, elapsedTime + 1)]);
    ylim([0 50]);
    drawnow;

    % Green LED stays on when temperature is in the comfort range.
    if temperatureValue >= 18 && temperatureValue <= 24
        fprintf("Temperature = %.2f C, green LED on\n", temperatureValue);
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
        pause(1);

    % Yellow LED blinks when the temperature is below the range.
    elseif temperatureValue < 18
        fprintf("Temperature = %.2f C, yellow LED blinking\n", temperatureValue);
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        pause(0.5);
        writeDigitalPin(a, yellowPin, 0);
        pause(0.5);

    % Red LED blinks faster when the temperature is above the range.
    else
        fprintf("Temperature = %.2f C, red LED blinking\n", temperatureValue);
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);
        pause(0.25);
        writeDigitalPin(a, redPin, 0);
        pause(0.25);
        writeDigitalPin(a, redPin, 1);
        pause(0.25);
        writeDigitalPin(a, redPin, 0);
        pause(0.25);
    end
end

end

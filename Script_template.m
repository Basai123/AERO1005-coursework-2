% Mingchen Sun
% ssyms7@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Establish communication between MATLAB and Arduino UNO.
% Change COM4 if your Arduino appears on a different port.
% a = arduino("COM4", "Uno");
% disp(a);

% Preliminary task hardware setup:
% Arduino GND -> breadboard negative rail (-)
% Arduino 5V  -> breadboard positive rail (+)
% LED long leg (anode)  -> Arduino digital pin D8
% LED short leg (cathode) -> 220 ohm resistor -> breadboard negative rail (-)

% ledPin = "D8";

% Manual command-window test examples:
% writeDigitalPin(a, ledPin, 1);
% writeDigitalPin(a, ledPin, 0);

% for k = 1:10
%     writeDigitalPin(a, ledPin, 1);
%     pause(0.5);
%     writeDigitalPin(a, ledPin, 0);
%     pause(0.5);
% end

% disp("Preliminary Arduino communication and LED blinking test complete.");

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Establish communication before starting Task 1.
% a = arduino("COM4", "Uno");
% disp(a);

% MCP9700A temperature sensor connection:
% Vcc -> 5V, GND -> GND, Vout -> A0

% Set the data collection time and sampling interval.
% duration = 600;
% sampleInterval = 1;

% The sensor output is connected to analogue pin A0.
% sensorPin = "A0";

% These will be printed on the screen and in the text file.
% locationName = "Ningbo";
% logDate = "04/05/2026";

% MCP9700A constants from the lecture notes.
% V0 = 0.5;
% TC = 0.01;

% Create arrays to store time, voltage and temperature.
% numSamples = duration / sampleInterval + 1;
% timeData = zeros(numSamples, 1);
% voltageData = zeros(numSamples, 1);
% temperatureData = zeros(numSamples, 1);

% This loop reads the sensor every second.
% The voltage is then converted into temperature.
% for k = 1:numSamples
%     % Store the current time in seconds.
%     timeData(k) = (k - 1) * sampleInterval;
%
%     % Read the voltage from the sensor.
%     voltageData(k) = readVoltage(a, sensorPin);
%
%     % Convert the voltage value to temperature.
%     temperatureData(k) = (voltageData(k) - V0) / TC;
%
%     % Wait for 1 second before taking the next reading.
%     if k < numSamples
%         pause(sampleInterval);
%     end
% end

% Find the minimum, maximum and average temperature.
% minTemp = min(temperatureData);
% maxTemp = max(temperatureData);
% avgTemp = mean(temperatureData);

% Plot temperature against time and save the plot.
% figure;
% plot(timeData, temperatureData, "b-", "LineWidth", 1.5);
% xlabel("Time (s)");
% ylabel("Temperature (degC)");
% title("Capsule Temperature Over Time");
% grid on;
% saveas(gcf, "task1_temperature_plot.png");

% Create Minute 0, Minute 1, ... for the formatted output.
% minuteMarks = 0:(duration / 60);
% minuteTemperatures = zeros(1, length(minuteMarks));

% Pick out the temperature at each whole minute.
% for idx = 1:length(minuteMarks)
%     % Each minute is 60 seconds, and MATLAB indexing starts from 1.
%     sampleIndex = minuteMarks(idx) * 60 + 1;
%     minuteTemperatures(idx) = temperatureData(sampleIndex);
% end

% Open the text file for writing.
% fileID = fopen("capsule_temperature.txt", "w");

% Create the heading text using sprintf.
% headerText = sprintf("Data logging initiated - %s\nLocation - %s\n\n", logDate, locationName);

% Print the heading to the command window and write it to the file.
% fprintf("%s", headerText);
% fprintf(fileID, "%s", headerText);

% Print the temperature for each whole minute.
% for idx = 1:length(minuteMarks)
%     % Create one block of formatted text for each minute.
%     minuteText = sprintf("Minute\t%2d\nTemperature\t%.2f C\n\n", ...
%         minuteMarks(idx), minuteTemperatures(idx));
%     fprintf("%s", minuteText);
%     fprintf(fileID, "%s", minuteText);
% end

% Print the summary values and closing line.
% summaryText = sprintf("Max temp\t%.2f C\nMin temp\t%.2f C\nAverage temp\t%.2f C\n\nData logging terminated\n", ...
%     maxTemp, minTemp, avgTemp);
% fprintf("%s", summaryText);
% fprintf(fileID, "%s", summaryText);

% Close the file.
% fclose(fileID);

% Reopen the file and display it again to check the output.
% fileID = fopen("capsule_temperature.txt", "r");
% checkText = fscanf(fileID, "%c");
% fclose(fileID);
% disp(checkText);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Connect the LEDs as follows:
% Green LED  -> D8
% Yellow LED -> D9
% Red LED    -> D10
% The sensor output remains connected to A0.

a = arduino("COM4", "Uno");
disp(a);

% Run the temperature monitoring function.
% Stop the function manually in MATLAB when you have collected enough data.
temp_monitor(a);


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Use the same sensor and LED connections as in Task 2.
% Green LED  -> D8
% Yellow LED -> D9
% Red LED    -> D10
% Sensor     -> A0

a = arduino("COM4", "Uno");
disp(a);

% Run the temperature prediction function.
% Stop the function manually in MATLAB when you have collected enough data.
temp_prediction(a);


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here

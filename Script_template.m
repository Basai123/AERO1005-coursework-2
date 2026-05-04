% Mingchen Sun
% ssyms7@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Establish communication between MATLAB and Arduino UNO.
% Change COM4 if your Arduino appears on a different port.
a = arduino("COM4", "Uno");
disp(a);

% Preliminary task hardware setup:
% Arduino GND -> breadboard negative rail (-)
% Arduino 5V  -> breadboard positive rail (+)
% LED long leg (anode)  -> Arduino digital pin D8
% LED short leg (cathode) -> 220 ohm resistor -> breadboard negative rail (-)

ledPin = "D8";

% Manual command-window test examples:
% writeDigitalPin(a, ledPin, 1);
% writeDigitalPin(a, ledPin, 0);

for k = 1:10
    writeDigitalPin(a, ledPin, 1);
    pause(0.5);
    writeDigitalPin(a, ledPin, 0);
    pause(0.5);
end

disp("Preliminary Arduino communication and LED blinking test complete.");

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here

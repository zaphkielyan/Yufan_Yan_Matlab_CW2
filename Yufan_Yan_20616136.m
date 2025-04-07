% Yufan Yan
% ssyyy17@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear
% Connect to Arduino on COM3, using an Uno board
a = arduino('COM3', 'Uno');  % Replace 'COM3' with the actual port if different

% Turn the LED on (connected to digital pin D9)
writeDigitalPin(a, 'D9', 1);  % Send HIGH signal (5V) to pin D9
pause(1);                     % Wait for 1 second

% Turn the LED off
writeDigitalPin(a, 'D9', 0);  % Send LOW signal (0V) to pin D9
pause(1);                     % Wait for 1 second

% Make the LED blink 10 times
for i = 1:10
    writeDigitalPin(a, 'D9', 1);  % LED ON
    pause(0.5);                   % Wait 0.5 seconds
    writeDigitalPin(a, 'D9', 0);  % LED OFF
    pause(0.5);                   % Wait 0.5 seconds
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here
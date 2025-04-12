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
clear
% Connect to Arduino
a = arduino('COM3', 'Uno');

% Set acquisition duration to 601 seconds (to include minute 10 exactly)
duration = 601;

% Initialize temperature array
temperature = zeros(1, duration);

% Read and store temperature data every second
for i = 1:duration
    voltage = readVoltage(a, 'A0');       % Read analog voltage from A0
    temp = (voltage - 0.5) * 100;         % Convert voltage to temperature using MCP9700A formula
    temperature(i) = temp;                % Store temperature value
    pause(1);                             % Wait 1 second
end

% Calculate statistical values
maxTemp = max(temperature);
minTemp = min(temperature);
avgTemp = mean(temperature);

% Plot temperature vs time graph
time = 0:duration-1;  % Time vector in seconds
plot(time, temperature);
xlabel('Time (s)');              % Label for x-axis
ylabel('Temperature (°C)');      % Label for y-axis
title('Cabin Temperature vs Time');  % Graph title

% Print formatted information to command window
fprintf('Data logging initiated - 5/3/2024\n');
fprintf('Location - Nottingham\n\n');

for i = 0:10
    index = i * 60 + 1;  % Index for each minute (0 to 10)
    fprintf('Minute\t%d\n', i);
    fprintf('Temperature\t%.2f C\n\n', temperature(index));
end

fprintf('Max temp\t%.2f C\n', maxTemp);
fprintf('Min temp\t%.2f C\n', minTemp);
fprintf('Average temp\t%.2f C\n\n', avgTemp);
fprintf('Data logging terminated\n');

% Write the same information to a text file
fileID = fopen('cabin_temperature.txt', 'w');  % Open file in write mode

fprintf(fileID, 'Data logging initiated - 5/3/2024\n');
fprintf(fileID, 'Location - Nottingham\n\n');

for i = 0:10
    index = i * 60 + 1;
    fprintf(fileID, 'Minute\t%d\n', i);
    fprintf(fileID, 'Temperature\t%.2f C\n\n', temperature(index));
end

fprintf(fileID, 'Max temp\t%.2f C\n', maxTemp);
fprintf(fileID, 'Min temp\t%.2f C\n', minTemp);
fprintf(fileID, 'Average temp\t%.2f C\n\n', avgTemp);
fprintf(fileID, 'Data logging terminated\n');

fclose(fileID);  % Close the file



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
doc temp_monitor
a = arduino('COM3', 'Uno'); 
temp_monitor(a);


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
clear
doc temp_prediction
a = arduino('COM3', 'Uno');
temp_prediction(a);


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here
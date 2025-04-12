% temp_prediction - Predicts temperature trends and alerts based on rate of change.
%
% This function continuously monitors temperature using an MCP9700A sensor
% connected to analog pin A0. It calculates the rate of temperature change
% (°C/s) and predicts the temperature after 5 minutes assuming constant rate.
% It activates a green LED (D10) if the temperature is stable and within the
% comfort range (18–24°C), a red LED (D8) if temperature is rising faster than
% 4°C/min, or a yellow LED (D12) if temperature is falling faster than -4°C/min.

function temp_prediction(a)

    % Pin assignments
    sensorPin = 'A0';
    redLED = 'D8';
    greenLED = 'D10';
    yellowLED = 'D12';

    % Initialize pins
    configurePin(a, redLED, 'DigitalOutput');
    configurePin(a, greenLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');

    % Initialize temperature logging
    timeLog = [];
    tempLog = [];
    tStart = tic;

    while true
        % Time and temperature reading
        tNow = toc(tStart);
        voltage = readVoltage(a, sensorPin);
        temp = (voltage - 0.5) * 100;

        % Log time and temperature
        timeLog(end+1) = tNow;
        tempLog(end+1) = temp;

        % Calculate rate of change (°C/s) over last 10 seconds using linear regression
        rate = 0;
        if length(timeLog) >= 10
            recentT = timeLog(end-9:end);
            recentTemp = tempLog(end-9:end);
            p = polyfit(recentT, recentTemp, 1);  % Linear fit
            rate = p(1);  % Slope = dT/dt
        end

        % Convert rate to °C/min
        rate_per_min = rate * 60;

        % Predict future temperature after 5 minutes
        predictedTemp = temp + rate * 300;  % 300s = 5 minutes

        % Display info
        fprintf('Current Temp: %.2f°C | Rate: %.2f°C/min | Predicted in 5 min: %.2f°C\n', ...
                temp, rate_per_min, predictedTemp);

        % LED status logic
        if abs(rate_per_min) < 4 && temp >= 18 && temp <= 24
            % Stable and within comfort range
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, redLED, 0);
            writeDigitalPin(a, yellowLED, 0);
        elseif rate_per_min > 4
            % Heating too fast
            writeDigitalPin(a, redLED, 1);
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
        elseif rate_per_min < -4
            % Cooling too fast
            writeDigitalPin(a, yellowLED, 1);
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, redLED, 0);
        else
            % No specific alert
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, redLED, 0);
            writeDigitalPin(a, yellowLED, 0);
        end

        pause(1);  % Sample every second
    end
end

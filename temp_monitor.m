% temp_monitor  Monitors temperature in real time and controls LEDs.
%
% This function continuously reads temperature data from an MCP9700A sensor
% connected to analog pin A0. It displays a live plot of the temperature and
% controls three LEDs based on the current temperature range: green for 18–24°C
% (steady), yellow below 18°C (blinking at 0.5 s), and red above 24°C 
% (blinking at 0.25 s). The function runs in an infinite loop and is intended
% to visualize and respond to environmental temperature changes in real time.

function temp_monitor(a)
% temp_monitor - Real-time temperature monitor using MCP9700A and LEDs
% This function continuously monitors the temperature using the MCP9700A sensor
% and controls three LEDs (red - D8, green - D10, yellow - D12) based on temperature range.

    % Define pin assignments
    redLED = 'D8';
    greenLED = 'D10';
    yellowLED = 'D12';
    sensorPin = 'A0';

    % Set all LED pins as output
    configurePin(a, redLED, 'DigitalOutput');
    configurePin(a, greenLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');

    % Create initial plot
    figure;
    hPlot = plot(nan, nan, '-b');  % empty plot
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Real-time Cabin Temperature Monitoring');
    grid on;
    xlim([0 60]);  % Start with 1 minute window
    ylim([10 40]); % Expected temperature range

    % Initialize variables
    timeLog = [];
    tempLog = [];
    tStart = tic;
    lastToggleYellow = 0;
    lastToggleRed = 0;
    yellowState = 0;
    redState = 0;

    % Start continuous monitoring loop
    while true
        % Get elapsed time
        tNow = toc(tStart);

        % Read voltage and convert to temperature
        voltage = readVoltage(a, sensorPin);
        temp = (voltage - 0.5) * 100;

        % Log data
        timeLog(end+1) = tNow;
        tempLog(end+1) = temp;

        % Update plot
        set(hPlot, 'XData', timeLog, 'YData', tempLog);
        xlim([max(0, tNow-60) tNow+5]);  % Scroll window
        drawnow;

        % Temperature-based LED control
        if temp >= 18 && temp <= 24
            % Green LED on, others off
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);

        elseif temp < 18
            % Blink yellow LED at 0.5s interval
            if tNow - lastToggleYellow >= 0.5
                yellowState = ~yellowState;
                writeDigitalPin(a, yellowLED, yellowState);
                lastToggleYellow = tNow;
            end
            % Turn off others
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, redLED, 0);

        elseif temp > 24
            % Blink red LED at 0.25s interval
            if tNow - lastToggleRed >= 0.25
                redState = ~redState;
                writeDigitalPin(a, redLED, redState);
                lastToggleRed = tNow;
            end
            % Turn off others
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
        end

        % Delay a bit before next sample (approx. 1s total loop time)
        pause(0.05);  % Short delay to avoid CPU overload
    end
end

clc
clear
close all

a = arduino();
if ~exist('a','var')
    clear a
    a = arduino();
end
disp('PORT INIT');

disp('LED #1: blinking');
blinking = 0;
for i = 1:4
    blinking = not(blinking);
    writeDigitalPin(a,'D11',blinking);
    pause(0.1);
    disp(blinking);
end

disp('LED #2: brightening/dimming');
max_brightness = 5;
max_time = 10;
brightness_step = (max_brightness-0)/max_time;
for i = 1:max_time
    writePWMVoltage(a, 'D11', i*brightness_step);
    pause(0.1);
end

for i = 1:max_time
    writePWMVoltage(a, 'D11', max_brightness-i*brightness_step);
    pause(0.1);
end

disp('LED #3: control by variable resistor');
time = 100;
while time > 0
    voltage = readVoltage(a, 'A0');
    writePWMVoltage(a, 'D11', voltage);
    
    time = time - 1;
    pause(0.1);
end

disp('LED #4: control by pull up button');
configurePin(a, 'D12', 'pullup');
time = 100;
while time > 0
    key_status = readDigitalPin(a, 'D12');
    
    if key_status == 0
        playTone(a, 'D11', 1200, 1);
    else
        % Change duration to zero to mute the speaker
        playTone(a, 'D11', 1200, 0);
    end
    
    time = time - 1;
    pause(0.1);
end

disp('CLEAR PORT');
clear a

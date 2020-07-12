function [] = CochlearImplant1(soundFile)

info = audioinfo(soundFile);
[inputSound,frequency] = audioread(soundFile);
soundSize = size(inputSound,2);
if soundSize == 2
    inputSound = inputSound(:);
end
sound(inputSound,frequency);
if frequency > 16000
    [P,Q] = rat(16000/frequency);
    newFrequency = resample(frequency,P,Q);
end
newFrequency = int32(newFrequency);
soundFileString = convertCharsToStrings(soundFile);
soundFileName = strsplit(soundFileString,'.');
%filename= append('output',soundFileName(1),'.wav');
filename = strcat('output',soundFileName(1),'.wav');
audiowrite(filename,inputSound,newFrequency);
[newInputSound,newFrequency] = audioread(filename);
sound(inputSound,newFrequency);
x = 1:1:length(newInputSound);
y = newInputSound(x);
figure('Name', 'SoundWave Plot');
plot(x,y);
title('Sound Waveform')
xlabel('Sample Number')
ylabel('Sample Value')
%cosine plot
freq = 1000;
period = 2*(1/freq);
duration = info.Duration;
timeStep = 1/info.SampleRate;
t = 0:timeStep:duration;
t2 = 0:timeStep:period;
newSignalArray = zeros(1,info.TotalSamples);
w = (2*pi*freq);
timeLength = size(t,2);
for i = 1:timeLength
    time = t(i);
    newSignalArray(i) = cos(w*time);
end 
sound(newSignalArray,info.SampleRate);
cosineWave = cos(w*t2);
figure('Name', 'Cosine Plot');
plot(t2,cosineWave);
title('1kHz Sound Wave')
xlabel('Sample Number')
ylabel('y=cos(2*pi*1000*t)')
end


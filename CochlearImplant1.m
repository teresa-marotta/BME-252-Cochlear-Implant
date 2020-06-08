function [] = CochlearImplant1(soundFile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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
filename= append('output',soundFileName(1),'.wav');
audiowrite(filename,inputSound,newFrequency);
[newInputSound,newFrequency] = audioread(filename);
sound(inputSound,newFrequency);
x = 1:1:length(newInputSound);
y = newInputSound(x);
plot(x,y);
%cosine plot
freq = 1000;
T = 1/freq;
period = 2*T;
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
sound(newSignalArray, freq);
cosineWave = cos(w*t2);
plot(t2,cosineWave);
end


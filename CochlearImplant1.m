function [] = CochlearImplant1(soundFile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

info = audioinfo(soundFile);
[inputSound,frequency] = audioread(soundFile);
soundSize = size(inputSound,2);
if soundSize == 2
    inputSound = inputSound(:);
end
%sound(inputSound,frequency);
if frequency > 16000
    [P,Q] = rat(16000/frequency);
    newFrequency = resample(frequency,P,Q);
end
newFrequency = int32(newFrequency);
soundFileString = convertCharsToStrings(soundFile);
soundFileName = strsplit(soundFileString,'.');
filename= append('output',soundFileName(1),'.wav');
audiowrite(filename,inputSound,newFrequency);
[inputSound,newFrequency] = audioread(filename);
%sound(inputSound,newFrequency);
dt = 1/newFrequency;
t = 0:dt:(length(inputSound)*dt)-dt;
% plot(t,inputSound); xlabel('Seconds'); ylabel('Amplitude');
% figure
% plot(psd(spectrum.periodogram,inputSound,'Fs',newFrequency,'NFFT',length(inputSound)));
%cosine plot
inputSize = size(inputSound,1);
fs = frequency;
t = 1/fs:inputSize;
w = (2*pi)/fs;%1000;
amp = inputSound; %info.SampleRate;
newSignal = cos(w*t);
plot(newSignal);

end


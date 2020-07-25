function phase3CI(soundFile,chooseFilt)
%%%phase 1
info = audioinfo(soundFile);
[inputSound,frequency] = audioread(soundFile);
soundSize = size(inputSound,2);
if soundSize == 2
    inputSound = inputSound(:);
end
% sound(inputSound,frequency);
if frequency > 16000
    inputSound = resample(inputSound,16000,frequency);
    newFrequency = 16000;
end
% soundFileString = convertCharsToStrings(soundFile);
% soundFileName = strsplit(soundFileString,'.');
% filename = strcat('output',soundFileName(1),'.wav');
% audiowrite(filename,inputSound,16000);
% [newInputSound,newFrequency] = audioread(filename);
% sound(inputSound,newFrequency);
x = 1:1:length(inputSound);
y = inputSound(x);
figure('Name', 'SoundWave Plot');
plot(x,y);
title('Sound Waveform')
xlabel('Sample Number')
ylabel('Sample Value')

%%%phase 2
%Task 5, option for one of four filters
numChan = 21;
lowerFreq = 100;
upperFreq = 7900;
soundChannels = zeros(numChan,length(inputSound));
if chooseFilt == 1 
    channels = [100,200,300,400,510,630,770,920,1080,1270,1480,1720,2000,2320,2700,3150,3700,4400,5300,6400,7700,7900];
    for i=1:numChan
        filt = butterworth(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
    end
elseif chooseFilt == 2
    channels = linspace(lowerFreq,upperFreq,numChan+1);
     for i=1:numChan
        filt = butterworth(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
     end
elseif chooseFilt == 3 
    channels = [100,200,300,400,510,630,770,920,1080,1270,1480,1720,2000,2320,2700,3150,3700,4400,5300,6400,7700,7900];
    for i=1:numChan
        filt = chebyshev(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
    end   
else 
    channels = linspace(lowerFreq,upperFreq,numChan+1);
    for i=1:numChan
        filt = chebyshev(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
    end   
end
%task 6
lowestChannel = soundChannels(1,:);
highestChannel = soundChannels(numChan,:);
channelSize = length(lowestChannel);
%Plot lowest sound channel
figure('Name', 'Lowest Sound Channel');
plot(lowestChannel,'b');
title('Lowest Sound Channel')
xlabel('Sample Number')
ylabel('Sample Value')
%Plot highest sound channel
figure('Name', 'Highest Sound Channel');
plot(highestChannel,'r');
title('Highest Sound Channel');
xlabel('Sample Number');
ylabel('Sample Value');

%Task 7
rectifiedSounds = abs(soundChannels);
%Task 8
lowPass = lowPassFilter;
envelopeSoundChannels = zeros(numChan,length(inputSound));
for j = 1:numChan
    envelopeSoundChannels(j,:) = filter(lowPass,rectifiedSounds(j,:));
end 
lowEnvSoundChannel = envelopeSoundChannels(1,:);
highEnvSoundChannel = envelopeSoundChannels(numChan,:);

%Plot lowest sound channel
figure('Name', 'Lowest Sound Channel');
plot(lowEnvSoundChannel,'b');
title('Lowest Sound Channel')
xlabel('Sample Number')
ylabel('Sample Value')
%Plot highest sound channel
figure('Name', 'Highest Sound Channel');
plot(highEnvSoundChannel,'r');
title('Highest Sound Channel');
xlabel('Sample Number');
ylabel('Sample Value');

%%%phase3
%task 10

cosineSignals = zeros(numChan,channelSize);
for  k = 1:numChan
    centreFreq = channels(k) + ((channels(k+1)-channels(k))/2);
    duration = channelSize/16000;
    %period = 1/centreFreq;
    %rectSound = envelopeSoundChannels(k,:);
    x = linspace(0, duration, channelSize);
    w = (2*pi*centreFreq);
    cosineSignals(k,:) = cos(w*x);
end
%task 11
AMSignals = zeros(numChan,channelSize);
for i = 1:numChan
        rectSound = envelopeSoundChannels(i, :);
        modulator = cosineSignals(i, :);
        AMSignals(i, :) = rectSound .* modulator;
end 
%task 12 
outputSound = zeros(1,channelSize);
for i = 1:numChan
    outputSound = outputSound + AMSignals(i,:);
end 
sound(outputSound,newFrequency);
%%save
soundFileString = convertCharsToStrings(soundFile);
soundFileName = strsplit(soundFileString,'.');
filename = strcat('output',soundFileName(1),'.wav');
audiowrite(filename,outputSound,16000);
%[newInputSound,newFrequency] = audioread(filename);

end 
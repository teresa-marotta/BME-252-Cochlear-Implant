function phase3Iteration(soundFile,chooseFilt)
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

% sound(inputSound,newFrequency);
x = 1:1:length(inputSound);
y = inputSound(x);
% % figure('Name', 'SoundWave Plot');
% % plot(x,y);
% % title('Sound Waveform')
% % xlabel('Sample Number')
% % ylabel('Sample Value')
%%%phase 2
%Task 5, option for one of four filters
numChan = 21;
lowerFreq = 100;
upperFreq = 7900;
%soundChannels = zeros(numChan,length(inputSound));
if chooseFilt == 1 
    channels = [100,200,300,400,510,630,770,920,1080,1270,1480,1720,2000,2320,2700,3150,3700,4400,5300,6400,7700,7900];
    tic
    for i=1:numChan
        filt = butterworth(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
    end
elseif chooseFilt == 2
    channels = [100,300,510,770,1080,1480,2000,2700,3700,5300,7700,7900];
    numChan = 10;
    tic
     for i=1:numChan
        filt =  butterworth(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(i,:)=transpose(filteredChannel);
     end
elseif chooseFilt == 3 
    %channels = [100,200,300,400,510,630,770,920,1080,1270,1480,1720,2000,2320,2700,3150,3700,4400,5300,6400,7700,7900];
    numChan = 41;
         %chanNum = 41;
%     channels = [110,190,210,290,310,390,...
%         411,499,522,618,644,756,785,905,936,1064,1099,1251,1291,1459,1504,...
%         1696,1748,1972,2032,2288,2358,2662,2745,3105,3205,3645,3770,4330,4490,5210,...
%         5410,6290,6530,7570,7720,7880];
    channels = [120,180,220,280,320,380,422,488,534,606,658,742,...
        800,890,952,1048,1118,1232,1312,1438,1528,1672,1776,1944,2064,2256,...
        2396,2624,2790,3060,3260,3590,3840,4260,4580,5120,...   
        5520,6180,6660,7440,7740,7860];
    i = 1;
    j = 1;
    tic
    while i <= numChan
        filt = butterworth(channels(i),channels(i+1));
        filteredChannel = filter(filt,inputSound);
        soundChannels(j,:)=transpose(filteredChannel);
        i = i + 2;
        j = j + 1;
    end     
end
%task 6
% % lowestChannel = soundChannels(1,:);
% % highestChannel = soundChannels(numChan,:);
%channelSize = length(lowestChannel);
%Plot lowest sound channel
% % figure('Name', 'Lowest Sound Channel');
% % plot(lowestChannel,'b');
% % title('Lowest Sound Channel')
% % xlabel('Sample Number')
% % ylabel('Sample Value')
%Plot highest sound channel
% % figure('Name', 'Highest Sound Channel');
% % plot(highestChannel,'r');
% % title('Highest Sound Channel');
% % xlabel('Sample Number');
% % ylabel('Sample Value');

%Task 7
rectifiedSounds = abs(soundChannels);
%Task 8
lowPass = lowPassFilter;
envelopeSoundChannels = zeros(numChan,length(inputSound));
for j = 1:numChan
    envelopeSoundChannels(j,:) = filter(lowPass,rectifiedSounds(j,:));
end 
toc
lowEnvSoundChannel = envelopeSoundChannels(1,:);
highEnvSoundChannel = envelopeSoundChannels(numChan,:);

%Plot lowest sound channel
% % figure('Name', 'Lowest Sound Channel');
% % plot(lowEnvSoundChannel,'b');
% % title('Lowest Sound Channel')
% % xlabel('Sample Number')
% % ylabel('Sample Value')
%Plot highest sound channel
% % figure('Name', 'Highest Sound Channel');
% % plot(highEnvSoundChannel,'r');
% % title('Highest Sound Channel');
% % xlabel('Sample Number');
% % ylabel('Sample Value');

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
plot(outputSound,'b')
absOutputSound = abs(outputSound);
maxAmp = max(absOutputSound,[],'all');
newOutput = outputSound/maxAmp;
%sound(newOutput,newFrequency);
%%save
soundFileString = convertCharsToStrings(soundFile);
soundFileName = strsplit(soundFileString,'.');
filename = strcat('output',soundFileName(1),'.wav');
audiowrite(filename,outputSound,16000);

end 
function phase2CI(soundFile,chooseFilt)
%Since we have 4 options of filters, we have a chooseFilt input to have the
%ability to choose which bandpass filter we want to use.
%1 for butterworth with unequal band ranges
%2 for butterworth with equal band ranges
%3 for chebyshev with unequal band ranges
%4 for chebyshev with equal band ranges

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
%filename= append('output',soundFileName(1),'.wav');
filename = strcat('output',soundFileName(1),'.wav');
audiowrite(filename,inputSound,newFrequency);
[newInputSound,newFrequency] = audioread(filename);
%sound(inputSound,newFrequency);
x = 1:1:length(newInputSound);
y = newInputSound(x);
figure('Name', 'SoundWave Plot');
plot(x,y);
title('Sound Waveform')
xlabel('Sample Number')
ylabel('Sample Value')
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
figure('Name', 'Lowest Sound Channel AC');
plot(lowEnvSoundChannel,'b');
title('Lowest Sound Channel AC')
xlabel('Sample Number')
ylabel('Sample Value')
%Plot highest sound channel
figure('Name', 'Highest Sound Channel AC');
plot(highEnvSoundChannel,'r');
title('Highest Sound Channel AC');
xlabel('Sample Number');
ylabel('Sample Value');
end 

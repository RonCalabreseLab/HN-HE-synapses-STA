
% Anca Doloc - 26 Aug. 2011
% Terrence Michael Wright, September 10th, 2008
% sta_1_master.m This script will serve as the master script for spike
% triggered average analysis. this is the first of four separate scripts.
% depending on what analysis you want to run, this script will
% call the other appropriate scripts to perform the analysis.

% For notes on how to use this script, please move down to the end of the
% file

% clear existing variables in the matlab workspace.
% clear all;

%%%%%%%%%%%%%%Inputs for sta_2 and sta_5%%%%%%%%%%%%%%%
% Step 2: Which analysis do you want to perform? 0=global sta (i.e., use all
% the spikes to generate the spike-triggered average, 1=indiv sta (i.e.,
% perform a spike triggered average across all spikes and across all bursts
% in the file, 2=analyze median spike +/- some spikes
sta_method = 0;


%Step 3: Tell if you want to correct for the correction or triggering
%traces
invertCorrectionTrace=-1;% Put -1 if you want to invert the signal for the Correction Trace
invertTriggeringTrace=1;% Put -1 if you want to invert the signal for the Triggering Trace

% Step 4: determine the number of spikes to discard at the beginning and
% the end of the burst. this component of the program is a little nebulous
% to me
NdiscardFirst=0; %Number of first spikes in the burst to be discarded
NdiscardLast=0;  %Number of last spikes in the burst to be discarded
% this part of the code does not work correctly....it simply subtracts the
% last # of spikes from the total...it DOES NOT take them from each burst!!
% this needs to be corrected

% Step 5: Setup the window for ipsc detection. These settings are critical
% for determing how far before or after the ipsc maximum the script will
% look for a local minimum or maximum. Note that these times are in
% seconds! If you get an error that the script cannot continue because of
% negative indices, you will need to tweak these settings to make sure that
% you are analyzing enough time to get the IPSC. I suggest you start with
% IntervalNeg.

%%% TO DO: Angela - individual for each channel
IntervalPosLocal=0.05;  %Window to detect minimum of IPSC after maximum
IntervalNegLocal=0.03; %0.015 for HN7/Window to detect minimum of IPSC before maximum
IntervalPos=0.45;  %%% ADM: this cannot be set up in the window
IntervalNeg=0.15;  %%% ADM: this cannot be set up in the window
IntervalPSCNeg=0.01;
IntervalPos2=0.45;  %set delay here (for the individual spike triggered average sta_3)
IntervalNeg2=0.15; %set delay here (for the individual spike triggered average sta_3)

%%% TO DO: Angela - individual for each channel
% Step 6: Burst characteristics. Input the interburst interval, lower
% threshold, upper threshold and interspike interval
ISIburst=2;      %Determine minimum interburst interval in seconds
thresh=30;%200;%30;      % signals above this level are spikes
peak=250;%1500;%250;      %spikes above this level will not be detected

%To avoid single spike detected twice in extracellular recording
Trefractory=0.01; % was 0.01

% Step 7: these values are used to set the plot parameters
% Names for x axis on the spike plot (figure 1)
Overlay=0;% Overlay=1; to make it overlay with every trace
DataNames='Voltage';
x_label='Time,  [Sec]';

% Spike-triggered average plot settings (figure 2 if you do either global
% or median sta
yL=-0.1; %minimum ipsc amplitude on the y-axis
yH=0.2; %maximum ipsc amplitude on the y-axis
xlabel1='Delay, [sec]'; %x-axis label
ylabel1='I_{syn}, [nA]'; %y-axis label

%Step 8: Input whether or not you have a correction trace (you should have one if there is a fourth column o data
CorrectionTrace=0;%1 means yes, 0 means no, and -1 if you have four columns of data, but don't want to use the correction trace
CT=CorrectionTrace;  %%% ADM: this cannot be set up in the window

% Step 9: Do you want to calculate the minimum of the global average?
% i.e. Do you want to calc. an IPSC (choose 0 or max) or an EPSC (choose 1 or min)?
CalcMin=0;% 1 means yes, 0 means no

%%%%%%%%%%%%%%%% Inputs for STA 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 10: if you are generating the individual spike triggered averags
% (i.e., if you put a "1" in step 1). then these variables help to set up
% the plot. for the most part, you shouldnt need to change anything,
% however you may want to change the number of ipsc's displayed on a single
% page. this is done with the TracesPerPage variable. you may also want to
% change the NBurstsStat variable. Not sure what that is for!

% % Overlay=0;% Overlay=1; to make it overlay with every trace
% %yL=-1.;
% %yH=4.1;%Parameters of the graph;
FntS = 6; %FontSize
TracesPerPage = 10;
NBurstsStat=3;
PrintNext = 1;%Every PrintNext will be printed on the figure.

%%%%%%%%%%%%%%%% Inputs for STA 4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% TO DO: Angela - individual for each channel
% Step 11: input the number of spikes to add to the median spike in the
% burst. these values will correspond to the number of spikes before and
% after the burst that get included in the analysis.
spike_subtractor=10; 
spike_adder=10;


% sta_5_global_sta





%%%%%%%%%%%%%%%%%%Comments on this M-file%%%%%%%%%%%%%%%%%%%%%%%
%This script will call the following scripts: sta_2_spike_detector,
%sta_3_individual_sta and sta_4_median_spike_finder. the descriptions of
%these files can be found at the top of those scripts.

%This script is to input the data file and perform the spike-triggered
%analysis. the format of the data that you input is as follows: you will
%need to use a *.atf file. The .atf file should have time as its first
%column, extracellular voltage in the second column, and the ipsc data
% from the postsynaptic heart motor neuron in the third
%column. as of now, the scripts will only allow you to do one heart
%interneuron, but i would like to allow for the analysis of more than one.

% another opportunity for improvement would be to make this a function,
% particularly b/c there are some parts of the script that i am not sure
% work the way they are supposed to. for example, im not convinced that all
% spikes are used even when you select 0 for NdiscardFirst and
% NdiscardLast. it appears to me as though the first spike in each burst is
% always discarded regardless of what you input for those variables

% this script controls the inputs that will be needed regardless of which
% type of analysis you want to run....therefore i recommend that you DO NOT
% TOUCH the other scripts unless you absolutely want to change how the
% analysis is done. furthermore, i recommend that you keep all of these
% scripts together and that you DO NOT RENAME THEM, as the filenames are
% set according to the order in which they are potentially used.

% PLEASE NOTE: As of now, there is no burst provision, meaning that the
% scripts will not count the number of spikes required to be called a
% burst. This may come up if you have one or two stray spikes in your file,
% either during the interburst interval, or at the ends of your file. What
% this means is that if you have a spike all by itself at the end of the
% file, these scripts will count that as a burst, and you will get an
% error. One way to know this is the case is to check the error: if the
% error occurs in sta_4_median_spike_finder, this is most likely due to a
% stray spike being counted as a burst

% Finally, a note about the different sta methods. When analyzing the
% global sta, these scripts will analyze n-1 bursts in your file.
% Basically, the script can only determine a burst beginning once an
% interspike interval greater than the interburst interval has been
% determined. Therefore, the script throws away the first burst. Secondly,
% the discard spikes function works in the following way: the number
% included in NspikesdicasrdFirst takes that number of spikes off of the
% beginning of EACH burst; NspikesdiscardLast only takes off the last
% number of spikes that you select. It DOES NOT remove that number of
% spikes from the end of each burst








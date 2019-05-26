function PopulationChambersVideoAnalysis_16052019(VideoBehavioralpath,VideoBehavioralfileList,handles)
%TRACKMICEPOPULATIONSUMMARY Summary of this function goes here
% The aim of this function is to summarize the results of several rodents extracted by the software TrackRodent.

TotalFrames=str2num(get(handles.TotalNumberOfFramesToAnalyzeEditBox,'string'));
FirstFrameForAnalysis=1;  %%%% relative to the first frame chosen for analysis in "TrackRodent"

Stimulus1TotalExplorationPopulationSummary=[];
Stimulus2TotalExplorationPopulationSummary=[];
Stimulus1ExplorationAlongTimePopulationSummary=[];
Stimulus2ExplorationAlongTimePopulationSummary=[];
Stimulus1DurationsOfInteractions={};
Stimulus2DurationsOfInteractions={};
TotalDistance=[];
Compartment1TotalOccupationPopulationSummary=[];
Compartment2TotalOccupationPopulationSummary=[];
Compartment1OccupationAlongTimePopulationSummary=[];
Compartment2OccupationAlongTimePopulationSummary=[];
StatisticalTextDescription={};

TestName=get(handles.TestNameEditBox,'string');
Stimulus1Name=get(handles.Stimulus1NameEditBox,'string');
Stimulus2Name=get(handles.Stimulus2NameEditBox,'string');


for FileNumber=1:length(VideoBehavioralfileList)
    
   handles.MainStatusTextEditBox.String=['Analyzing file number ' num2str(FileNumber)];
   pause(0.2);
   
   filenameBehavioral=[VideoBehavioralpath,VideoBehavioralfileList{1,FileNumber}];
   load(filenameBehavioral);
   
% % % % % % % %        Stimulus 1

      StimuliExplorationAlongTime=[];
      StimuliExplorationAlongTime(TimesOfStimuliExploration{1,1}-StartingFrameForAnalysisNum+1)=1;
      StimuliExplorationAlongTime=[0,StimuliExplorationAlongTime(FirstFrameForAnalysis:end),zeros(1,TotalFrames+1-length(StimuliExplorationAlongTime))];
      StimuliExplorationAlongTime=StimuliExplorationAlongTime(1:TotalFrames-FirstFrameForAnalysis+3);
      
      Compartment1AlongTime=[];
      Compartment1AlongTime(TimesInDifferentCompartments{1,1}-StartingFrameForAnalysisNum+1)=1;
      Compartment1AlongTime=[0,Compartment1AlongTime(FirstFrameForAnalysis:end),zeros(1,TotalFrames+1-length(Compartment1AlongTime))];
      Compartment1AlongTime=Compartment1AlongTime(1:TotalFrames-FirstFrameForAnalysis+3);
      
      InteractionStartEndTimes=[];
      InteractionStartTimeLocations=[];
      InteractionEndTimeLocations=[];
      InteractionStartEndTimes=diff([0,StimuliExplorationAlongTime,0]);
      InteractionStartTimeLocations=find(InteractionStartEndTimes==1);
      InteractionEndTimeLocations=find(InteractionStartEndTimes==-1);
      for i=1:(length(InteractionStartTimeLocations)-1)
          if InteractionStartTimeLocations(i+1)-InteractionEndTimeLocations(i)<15
             InteractionStartEndTimes(InteractionStartTimeLocations(i+1))=0;
             InteractionStartEndTimes(InteractionEndTimeLocations(i))=0;
             StimuliExplorationAlongTime(InteractionEndTimeLocations(i):(InteractionStartTimeLocations(i+1)-1))=1;
          end
      end
      
      %%% population summary of stimulus 1 exploration along time
      Stimulus1ExplorationAlongTimePopulationSummary=[Stimulus1ExplorationAlongTimePopulationSummary;StimuliExplorationAlongTime];
      %%% population summary of stimulus 1 exploration total time
      Stimulus1TotalExplorationPopulationSummary(1,FileNumber)=length(find(StimuliExplorationAlongTime)); 
      %%% population summary of stimulus 1 number of interactions and duration of interactions entire time
      Stimulus1DurationsOfInteractions{1,FileNumber}=find(InteractionStartEndTimes==-1)-find(InteractionStartEndTimes==1);
      %%% population summary of compartment 1 occupation along time
      Compartment1OccupationAlongTimePopulationSummary=[Compartment1OccupationAlongTimePopulationSummary;Compartment1AlongTime];
      %%% population summary of compartment 1 occupation total time
      Compartment1TotalOccupationPopulationSummary(1,FileNumber)=length(find(Compartment1AlongTime)); 
      
% % % % % % % % %       Stimulus 2 
      
      StimuliExplorationAlongTime=[];
      StimuliExplorationAlongTime(TimesOfStimuliExploration{1,2}-StartingFrameForAnalysisNum+1)=1;
      StimuliExplorationAlongTime=[0,StimuliExplorationAlongTime(FirstFrameForAnalysis:end),zeros(1,TotalFrames+1-length(StimuliExplorationAlongTime))];
      StimuliExplorationAlongTime=StimuliExplorationAlongTime(1:TotalFrames-FirstFrameForAnalysis+3);

      Compartment2AlongTime=[];
      Compartment2AlongTime(TimesInDifferentCompartments{1,2}-StartingFrameForAnalysisNum+1)=1;
      Compartment2AlongTime=[0,Compartment2AlongTime(FirstFrameForAnalysis:end),zeros(1,TotalFrames+1-length(Compartment2AlongTime))];
      Compartment2AlongTime=Compartment2AlongTime(1:TotalFrames-FirstFrameForAnalysis+3);
      
      InteractionStartEndTimes=[];
      InteractionStartTimeLocations=[];
      InteractionEndTimeLocations=[];
      InteractionStartEndTimes=diff([0,StimuliExplorationAlongTime,0]);
      InteractionStartTimeLocations=find(InteractionStartEndTimes==1);
      InteractionEndTimeLocations=find(InteractionStartEndTimes==-1);
      for i=1:(length(InteractionStartTimeLocations)-1)
          if InteractionStartTimeLocations(i+1)-InteractionEndTimeLocations(i)<15
             InteractionStartEndTimes(InteractionStartTimeLocations(i+1))=0;
             InteractionStartEndTimes(InteractionEndTimeLocations(i))=0;
             StimuliExplorationAlongTime(InteractionEndTimeLocations(i):(InteractionStartTimeLocations(i+1)-1))=1;
          end
      end
      
      %%% population summary of stimulus 1 exploration along time
      Stimulus2ExplorationAlongTimePopulationSummary=[Stimulus2ExplorationAlongTimePopulationSummary;StimuliExplorationAlongTime];
      %%% population summary of stimulus 1 exploration total time
      Stimulus2TotalExplorationPopulationSummary(1,FileNumber)=length(find(StimuliExplorationAlongTime));  
      %%% population summary of stimulus 1 number of interactions and duration of interactions entire time
      Stimulus2DurationsOfInteractions{1,FileNumber}=find(InteractionStartEndTimes==-1)-find(InteractionStartEndTimes==1);
      %%% population summary of compartment 2 occupation along time
      Compartment2OccupationAlongTimePopulationSummary=[Compartment2OccupationAlongTimePopulationSummary;Compartment2AlongTime];
      %%% population summary of compartment 2 occupation total time
      Compartment2TotalOccupationPopulationSummary(1,FileNumber)=length(find(Compartment2AlongTime)); 
      
      %%%% Total distance 
      TotalDistance(1,FileNumber)=sum(sqrt((diff(MouseLocationCenterOfBody(:,1))).^2+(diff(MouseLocationCenterOfBody(:,2))).^2));
         
end

 NumOfSubplot=0;
 if handles.PopulationTotalTimeOfStimuliInvestigationCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationInvestigationOfStimuliAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationShortVsLongBoutsInvestigationTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationOneSecHistBoutsDurationCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationShortVsLongBoutsRDI_Checkbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationBoutsLessThen6SecAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationBouts6to19secAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationBoutsMoreThen19SecAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationChamberMeanBoutLength_Checkbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationShortVsLongIntervalsTotalTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationOneSecHistIntervalsEachStimulusCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationShortVsLongIntervalsRDICheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationIntervalsLessThen5SecAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationIntervals5to20SecAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationIntervalsMoreThen20SecAlongTimeCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.TransitionsBetweenStimuliRasterCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.TransitionsAlongTime1MinbinCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+1;
 end
 if handles.PopulationHeatMapInteractionDurationCheckbox.Value==1
    NumOfSubplot=NumOfSubplot+2;
 end

 NumOfSubplotsRows=ceil(NumOfSubplot/3);     
 
 figure('Name',['Test name: ' TestName '  Number of files analyzed: ' num2str(FileNumber)]);

 CurrentSubplot=1;
 if handles.PopulationTotalTimeOfStimuliInvestigationCheckbox.Value==1
    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
    hold on; 
    bar(1,mean(Stimulus1TotalExplorationPopulationSummary)/30,'g');
    bar(2,mean(Stimulus2TotalExplorationPopulationSummary)/30,'r');
    errorbar(1,mean(Stimulus1TotalExplorationPopulationSummary)/30,std(Stimulus1TotalExplorationPopulationSummary,0,2)/30/sqrt(length(Stimulus1TotalExplorationPopulationSummary)),'g');
    errorbar(2,mean(Stimulus2TotalExplorationPopulationSummary)/30,std(Stimulus2TotalExplorationPopulationSummary,0,2)/30/sqrt(length(Stimulus2TotalExplorationPopulationSummary)),'r');
    xlim([0 3]);
    ax = gca;
    ax.XTick=[1 2];
    ax.XTickLabel = ({Stimulus1Name,Stimulus2Name});
    text(1,mean(Stimulus1TotalExplorationPopulationSummary)/30+500/30,['n=' num2str(length(Stimulus1TotalExplorationPopulationSummary))]);
    text(2,mean(Stimulus2TotalExplorationPopulationSummary)/30+500/30,['n=' num2str(length(Stimulus2TotalExplorationPopulationSummary))]);
    ylabel({'Investigation time','(Sec)'});
    title('Total time of stimuli investigation');
    hold off; 
    CurrentSubplot=CurrentSubplot+1; 
 end

 if handles.PopulationInvestigationOfStimuliAlongTimeCheckbox.Value==1
    clear Stimulus1ExplorationAlongTimePopulationSummaryBined Stimulus2ExplorationAlongTimePopulationSummaryBined
    BinSize=600; %%% size of bin (num of frames) for exploration along session anaylsis.
    Stimulus1ExplorationAlongTimePopulationSummaryBined(1:1:size(Stimulus1ExplorationAlongTimePopulationSummary,1),1:1:floor(size(Stimulus1ExplorationAlongTimePopulationSummary,2)/600))=0;
    for l=1:size(Stimulus1ExplorationAlongTimePopulationSummary,1)
       for i=1:size(Stimulus1ExplorationAlongTimePopulationSummary,2)
          if mod(i,BinSize)==0
             Stimulus1ExplorationAlongTimePopulationSummaryBined(l,i/600)=sum(Stimulus1ExplorationAlongTimePopulationSummary(l,(i-BinSize+1):i),2);
          end
       end
    end
    Stimulus2ExplorationAlongTimePopulationSummaryBined(1:1:size(Stimulus2ExplorationAlongTimePopulationSummary,1),1:1:floor(size(Stimulus2ExplorationAlongTimePopulationSummary,2)/600))=0;
    for l=1:size(Stimulus2ExplorationAlongTimePopulationSummary,1)
       for i=1:size(Stimulus2ExplorationAlongTimePopulationSummary,2)
          if mod(i,BinSize)==0
             Stimulus2ExplorationAlongTimePopulationSummaryBined(l,i/600)=sum(Stimulus2ExplorationAlongTimePopulationSummary(l,(i-BinSize+1):i),2);
          end
       end
    end

    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
    hold on;
    errorbar(20:20:size(Stimulus1ExplorationAlongTimePopulationSummaryBined,2)*20,mean(Stimulus1ExplorationAlongTimePopulationSummaryBined/30,1),...
       std(Stimulus1ExplorationAlongTimePopulationSummaryBined/30,0,1)/sqrt(size(Stimulus1TotalExplorationPopulationSummary/30,2)),'g')
    errorbar(20:20:size(Stimulus1ExplorationAlongTimePopulationSummaryBined,2)*20,mean(Stimulus2ExplorationAlongTimePopulationSummaryBined/30,1),...
       std(Stimulus2ExplorationAlongTimePopulationSummaryBined/30,0,1)/sqrt(size(Stimulus2TotalExplorationPopulationSummary/30,2)),'r')
    xlim([0 size(Stimulus1ExplorationAlongTimePopulationSummaryBined,2)*20+10]);
    ylim([0 20]);
    xlabel('Time (20 Sec bins)')
    ylabel({'Investigation time','(Sec)'})
    title('Investigation of stimuli along time')
    legend([Stimulus1Name ' (n=' num2str(size(Stimulus1ExplorationAlongTimePopulationSummary,1)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus2ExplorationAlongTimePopulationSummary,1)) ')'])
    hold off;
    CurrentSubplot=CurrentSubplot+1;
 end

 Bins=300:600:length(Stimulus1ExplorationAlongTimePopulationSummary)-300;
 TransitionTimesForHistAll=[];
 TransitionTimesForHistAllForRaster={};
 Stimulus1OnlyIntervalsNumHistAllAnimal=[];
 Stimulus2OnlyIntervalsNumHistAllAnimal=[];
 Stimulus1OnlyIntervalsTimeHistAllAnimal=[];
 Stimulus2OnlyIntervalsTimeHistAllAnimal=[];
 Stimulus1EpoksTimesDurationsBinsAll=[];
 Stimulus2EpoksTimesDurationsBinsAll=[];
 Stimulus1OnlyIntervalTimesDurationsBinsAll=[];
 Stimulus2OnlyIntervalTimesDurationsBinsAll=[];
 Stimulus1InteractionHeattMap=Stimulus1ExplorationAlongTimePopulationSummary;
 Stimulus2InteractionHeattMap=Stimulus2ExplorationAlongTimePopulationSummary;
 Stimulus1EpokeDurationHist1SecAll=[];
 Stimulus2EpokeDurationHist1SecAll=[];
 Stimulus1OnlyIntervalTimesDurations1SecAll=[];
 Stimulus2OnlyIntervalTimesDurations1SecAll=[];
 Stimulus1IntervalTimesBothStimuli1SecAll=[];
 Stimulus2IntervalTimesBothStimuli1SecAll=[];
 
 for i=1:size(Stimulus1ExplorationAlongTimePopulationSummary,1)
   
    Stimulus1EpoksTimesDurationsBins(1:1:round(length(Stimulus1ExplorationAlongTimePopulationSummary)/1800),1:1:4)=0;
    Stimulus2EpoksTimesDurationsBins(1:1:round(length(Stimulus2ExplorationAlongTimePopulationSummary)/1800),1:1:4)=0; 
    Stimulus1Epoks=[];
    Stimulus1OnlyIntervalsSingleAnimal=[]; %%% Intervals after stimulus 1 which takes into account only epokes of stimulus 1 (the intervals include stimulus 2 epokes)
    Stimulus1IntervalsBetweenAllEpokes=[];  %%% Intervals after stimulus 1 which are between epokes of both stimulus 1 and stimulus 2
    Stimulus1InteractionsStart=[]; 
    Stimulus1InteractionsEnd=[];
    Stimulus2Epoks=[];
    Stimulus2OnlyIntervalsSingleAnimal=[];  %%% Intervals after stimulus 2 which takes into account only epokes of stimulus 2 (the intervals include stimulus 1 epokes)
    Stimulus2IntervalsBetweenAllEpokes=[]; %%% Intervals after stimulus 2 which are between epokes of both stimulus 1 and stimulus 2
    Stimulus1IntervalTimesDurationsBins(1:1:round(length(Stimulus1ExplorationAlongTimePopulationSummary)/1800),1:1:3)=0;
    Stimulus2IntervalTimesDurationsBins(1:1:round(length(Stimulus2ExplorationAlongTimePopulationSummary)/1800),1:1:3)=0; 
    Stimulus2InteractionsStart=[]; 
    Stimulus2InteractionsEnd=[];
   
    Stimulus1InteractionsStart=find(diff(Stimulus1ExplorationAlongTimePopulationSummary(i,:))==1);
    Stimulus1InteractionsEnd=find(diff(Stimulus1ExplorationAlongTimePopulationSummary(i,:))==-1);
    if ~isempty(Stimulus1InteractionsStart) && ~isempty(Stimulus1InteractionsEnd)
       if Stimulus1InteractionsStart(1)>Stimulus1InteractionsEnd(1)
          Stimulus1InteractionsEnd=Stimulus1InteractionsEnd(2:end);
       end
       if Stimulus1InteractionsStart(end)>Stimulus1InteractionsEnd(end)
          Stimulus1InteractionsStart=Stimulus1InteractionsStart(1:end-1);
       end
    else
       %%% Do nothing 
    end
    Stimulus2InteractionsStart=find(diff(Stimulus2ExplorationAlongTimePopulationSummary(i,:))==1);
    Stimulus2InteractionsEnd=find(diff(Stimulus2ExplorationAlongTimePopulationSummary(i,:))==-1);
    if ~isempty(Stimulus2InteractionsStart) && ~isempty(Stimulus2InteractionsEnd)
       if Stimulus2InteractionsStart(1)>Stimulus2InteractionsEnd(1)
          Stimulus2InteractionsEnd=Stimulus2InteractionsEnd(2:end);
       end
       if Stimulus2InteractionsStart(end)>Stimulus2InteractionsEnd(end)
          Stimulus2InteractionsStart=Stimulus2InteractionsStart(1:end-1);
       end
    else
       %%% Do nothing 
    end
    
    TwoStimuliExplorationAlongTimePopulationSummary=[];
    InteractionsIntervalsAllStimuli=[];
    TwoStimuliInteractionsStart=[]; 
    TwoStimuliInteractionsEnd=[];
    TwoStimuliExplorationAlongTimePopulationSummary=Stimulus1ExplorationAlongTimePopulationSummary(i,:)+Stimulus2ExplorationAlongTimePopulationSummary(i,:);
    TwoStimuliInteractionsStart=find(diff(TwoStimuliExplorationAlongTimePopulationSummary)==1);
    TwoStimuliInteractionsEnd=find(diff(TwoStimuliExplorationAlongTimePopulationSummary)==-1);
    if TwoStimuliInteractionsStart(1)>TwoStimuliInteractionsEnd(1)
       TwoStimuliInteractionsEnd=TwoStimuliInteractionsEnd(2:end);
    end
    if TwoStimuliInteractionsStart(end)>TwoStimuliInteractionsEnd(end)
       TwoStimuliInteractionsStart=TwoStimuliInteractionsStart(1:end-1);
    end
   
    %%%%%%%%%% Interactions with different bouts durations along time %%%%%
    TempStimulus1EpokeDurationHist1Sec(1:1:60)=0;
    TempStimulus2EpokeDurationHist1Sec(1:1:60)=0;
    Stimulus1Epoks=(Stimulus1InteractionsStart(1:end)-Stimulus1InteractionsEnd(1:end))*-1;
    Stimulus2Epoks=(Stimulus2InteractionsStart(1:end)-Stimulus2InteractionsEnd(1:end))*-1;
    for Stimulus1EpoksNum=1:length(Stimulus1Epoks)
        TempStimulus1EpokeTimeHist=[];
        TempStimulus1EpokeDurationHist=[];
        TempStimulus1EpokeTimeHist=histcounts(Stimulus1InteractionsStart(Stimulus1EpoksNum),0:1800:size(Stimulus1ExplorationAlongTimePopulationSummary,2));
        TempStimulus1EpokeDurationHist=histcounts(Stimulus1Epoks(Stimulus1EpoksNum)/30,[0 6 19 120]);
        TempStimulus1EpokeDurationHist1Sec=TempStimulus1EpokeDurationHist1Sec+(histcounts(Stimulus1Epoks(Stimulus1EpoksNum)/30,[0:1:60]))*Stimulus1Epoks(Stimulus1EpoksNum)/30;
        Stimulus1EpoksTimesDurationsBins(find(TempStimulus1EpokeTimeHist),find(TempStimulus1EpokeDurationHist))=Stimulus1EpoksTimesDurationsBins(find(TempStimulus1EpokeTimeHist),find(TempStimulus1EpokeDurationHist))+Stimulus1Epoks(Stimulus1EpoksNum)/30;    
    end
    for Stimulus2EpoksNum=1:length(Stimulus2Epoks)
        TempStimulus2EpokeTimeHist=[];
        TempStimulus2EpokeDurationHist=[];
        TempStimulus2EpokeTimeHist=histcounts(Stimulus2InteractionsStart(Stimulus2EpoksNum),0:1800:length(Stimulus1ExplorationAlongTimePopulationSummary));
        TempStimulus2EpokeDurationHist=histcounts(Stimulus2Epoks(Stimulus2EpoksNum)/30,[0 6 19 120]);
        TempStimulus2EpokeDurationHist1Sec=TempStimulus2EpokeDurationHist1Sec+(histcounts(Stimulus2Epoks(Stimulus2EpoksNum)/30,[0:1:60]))*Stimulus2Epoks(Stimulus2EpoksNum)/30;
        Stimulus2EpoksTimesDurationsBins(find(TempStimulus2EpokeTimeHist),find(TempStimulus2EpokeDurationHist))=Stimulus2EpoksTimesDurationsBins(find(TempStimulus2EpokeTimeHist),find(TempStimulus2EpokeDurationHist))+Stimulus2Epoks(Stimulus2EpoksNum)/30;    
    end
   
    Stimulus1EpoksTimesDurationsBinsAll(:,:,i)=Stimulus1EpoksTimesDurationsBins;
    Stimulus2EpoksTimesDurationsBinsAll(:,:,i)=Stimulus2EpoksTimesDurationsBins;
    Stimulus1EpokeDurationHist1SecAll=[Stimulus1EpokeDurationHist1SecAll;TempStimulus1EpokeDurationHist1Sec];
    Stimulus2EpokeDurationHist1SecAll=[Stimulus2EpokeDurationHist1SecAll;TempStimulus2EpokeDurationHist1Sec]; 
    %%%%%%%%%%%%%%% Heat Map for bouts durations along time %%%%

    for Stimulus1EpoksNum=1:length(Stimulus1Epoks)
       Stimulus1InteractionHeattMap(i,Stimulus1InteractionsStart(Stimulus1EpoksNum):Stimulus1InteractionsEnd(Stimulus1EpoksNum))=Stimulus1Epoks(Stimulus1EpoksNum)/30;
    end
    for Stimulus2EpoksNum=1:length(Stimulus2Epoks)
       Stimulus2InteractionHeattMap(i,Stimulus2InteractionsStart(Stimulus2EpoksNum):Stimulus2InteractionsEnd(Stimulus2EpoksNum))=Stimulus2Epoks(Stimulus2EpoksNum)/30;
    end
    
     %%%%%%%%%%%%%%% Mean length of bouts durations along time (1 min bin)  assuming 30 Hz frame rate  %%%%

    Stimulus1MeanBoutLengthAlongTime(i,1:1:floor(TotalFrames/30/60))=0;
    Stimulus2MeanBoutLengthAlongTime(i,1:1:floor(TotalFrames/30/60))=0;
    BothStimulusMeanBoutLengthAlongTime(i,1:1:floor(TotalFrames/30/60))=0;
    TotalNumOfMinutesForSession=ceil(max(Stimulus1InteractionsStart)/30/60);
    for NumOfMinutes=1:TotalNumOfMinutesForSession
       Stimulus1MeanBoutLengthAlongTime(i,NumOfMinutes)=mean(Stimulus1Epoks(find(Stimulus1InteractionsStart/30/60>(NumOfMinutes-1) & Stimulus1InteractionsStart/30/60<=(NumOfMinutes))))/30;
    end
    for NumOfMinutes=1:TotalNumOfMinutesForSession
       Stimulus2MeanBoutLengthAlongTime(i,NumOfMinutes)=mean(Stimulus2Epoks(find(Stimulus2InteractionsStart/30/60>(NumOfMinutes-1) & Stimulus2InteractionsStart/30/60<=(NumOfMinutes))))/30;
    end
    for NumOfMinutes=1:TotalNumOfMinutesForSession
       BothStimulusMeanBoutLengthAlongTime(i,NumOfMinutes)=mean([Stimulus1Epoks(find(Stimulus1InteractionsStart/30/60>(NumOfMinutes-1) & Stimulus1InteractionsStart/30/60<=(NumOfMinutes))),Stimulus2Epoks(find(Stimulus2InteractionsStart/30/60>(NumOfMinutes-1) & Stimulus2InteractionsStart/30/60<=(NumOfMinutes)))])/30;
    end
    Stimulus1MeanBoutLengthAlongTime(i,find(isnan(Stimulus1MeanBoutLengthAlongTime(i,:))))=0;
    Stimulus2MeanBoutLengthAlongTime(i,find(isnan(Stimulus2MeanBoutLengthAlongTime(i,:))))=0;
    BothStimulusMeanBoutLengthAlongTime(i,find(isnan(BothStimulusMeanBoutLengthAlongTime(i,:))))=0;

   
   %%%%%%%%%% Intervals with different durations along time - For each stimulus %%%%%
    TempStimulus1OnlyIntervalHist1Sec(1:1:60)=0;
    TempStimulus2OnlyIntervalHist1Sec(1:1:60)=0;
    Stimulus1OnlyIntervalsSingleAnimal=Stimulus1InteractionsStart(2:end)-Stimulus1InteractionsEnd(1:end-1);
    Stimulus2OnlyIntervalsSingleAnimal=Stimulus2InteractionsStart(2:end)-Stimulus2InteractionsEnd(1:end-1);
    for Stimulus1InterNum=1:length(Stimulus1OnlyIntervalsSingleAnimal)
        TempStimulus1IntervalTimeHist=[];
        TempStimulus1IntervalDurationHist=[];
        TempStimulus1IntervalTimeHist=histcounts(Stimulus1InteractionsEnd(Stimulus1InterNum),0:1800:size(Stimulus1ExplorationAlongTimePopulationSummary,2));
        TempStimulus1IntervalDurationHist=histcounts(Stimulus1OnlyIntervalsSingleAnimal(Stimulus1InterNum)/30,[0 5 20 120]);
        TempStimulus1OnlyIntervalHist1Sec=TempStimulus1OnlyIntervalHist1Sec+(histcounts(Stimulus1OnlyIntervalsSingleAnimal(Stimulus1InterNum)/30,[0:1:60]))*Stimulus1OnlyIntervalsSingleAnimal(Stimulus1InterNum)/30;
        Stimulus1IntervalTimesDurationsBins(find(TempStimulus1IntervalTimeHist),find(TempStimulus1IntervalDurationHist))=Stimulus1IntervalTimesDurationsBins(find(TempStimulus1IntervalTimeHist),find(TempStimulus1IntervalDurationHist))+Stimulus1OnlyIntervalsSingleAnimal(Stimulus1InterNum)/30;    
    end
    for Stimulus2InterNum=1:length(Stimulus2OnlyIntervalsSingleAnimal)
        TempStimulus2IntervalTimeHist=[];
        TempStimulus2IntervalDurationHist=[];
        TempStimulus2IntervalTimeHist=histcounts(Stimulus2InteractionsEnd(Stimulus2InterNum),0:1800:size(Stimulus2ExplorationAlongTimePopulationSummary,2));
        TempStimulus2IntervalDurationHist=histcounts(Stimulus2OnlyIntervalsSingleAnimal(Stimulus2InterNum)/30,[0 5 20 120]);
        TempStimulus2OnlyIntervalHist1Sec=TempStimulus2OnlyIntervalHist1Sec+(histcounts(Stimulus2OnlyIntervalsSingleAnimal(Stimulus2InterNum)/30,[0:1:60]))*Stimulus2OnlyIntervalsSingleAnimal(Stimulus2InterNum)/30;
        Stimulus2IntervalTimesDurationsBins(find(TempStimulus2IntervalTimeHist),find(TempStimulus2IntervalDurationHist))=Stimulus2IntervalTimesDurationsBins(find(TempStimulus2IntervalTimeHist),find(TempStimulus2IntervalDurationHist))+Stimulus2OnlyIntervalsSingleAnimal(Stimulus2InterNum)/30;    
    end
   
    Stimulus1OnlyIntervalTimesDurationsBinsAll(:,:,i)=Stimulus1IntervalTimesDurationsBins;
    Stimulus2OnlyIntervalTimesDurationsBinsAll(:,:,i)=Stimulus2IntervalTimesDurationsBins;
    Stimulus1OnlyIntervalTimesDurations1SecAll=[Stimulus1OnlyIntervalTimesDurations1SecAll;TempStimulus1OnlyIntervalHist1Sec];
    Stimulus2OnlyIntervalTimesDurations1SecAll=[Stimulus2OnlyIntervalTimesDurations1SecAll;TempStimulus2OnlyIntervalHist1Sec]; 
    
    %%%%%%%%%% Intervals with different durations along time - For Both stimuli %%%%%
    for l=1:length(TwoStimuliInteractionsEnd)-1
       if find(Stimulus1InteractionsEnd==TwoStimuliInteractionsEnd(l))
          Stimulus1IntervalsBetweenAllEpokes=[Stimulus1IntervalsBetweenAllEpokes, -(TwoStimuliInteractionsEnd(l)-TwoStimuliInteractionsStart(l+1))];
       end
       if find(Stimulus2InteractionsEnd==TwoStimuliInteractionsEnd(l))
          Stimulus2IntervalsBetweenAllEpokes=[Stimulus2IntervalsBetweenAllEpokes, -(TwoStimuliInteractionsEnd(l)-TwoStimuliInteractionsStart(l+1))];
       end 
    end
    
    TempStimulus1BothStimuliIntervalHist1Sec(1:1:60)=0;
    TempStimulus2BothStimuliIntervalHist1Sec(1:1:60)=0;
    for Stimulus1InterNum=1:length(Stimulus1IntervalsBetweenAllEpokes)
       TempStimulus1BothStimuliIntervalHist1Sec=TempStimulus1BothStimuliIntervalHist1Sec+(histcounts(Stimulus1IntervalsBetweenAllEpokes(Stimulus1InterNum)/30,[0:1:60]))*Stimulus1IntervalsBetweenAllEpokes(Stimulus1InterNum)/30;
    end
    for Stimulus2InterNum=1:length(Stimulus2IntervalsBetweenAllEpokes)
        TempStimulus2BothStimuliIntervalHist1Sec=TempStimulus2BothStimuliIntervalHist1Sec+(histcounts(Stimulus2IntervalsBetweenAllEpokes(Stimulus2InterNum)/30,[0:1:60]))*Stimulus2IntervalsBetweenAllEpokes(Stimulus2InterNum)/30;
    end

    Stimulus1IntervalTimesBothStimuli1SecAll=[Stimulus1IntervalTimesBothStimuli1SecAll;TempStimulus1BothStimuliIntervalHist1Sec];
    Stimulus2IntervalTimesBothStimuli1SecAll=[Stimulus2IntervalTimesBothStimuli1SecAll;TempStimulus2BothStimuliIntervalHist1Sec]; 
        
    %%%%%%%%%%% Transitions %%%%%%%%%%%%%%%%%%%%%%%%
    
    LastStimulusToExplore=0;
    TransitionTimes=[];
    while min([Stimulus1InteractionsStart Stimulus2InteractionsStart])<100000
       StimulusToExplore=min([Stimulus1InteractionsStart Stimulus2InteractionsStart]);
       if find(Stimulus1InteractionsStart==StimulusToExplore)
          if LastStimulusToExplore==2
             TransitionTimes=[TransitionTimes,StimulusToExplore]; 
             LastStimulusToExplore=1;
             Stimulus1InteractionsStart(find(Stimulus1InteractionsStart==StimulusToExplore))=100001;
          elseif LastStimulusToExplore==0
             LastStimulusToExplore=1; 
             Stimulus1InteractionsStart(find(Stimulus1InteractionsStart==StimulusToExplore))=100001;
          else
             Stimulus1InteractionsStart(find(Stimulus1InteractionsStart==StimulusToExplore))=100001; 
          end
       elseif find(Stimulus2InteractionsStart==StimulusToExplore)
         if LastStimulusToExplore==1
            TransitionTimes=[TransitionTimes,StimulusToExplore]; 
            LastStimulusToExplore=2;
            Stimulus2InteractionsStart(find(Stimulus2InteractionsStart==StimulusToExplore))=100001;
         elseif LastStimulusToExplore==0
            LastStimulusToExplore=2; 
            Stimulus2InteractionsStart(find(Stimulus2InteractionsStart==StimulusToExplore))=100001;
         else
            Stimulus2InteractionsStart(find(Stimulus2InteractionsStart==StimulusToExplore))=100001; 
         end   
      end
   end
 
   TempTransitionTimesForHist=[];
   [TempTransitionTimesForHist,NotForUse] = hist(TransitionTimes,Bins);
   TransitionTimesForHistAll=[TransitionTimesForHistAll; TempTransitionTimesForHist];
   TransitionTimesForHistAllForRaster{i}=TransitionTimes;
end

TransitionsAlongTimeInMinutes=[];
for i=1:size(TransitionTimesForHistAll,2)
   if mod(i,3)==1 && i+2<=size(TransitionTimesForHistAll,2)
      TransitionsAlongTimeInMinutes=[TransitionsAlongTimeInMinutes, mean(TransitionTimesForHistAll(:,i:i+2),2)];
   end
end

 ShortLongInteractionsStimulus1=[squeeze(sum(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),1)) squeeze(sum(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),1))  squeeze(sum(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),1))  Stimulus1TotalExplorationPopulationSummary'/30];
 ShortLongInteractionsStimulus2=[squeeze(sum(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),1)) squeeze(sum(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),1))  squeeze(sum(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),1))  Stimulus2TotalExplorationPopulationSummary'/30];
 
if handles.PopulationShortVsLongBoutsInvestigationTimeCheckbox.Value==1
    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
    hold on;
    bar([1 3 5 7],mean(ShortLongInteractionsStimulus1,1),0.4,'g');
    bar([2 4 6 8],mean(ShortLongInteractionsStimulus2,1),0.4,'r');     
    errorbar([1 3 5 7],mean(ShortLongInteractionsStimulus1,1),...
       std(ShortLongInteractionsStimulus1,0,1)/sqrt(size(ShortLongInteractionsStimulus1,1)),'g','LineStyle','none')
    errorbar([2 4 6 8],mean(ShortLongInteractionsStimulus2,1),...
       std(ShortLongInteractionsStimulus2,0,1)/sqrt(size(ShortLongInteractionsStimulus2,1)),'r','LineStyle','none')
    xlim([0 9]);
    ax = gca;
    ax.XTick=[1.5 3.5 5.5 7.5];
    ax.XTickLabel = ({'0-6','7-19','20-max','Total time'});
    ylabel({'Investigation time','(Sec)'});
    xlabel('Bout duration (Sec)')
    title('Short vs long bouts - total time');
    legend([Stimulus1Name ' (n=' num2str(size(ShortLongInteractionsStimulus1,1)) ')'],[Stimulus2Name ' (n=' num2str(size(ShortLongInteractionsStimulus2,1)) ')'])
    hold off; 
    CurrentSubplot=CurrentSubplot+1;
 end

 if handles.PopulationOneSecHistBoutsDurationCheckbox.Value==1
    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
    hold on;
    errorbar(mean(Stimulus1EpokeDurationHist1SecAll,1),...
       std(Stimulus1EpokeDurationHist1SecAll,0,1)/sqrt(size(Stimulus1EpokeDurationHist1SecAll,1)),'gx')
    errorbar(mean(Stimulus2EpokeDurationHist1SecAll,1),...
       std(Stimulus2EpokeDurationHist1SecAll,0,1)/sqrt(size(Stimulus2EpokeDurationHist1SecAll,1)),'rx')
    xlim([0 61]);
    ax = gca;
    ylabel({'Investigation time','(Sec)'});
    xlabel('Bout duration (Sec)')
    title('1 sec bin histogram of bouts');
    legend([Stimulus1Name ' (n=' num2str(size(ShortLongInteractionsStimulus1,1)) ')'],[Stimulus2Name ' (n=' num2str(size(ShortLongInteractionsStimulus2,1)) ')'])
    hold off; 
    CurrentSubplot=CurrentSubplot+1;
 end
 
 if handles.PopulationShortVsLongBoutsRDI_Checkbox.Value==1
    RDI0_6=[];
    for i=1:size(ShortLongInteractionsStimulus1,1)
       RDI0_6(i)=(ShortLongInteractionsStimulus1(i,1)-ShortLongInteractionsStimulus2(i,1))...
       /(ShortLongInteractionsStimulus1(i,1)+ShortLongInteractionsStimulus2(i,1));    
    end

    RDI7_19=[];
    for i=1:size(ShortLongInteractionsStimulus1,1)
       RDI7_19(i)=(ShortLongInteractionsStimulus1(i,2)-ShortLongInteractionsStimulus2(i,2))...
       /(ShortLongInteractionsStimulus1(i,2)+ShortLongInteractionsStimulus2(i,2));    
    end

    RDI20_Max=[];
    for i=1:size(ShortLongInteractionsStimulus1,1)
       RDI20_Max(i)=(ShortLongInteractionsStimulus1(i,3)-ShortLongInteractionsStimulus2(i,3))...
       /(ShortLongInteractionsStimulus1(i,3)+ShortLongInteractionsStimulus2(i,3));    
    end

    RDITotal=[];
    for i=1:length(Stimulus1TotalExplorationPopulationSummary)
       RDITotal(i)=(Stimulus1TotalExplorationPopulationSummary(i)-Stimulus2TotalExplorationPopulationSummary(i))...
       /(Stimulus1TotalExplorationPopulationSummary(i)+Stimulus2TotalExplorationPopulationSummary(i));    
    end

    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
    hold on;
    RDI0_6=RDI0_6(find(RDI0_6~=Inf & ~isnan(RDI0_6)));
    RDI7_19=RDI7_19(find(RDI7_19~=Inf & ~isnan(RDI7_19)));
    RDI20_Max=RDI20_Max(find(RDI20_Max~=Inf & ~isnan(RDI20_Max)));
    RDITotal=RDITotal(find(RDITotal~=Inf & ~isnan(RDITotal)));

    bar([1 2 3 4],[mean(RDI0_6,2) mean(RDI7_19,2) mean(RDI20_Max,2) mean(RDITotal,2)],'b');
    errorbar(1,mean(RDI0_6,2),std(RDI0_6,0,2)/sqrt(length(RDI0_6)),'b');
    errorbar(2,mean(RDI7_19,2),std(RDI7_19,0,2)/sqrt(length(RDI7_19)),'b');
    errorbar(3,mean(RDI20_Max,2),std(RDI20_Max,0,2)/sqrt(length(RDI20_Max)),'b');
    errorbar(4,mean(RDITotal,2),std(RDITotal,0,2)/sqrt(length(RDITotal)),'b');
    xlim([0 5]);
    ax = gca;
    ax.XTick=[1 2 3 4];
    ax.XTickLabel = ({'0-6','7-19','20-max','Total time'});
    ylabel('RDI');
    xlabel('Bout duration (Sec)')
    title('Short vs long bouts - RDI');
    text(1,mean(RDI0_6,2)+0.05,['n=' num2str(length(RDI0_6))]);
    text(2,mean(RDI7_19,2)+0.05,['n=' num2str(length(RDI7_19))]);
    text(3,mean(RDI20_Max,2)+0.05,['n=' num2str(length(RDI20_Max))]);
    text(4,mean(RDITotal,2)+0.05,['n=' num2str(length(RDITotal))]);
    hold off; 
    CurrentSubplot=CurrentSubplot+1;
 end
 
if handles.PopulationBoutsLessThen6SecAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),3),0.4,'g');
   bar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),3),std(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),0,3)/sqrt(size(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),3),std(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),0,3)/sqrt(size(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1EpoksTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1EpoksTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1EpoksTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Investigation time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1EpoksTimesDurationsBinsAll(:,1,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus2EpoksTimesDurationsBinsAll(:,1,:),3)) ')'])
   title('<6 sec bouts along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationBouts6to19secAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),3),0.4,'g');
   bar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),3),std(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),0,3)/sqrt(size(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),3),std(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),0,3)/sqrt(size(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1EpoksTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1EpoksTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1EpoksTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Investigation time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1EpoksTimesDurationsBinsAll(:,2,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus2EpoksTimesDurationsBinsAll(:,2,:),3)) ')'])
   title('6-19 sec bouts along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationBoutsMoreThen19SecAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),3),0.4,'g');
   bar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),3),std(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),0,3)/sqrt(size(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2EpoksTimesDurationsBinsAll,1)*2],mean(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),3),std(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),0,3)/sqrt(size(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1EpoksTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1EpoksTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1EpoksTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Investigation time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1EpoksTimesDurationsBinsAll(:,3,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus2EpoksTimesDurationsBinsAll(:,3,:),3)) ')'])
   title('>19 sec bouts along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationChamberMeanBoutLength_Checkbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:3:size(Stimulus1MeanBoutLengthAlongTime,2)*3],mean(Stimulus1MeanBoutLengthAlongTime,1),0.3,'g');
   bar([2:3:size(Stimulus2MeanBoutLengthAlongTime,2)*3],mean(Stimulus2MeanBoutLengthAlongTime,1),0.3,'r');
   bar([3:3:size(BothStimulusMeanBoutLengthAlongTime,2)*3],mean(BothStimulusMeanBoutLengthAlongTime,1),0.3,'b');
   errorbar([1:3:size(Stimulus1MeanBoutLengthAlongTime,2)*3],mean(Stimulus1MeanBoutLengthAlongTime,1),std(Stimulus1MeanBoutLengthAlongTime,0,1)/sqrt(size(Stimulus1MeanBoutLengthAlongTime,1)),'g','LineStyle','none');
   errorbar([2:3:size(Stimulus2MeanBoutLengthAlongTime,2)*3],mean(Stimulus2MeanBoutLengthAlongTime,1),std(Stimulus2MeanBoutLengthAlongTime,0,1)/sqrt(size(Stimulus2MeanBoutLengthAlongTime,1)),'r','LineStyle','none');
   errorbar([3:3:size(BothStimulusMeanBoutLengthAlongTime,2)*3],mean(BothStimulusMeanBoutLengthAlongTime,1),std(BothStimulusMeanBoutLengthAlongTime,0,1)/sqrt(size(BothStimulusMeanBoutLengthAlongTime,1)),'b','LineStyle','none');
   ax = gca;
   ax.XTick=2:3:(size(Stimulus2MeanBoutLengthAlongTime,2)*3+2);
   clear TempXLabels
   TempXLabels{1,size(Stimulus2MeanBoutLengthAlongTime,2)}=[];
   for i=1:size(Stimulus2MeanBoutLengthAlongTime,2)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Bout duration','(Sec)'})
   legend(Stimulus1Name,Stimulus2Name,'Both stimuli')
   title('Mean bout duration along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

ShortLongIntervalsStimulus1=[squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),1)) squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),1))  squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),1))...
                                (squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),1))+squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),1))+squeeze(sum(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),1)))];
ShortLongIntervalsStimulus2=[squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),1)) squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),1))  squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),1))...
                                (squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),1))+squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),1))+squeeze(sum(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),1)))];
 
if handles.PopulationShortVsLongIntervalsTotalTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1 3 5 7],mean(ShortLongIntervalsStimulus1,1),0.4,'g');
   bar([2 4 6 8],mean(ShortLongIntervalsStimulus2,1),0.4,'r');  
   errorbar([1 3 5 7],mean(ShortLongIntervalsStimulus1,1),...
      std(ShortLongIntervalsStimulus1,0,1)/sqrt(size(ShortLongIntervalsStimulus1,1)),'g','LineStyle','none')
   errorbar([2 4 6 8],mean(ShortLongIntervalsStimulus2,1),...
      std(ShortLongIntervalsStimulus2,0,1)/sqrt(size(ShortLongIntervalsStimulus2,1)),'r','LineStyle','none')
   xlim([0 9]);
   ax = gca;
   ax.XTick=[1.5 3.5 5.5 7.5];
   ax.XTickLabel = ({'0-5','6-20','21-max','Total time'});
   ylabel({'Interval time','(Sec)'});
   xlabel('Interval duration (Sec)')
   title('Short vs long intervals - total time');
   legend([Stimulus1Name ' (n=' num2str(size(ShortLongIntervalsStimulus1,1)) ')'],[Stimulus2Name ' (n=' num2str(size(ShortLongIntervalsStimulus2,1)) ')'])
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationOneSecHistIntervalsEachStimulusCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   errorbar(mean(Stimulus1OnlyIntervalTimesDurations1SecAll,1),...
      std(Stimulus1OnlyIntervalTimesDurations1SecAll,0,1)/sqrt(size(Stimulus1OnlyIntervalTimesDurations1SecAll,1)),'gx')
   errorbar(mean(Stimulus2OnlyIntervalTimesDurations1SecAll,1),...
      std(Stimulus2OnlyIntervalTimesDurations1SecAll,0,1)/sqrt(size(Stimulus2OnlyIntervalTimesDurations1SecAll,1)),'rx')
   xlim([0 61]);
   ax = gca;
   ylabel({'Interval time','(Sec)'});
   xlabel('Interval duration (Sec)')
   title('1 sec bin histogram of intervals');
   legend([Stimulus1Name ' (n=' num2str(size(ShortLongIntervalsStimulus1,1)) ')'],[Stimulus2Name ' (n=' num2str(size(ShortLongIntervalsStimulus2,1)) ')'])
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end
% 
% if handles.PopulationOneSecHistIntervalsTwoStimuliCheckbox.Value==1
%    subplot(NumOfSubplotsRows,3,CurrentSubplot); 
%    hold on;
%    errorbar(mean(Stimulus1IntervalTimesBothStimuli1SecAll,1),...
%       std(Stimulus1IntervalTimesBothStimuli1SecAll,0,1)/sqrt(size(Stimulus1IntervalTimesBothStimuli1SecAll,1)),'gx')
%    errorbar(mean(Stimulus2IntervalTimesBothStimuli1SecAll,1),...
%       std(Stimulus2IntervalTimesBothStimuli1SecAll,0,1)/sqrt(size(Stimulus2IntervalTimesBothStimuli1SecAll,1)),'rx')
%    xlim([0 61]);
%    ax = gca;
%    ylabel('Time of intervals (Sec)');
%    xlabel('Intervals duration (Sec)')
%    title('Total time of Intervals between the two stimuli (30Hz recording)');
%    legend(['After ' Stimulus1Name ' (n=' num2str(size(ShortLongIntervalsStimulus1,1)) ')'],['After ' Stimulus2Name ' (n=' num2str(size(ShortLongIntervalsStimulus2,1)) ')'])
%    hold off; 
%    CurrentSubplot=CurrentSubplot+1;
% end
 
if handles.PopulationShortVsLongIntervalsRDICheckbox.Value==1
   RDIInterval_0_5=[];
   for i=1:size(ShortLongIntervalsStimulus1,1)
      RDIInterval_0_5(i)=(ShortLongIntervalsStimulus1(i,1)-ShortLongIntervalsStimulus2(i,1))...
      /(ShortLongIntervalsStimulus1(i,1)+ShortLongIntervalsStimulus2(i,1));    
   end
   
   RDIInterval_6_20=[];
   for i=1:size(ShortLongIntervalsStimulus1,1)
      RDIInterval_6_20(i)=(ShortLongIntervalsStimulus1(i,2)-ShortLongIntervalsStimulus2(i,2))...
      /(ShortLongIntervalsStimulus1(i,2)+ShortLongIntervalsStimulus2(i,2));    
   end

   RDIInterval_21_Max=[];
   for i=1:size(ShortLongIntervalsStimulus1,1)
      RDIInterval_21_Max(i)=(ShortLongIntervalsStimulus1(i,3)-ShortLongIntervalsStimulus2(i,3))...
      /(ShortLongIntervalsStimulus1(i,3)+ShortLongIntervalsStimulus2(i,3));    
   end
   
   RDIInterval_Total=[];
   for i=1:size(ShortLongIntervalsStimulus1,1)
      RDIInterval_Total(i)=(ShortLongIntervalsStimulus1(i,4)-ShortLongIntervalsStimulus2(i,4))...
      /(ShortLongIntervalsStimulus1(i,4)+ShortLongIntervalsStimulus2(i,4));    
   end

   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   RDIInterval_0_5=RDIInterval_0_5(find(RDIInterval_0_5~=Inf & ~isnan(RDIInterval_0_5)));
   RDIInterval_6_20=RDIInterval_6_20(find(RDIInterval_6_20~=Inf & ~isnan(RDIInterval_6_20)));
   RDIInterval_21_Max=RDIInterval_21_Max(find(RDIInterval_21_Max~=Inf & ~isnan(RDIInterval_21_Max)));
   RDIInterval_Total=RDIInterval_Total(find(RDIInterval_Total~=Inf & ~isnan(RDIInterval_Total)));

   bar([1 2 3 4],[mean(RDIInterval_0_5,2) mean(RDIInterval_6_20,2) mean(RDIInterval_21_Max,2) mean(RDIInterval_Total,2)],'b');
   errorbar(1,mean(RDIInterval_0_5,2),std(RDIInterval_0_5,0,2)/sqrt(length(RDIInterval_0_5)),'b');
   errorbar(2,mean(RDIInterval_6_20,2),std(RDIInterval_6_20,0,2)/sqrt(length(RDIInterval_6_20)),'b');
   errorbar(3,mean(RDIInterval_21_Max,2),std(RDIInterval_21_Max,0,2)/sqrt(length(RDIInterval_21_Max)),'b');
   errorbar(4,mean(RDIInterval_Total,2),std(RDIInterval_Total,0,2)/sqrt(length(RDIInterval_Total)),'b');
   xlim([0 5]);
   ax = gca;
   ax.XTick=[1 2 3 4];
   ax.XTickLabel = ({'0-5','6-20','21-max','Total time'});
   ylabel('RDI (Intervals)');
   xlabel('Interval duration (Sec)')
   title('Short vs long intervals - RDI');
   text(1,mean(RDIInterval_0_5,2)+0.05,['n=' num2str(length(RDIInterval_0_5))]);
   text(2,mean(RDIInterval_6_20,2)+0.05,['n=' num2str(length(RDIInterval_6_20))]);
   text(3,mean(RDIInterval_21_Max,2)+0.05,['n=' num2str(length(RDIInterval_21_Max))]);
   text(4,mean(RDIInterval_Total,2)+0.05,['n=' num2str(length(RDIInterval_Total))]);
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end
 
if handles.PopulationIntervalsLessThen5SecAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),3),0.4,'g');
   bar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),3),std(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),0,3)/sqrt(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),3),std(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),0,3)/sqrt(size(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,1,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Interval time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,1,:),3)) ')'])
   title('<5 sec intervals along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationIntervals5to20SecAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),3),0.4,'g');
   bar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),3),std(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),0,3)/sqrt(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),3),std(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),0,3)/sqrt(size(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,2,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Interval time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,2,:),3)) ')'])
   title('5-20 sec intervals along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationIntervalsMoreThen20SecAlongTimeCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),3),0.4,'g');
   bar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),3),0.4,'r');
   errorbar([1:2:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),3),std(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),0,3)/sqrt(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),3)),'g','LineStyle','none');
   errorbar([2:2:size(Stimulus2OnlyIntervalTimesDurationsBinsAll,1)*2],mean(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),3),std(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),0,3)/sqrt(size(Stimulus2OnlyIntervalTimesDurationsBinsAll(:,3,:),3)),'r','LineStyle','none');
   ax = gca;
   ax.XTick=1.5:2:(size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)*2+0.5);
   clear TempXLabels
   TempXLabels{1,size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)}=[];
   for i=1:size(Stimulus1OnlyIntervalTimesDurationsBinsAll,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)')
   ylabel({'Interval time','(Sec)'})
   legend([Stimulus1Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),3)) ')'],[Stimulus2Name ' (n=' num2str(size(Stimulus1OnlyIntervalTimesDurationsBinsAll(:,3,:),3)) ')'])
   title('>20 sec intervals along time')
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.TransitionsBetweenStimuliRasterCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   for i=1:length(TransitionTimesForHistAllForRaster)
      CurrentTransitionTimes=[];
      CurrentTransitionTimes=TransitionTimesForHistAllForRaster{i};
      RasterRowNum=[];
      RasterRowNum(1:1:length(CurrentTransitionTimes))=i;
      scatter(CurrentTransitionTimes/30,RasterRowNum,'b'); 
   end
   ax1 = gca;
   ax1.YColor = 'b';
   xlabel('Time (Sec)');
   xlim([0 size(TransitionTimesForHistAll,2)*20+10])
   ylim([0 i+2])
   ylabel(ax1,'Animal number');
   title('Transitions between stimuli - raster plot');
   ax1 = gca;
   ax1_pos = ax1.Position;
   ax2 = axes('Position',ax1_pos,'XAxisLocation','bottom','YAxisLocation','right','Color','none');
   ax2.YColor = 'r';
   line(10:20:size(TransitionTimesForHistAll,2)*20,mean(TransitionTimesForHistAll),'Parent',ax2,'Color','r','LineWidth',2)
   xlim([0 size(TransitionTimesForHistAll,2)*20+10])
   ylabel(ax2,'Transitions #');
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.TransitionsAlongTime1MinbinCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   bar([1:1:size(TransitionsAlongTimeInMinutes,2)],mean(TransitionsAlongTimeInMinutes,1),0.4,'b');
   errorbar([1:1:size(TransitionsAlongTimeInMinutes,2)],mean(TransitionsAlongTimeInMinutes,1),std(TransitionsAlongTimeInMinutes,0,1)/sqrt(size(TransitionsAlongTimeInMinutes,1)),'b','LineStyle','none');
   ax = gca;
   ax.XTick=1:1:(size(TransitionsAlongTimeInMinutes,1)+1);
   clear TempXLabels
   TempXLabels{1,size(TransitionsAlongTimeInMinutes,1)}=[];
   for i=1:size(TransitionsAlongTimeInMinutes,1)
      TempXLabels{1,i}=num2str(i);
   end
   ax.XTickLabel = (TempXLabels);
   xlabel('Time (min)');
   ylabel('Transitions #');
   title('Transitions between stimuli along time');
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.PopulationHeatMapInteractionDurationCheckbox.Value==1
   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   imagesc(1:size(Stimulus1InteractionHeattMap,2)/30,1:size(Stimulus1InteractionHeattMap,1),Stimulus1InteractionHeattMap); axis tight;
   set(gca,'ydir','normal');
   xlabel('Time (Sec)');
   ylabel('Animal number');
   caxis([0,20]);
   title(['Heat-map of bout duration with ' Stimulus1Name]);
   hold off; 
   CurrentSubplot=CurrentSubplot+1;

   subplot(NumOfSubplotsRows,3,CurrentSubplot); 
   hold on;
   imagesc(1:size(Stimulus2InteractionHeattMap,2)/30,1:size(Stimulus2InteractionHeattMap,1),Stimulus2InteractionHeattMap); axis tight;
   set(gca,'ydir','normal');
   xlabel('Time (Sec)');
   ylabel('Animal number');
   colorscale = colorbar;
   caxis([0,20]);
   colorscale.Label.String = 'Bout duration (Sec)';
   colorscale.Ticks=[0,3,6,9,12,15,18,20];
   colorscale.TickLabels={'0','3','6','9','12','15','18','>=20'};
   title(['Heat-map of bout duration with ' Stimulus2Name]);
   hold off; 
   CurrentSubplot=CurrentSubplot+1;
end

if handles.ExportToExcelPopVideoChamberAloneCheckbox.Value==1
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%% saving analyzed results to Excel file for statistical analysis  %%%%%%%  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

   Stimulus1TotalTime=(Stimulus1TotalExplorationPopulationSummary/30)';
   Stimulus2TotalTime=(Stimulus2TotalExplorationPopulationSummary/30)';

   Stimulus1PrecentOfTotal=[];
   Stimulus2PrecentOfTotal=[];
   for i=1:length(Stimulus1TotalExplorationPopulationSummary)
      Stimulus1PrecentOfTotal(i)=Stimulus1TotalExplorationPopulationSummary(i)/(Stimulus1TotalExplorationPopulationSummary(i)+Stimulus2TotalExplorationPopulationSummary(i));
      Stimulus2PrecentOfTotal(i)=Stimulus2TotalExplorationPopulationSummary(i)/(Stimulus1TotalExplorationPopulationSummary(i)+Stimulus2TotalExplorationPopulationSummary(i));
   end
   Stimulus1PrecentOfTotal=Stimulus1PrecentOfTotal';
   Stimulus2PrecentOfTotal=Stimulus2PrecentOfTotal';
 
   RDI0_6=RDI0_6';
   RDI7_19=RDI7_19';
   RDI20_Max=RDI20_Max';
   RDITotal=RDITotal';
   RDI0_6(length(RDI0_6):length(Stimulus1TotalTime))=NaN;
   RDI7_19(length(RDI7_19):length(Stimulus1TotalTime))=NaN;
   RDI20_Max(length(RDI20_Max):length(Stimulus1TotalTime))=NaN;
   RDITotal(length(RDITotal):length(Stimulus1TotalTime))=NaN;
   
   TotalTimeStim1_0to6secInteractions=ShortLongInteractionsStimulus1(:,1);
   TotalTimeStim1_7to19secInteractions=ShortLongInteractionsStimulus1(:,2);
   TotalTimeStim1_20toMaxsecInteractions=ShortLongInteractionsStimulus1(:,3);
   TotalTimeStim2_0to6secInteractions=ShortLongInteractionsStimulus2(:,1);
   TotalTimeStim2_7to19secInteractions=ShortLongInteractionsStimulus2(:,2);
   TotalTimeStim2_20toMaxsecInteractions=ShortLongInteractionsStimulus2(:,3);

   IntervalsTimeStim1_Total=ShortLongIntervalsStimulus1(:,4);
   IntervalsTimeStim2_Total=ShortLongIntervalsStimulus2(:,4);

  
   IntervalsTimeStim1_0to5secIntervals=ShortLongIntervalsStimulus1(:,1);
   IntervalsTimeStim1_6to20secIntervals=ShortLongIntervalsStimulus1(:,2);
   IntervalsTimeStim1_21toMaxsecIntervals=ShortLongIntervalsStimulus1(:,3);
   IntervalsTimeStim2_0to5secIntervals=ShortLongIntervalsStimulus2(:,1);
   IntervalsTimeStim2_6to20secIntervals=ShortLongIntervalsStimulus2(:,2);
   IntervalsTimeStim2_21toMaxsecIntervals=ShortLongIntervalsStimulus2(:,3);

   try
      TotalTimeStim1_0to6_Interactions_Minute1=squeeze(Stimulus1EpoksTimesDurationsBinsAll(1,1,:));
   catch
      TotalTimeStim1_0to6_Interactions_Minute1=[];  
   end
   try
      TotalTimeStim1_0to6_Interactions_Minute2=squeeze(Stimulus1EpoksTimesDurationsBinsAll(2,1,:));
   catch
      TotalTimeStim1_0to6_Interactions_Minute2=[]; 
   end
   try
      TotalTimeStim1_0to6_Interactions_Minute3=squeeze(Stimulus1EpoksTimesDurationsBinsAll(3,1,:));
   catch
      TotalTimeStim1_0to6_Interactions_Minute3=[]; 
   end
   try
      TotalTimeStim1_0to6_Interactions_Minute4=squeeze(Stimulus1EpoksTimesDurationsBinsAll(4,1,:));
   catch
      TotalTimeStim1_0to6_Interactions_Minute4=[]; 
   end
   try
      TotalTimeStim2_0to6_Interactions_Minute1=squeeze(Stimulus2EpoksTimesDurationsBinsAll(1,1,:));
   catch
      TotalTimeStim2_0to6_Interactions_Minute1=[]; 
   end
   try
      TotalTimeStim2_0to6_Interactions_Minute2=squeeze(Stimulus2EpoksTimesDurationsBinsAll(2,1,:));
   catch
      TotalTimeStim2_0to6_Interactions_Minute2=[]; 
   end
   try
      TotalTimeStim2_0to6_Interactions_Minute3=squeeze(Stimulus2EpoksTimesDurationsBinsAll(3,1,:));
   catch
      TotalTimeStim2_0to6_Interactions_Minute3=[]; 
   end
   try
      TotalTimeStim2_0to6_Interactions_Minute4=squeeze(Stimulus2EpoksTimesDurationsBinsAll(4,1,:));
   catch
      TotalTimeStim2_0to6_Interactions_Minute4=[]; 
   end
   
   
   try
      TotalTimeStim1_7to19_Interactions_Minute1=squeeze(Stimulus1EpoksTimesDurationsBinsAll(1,2,:));
   catch
      TotalTimeStim1_7to19_Interactions_Minute1=[];  
   end
   try
      TotalTimeStim1_7to19_Interactions_Minute2=squeeze(Stimulus1EpoksTimesDurationsBinsAll(2,2,:));
   catch
      TotalTimeStim1_7to19_Interactions_Minute2=[]; 
   end
   try
      TotalTimeStim1_7to19_Interactions_Minute3=squeeze(Stimulus1EpoksTimesDurationsBinsAll(3,2,:));
   catch
      TotalTimeStim1_7to19_Interactions_Minute3=[]; 
   end
   try
      TotalTimeStim1_7to19_Interactions_Minute4=squeeze(Stimulus1EpoksTimesDurationsBinsAll(4,2,:));
   catch
      TotalTimeStim1_7to19_Interactions_Minute4=[]; 
   end
   try
      TotalTimeStim2_7to19_Interactions_Minute1=squeeze(Stimulus2EpoksTimesDurationsBinsAll(1,2,:));
   catch
      TotalTimeStim2_7to19_Interactions_Minute1=[]; 
   end
   try
      TotalTimeStim2_7to19_Interactions_Minute2=squeeze(Stimulus2EpoksTimesDurationsBinsAll(2,2,:));
   catch
      TotalTimeStim2_7to19_Interactions_Minute2=[]; 
   end
   try
      TotalTimeStim2_7to19_Interactions_Minute3=squeeze(Stimulus2EpoksTimesDurationsBinsAll(3,2,:));
   catch
      TotalTimeStim2_7to19_Interactions_Minute3=[]; 
   end
   try
      TotalTimeStim2_7to19_Interactions_Minute4=squeeze(Stimulus2EpoksTimesDurationsBinsAll(4,2,:));
   catch
      TotalTimeStim2_7to19_Interactions_Minute4=[]; 
   end
   
   try
      TotalTimeStim1_20toMax_Interactions_Minute1=squeeze(Stimulus1EpoksTimesDurationsBinsAll(1,3,:));
   catch
      TotalTimeStim1_20toMax_Interactions_Minute1=[]; 
   end   
   try
      TotalTimeStim1_20toMax_Interactions_Minute2=squeeze(Stimulus1EpoksTimesDurationsBinsAll(2,3,:));
   catch
      TotalTimeStim1_20toMax_Interactions_Minute2=[]; 
   end    
   try
      TotalTimeStim1_20toMax_Interactions_Minute3=squeeze(Stimulus1EpoksTimesDurationsBinsAll(3,3,:));
   catch
      TotalTimeStim1_20toMax_Interactions_Minute3=[]; 
   end    
   try
      TotalTimeStim1_20toMax_Interactions_Minute4=squeeze(Stimulus1EpoksTimesDurationsBinsAll(4,3,:));
   catch
      TotalTimeStim1_20toMax_Interactions_Minute4=[]; 
   end    
   try
      TotalTimeStim2_20toMax_Interactions_Minute1=squeeze(Stimulus2EpoksTimesDurationsBinsAll(1,3,:));
   catch
      TotalTimeStim2_20toMax_Interactions_Minute1=[]; 
   end    
   try
      TotalTimeStim2_20toMax_Interactions_Minute2=squeeze(Stimulus2EpoksTimesDurationsBinsAll(2,3,:));
   catch
      TotalTimeStim2_20toMax_Interactions_Minute2=[]; 
   end    
   try
      TotalTimeStim2_20toMax_Interactions_Minute3=squeeze(Stimulus2EpoksTimesDurationsBinsAll(3,3,:));
   catch
      TotalTimeStim2_20toMax_Interactions_Minute3=[]; 
   end    
   try
      TotalTimeStim2_20toMax_Interactions_Minute4=squeeze(Stimulus2EpoksTimesDurationsBinsAll(4,3,:));
   catch
      TotalTimeStim2_20toMax_Interactions_Minute4=[]; 
   end    

   try
      TransitionsAlongTimeInMinutes_Minute1=TransitionsAlongTimeInMinutes(:,1);
   catch
      TransitionsAlongTimeInMinutes_Minute1=[]; 
   end     
   try
      TransitionsAlongTimeInMinutes_Minute2=TransitionsAlongTimeInMinutes(:,2);
   catch
      TransitionsAlongTimeInMinutes_Minute2=[]; 
   end     
   try
      TransitionsAlongTimeInMinutes_Minute3=TransitionsAlongTimeInMinutes(:,3);
   catch
      TransitionsAlongTimeInMinutes_Minute3=[]; 
   end     
   try
      TransitionsAlongTimeInMinutes_Minute4=TransitionsAlongTimeInMinutes(:,4);
   catch
      TransitionsAlongTimeInMinutes_Minute4=[]; 
   end     
   try
      TransitionsAlongTimeInMinutes_Minute5=TransitionsAlongTimeInMinutes(:,5);
   catch
      TransitionsAlongTimeInMinutes_Minute5=[]; 
   end     


   TotalTransitionsNum=sum(TransitionTimesForHistAll,2);

   T = table(Stimulus1TotalTime,Stimulus2TotalTime,Stimulus1PrecentOfTotal,Stimulus2PrecentOfTotal,RDI0_6,RDI7_19,RDI20_Max,RDITotal, ...
   TotalTimeStim1_0to6secInteractions,TotalTimeStim1_7to19secInteractions,TotalTimeStim1_20toMaxsecInteractions,TotalTimeStim2_0to6secInteractions,TotalTimeStim2_7to19secInteractions,TotalTimeStim2_20toMaxsecInteractions, ...
   IntervalsTimeStim1_Total,IntervalsTimeStim2_Total,IntervalsTimeStim1_0to5secIntervals,IntervalsTimeStim1_6to20secIntervals,IntervalsTimeStim1_21toMaxsecIntervals,IntervalsTimeStim2_0to5secIntervals, ...
   IntervalsTimeStim2_6to20secIntervals,IntervalsTimeStim2_21toMaxsecIntervals, ...
   TotalTimeStim1_0to6_Interactions_Minute1,TotalTimeStim1_0to6_Interactions_Minute2,TotalTimeStim1_0to6_Interactions_Minute3,TotalTimeStim1_0to6_Interactions_Minute4, ...
   TotalTimeStim2_0to6_Interactions_Minute1,TotalTimeStim2_0to6_Interactions_Minute2,TotalTimeStim2_0to6_Interactions_Minute3,TotalTimeStim2_0to6_Interactions_Minute4, ...
   TotalTimeStim1_7to19_Interactions_Minute1,TotalTimeStim1_7to19_Interactions_Minute2,TotalTimeStim1_7to19_Interactions_Minute3,TotalTimeStim1_7to19_Interactions_Minute4,...
   TotalTimeStim2_7to19_Interactions_Minute1,TotalTimeStim2_7to19_Interactions_Minute2,TotalTimeStim2_7to19_Interactions_Minute3,TotalTimeStim2_7to19_Interactions_Minute4,...
   TotalTimeStim1_20toMax_Interactions_Minute1,TotalTimeStim1_20toMax_Interactions_Minute2,TotalTimeStim1_20toMax_Interactions_Minute3,TotalTimeStim1_20toMax_Interactions_Minute4, ...
   TotalTimeStim2_20toMax_Interactions_Minute1,TotalTimeStim2_20toMax_Interactions_Minute2,TotalTimeStim2_20toMax_Interactions_Minute3,TotalTimeStim2_20toMax_Interactions_Minute4, ...
   TransitionsAlongTimeInMinutes_Minute1,TransitionsAlongTimeInMinutes_Minute2,TransitionsAlongTimeInMinutes_Minute3,TransitionsAlongTimeInMinutes_Minute4,TransitionsAlongTimeInMinutes_Minute5);
   fileID='PopulationVideoChamberAnalysisResults.xlsx';
   writetable(T,fileID);
    
end


      



      

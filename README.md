# TrackRodent
rodent tracking systems (mice and rats)

TrackRodent is a free custom-made software published following the paper: 
"A novel system for tracking social preference dynamics reveals sex-, strain- and species-specific characteristics" 
from the lab of Dr. Shlomo Wagner at Haifa university.

The software can, as any standard rodents' tracking software, track a single black mouse or white rat and extract basic parameters according to the experimental task (location, time in compartments...). In addition, the software outputs the times of interactions with "stimuli areas" that can be definds by the experimenter. This gives the option of extracting interactions times in an accurate manar. 

The output files holds matlab matrices from which the experimenter can easily pull the analyzed data and average accross subject animals.

The relevant algorithms and their functions are:
1) Body-based algorithm mouse (MiceMovieAnalyzerSRM23_7_14):
   For tracking black mice and their interaction with the stimulus area with their entire body.
2) Head-directionality based (MiceMovieAnalyzerSRM10_3_2016):
   For tracking black mice head and the head interaction with the stimulus area.
3) Wired body-based (MiceMovieAnalyzerSRM4_11_15):
   For tracking wired black mice and their interaction with the stimulus area with their entire body.
4) Body-based algorithm rat (RatMovieAnalyzerSRM15_7_15):
   For tracking white rats and their interaction with the stimulus area with their entire body.
Runing the algorithms allows extraction of the data and in addition saving an analyzed movie. In this movie, a curser on the rodent changes its color according to the action (interaction with a specific stimulus). 

Each algorithm has also a *_Fast version that extracts the results without saving the analyzed movie (please remove the save movie checkmark in the softwares GUI).

For more information please approach the paper or contact me
Shai Netser - shainetser@gmail.com


# TrackRodent
rodent tracking systems (mice and rats)

TrackRodent is a free custom-made software published following the paper: 
A novel, simple and affordable system for automatically tracking the dynamics of social preference in small rodents
from the lab of Dr. Shlomo Wagner at Haifa university.

The software can, as any standard rodents' tracking software, track a single mouse or rat and extract basic parameters according to the experimental task (location, time in compartments...). In addition, the software outputs the times of interactions with "stimuli areas" that can be definds by the experimenter. This gives the option of extracting interactions times in an accurate manar. 

The output files holds matlab matrices from which the experimenter can easily pul the analyzed data and average accross subject animals.

The relevant algorithms and their functions are:
1) MiceMovieAnalyzerSRM23_7_14 - for tracking black mice and their interaction with the stimulus area with their entire body.
2) MiceMovieAnalyzerSRM10_3_2016 - for tracking black mice head and the head interaction with the stimulus area.
3) MiceMovieAnalyzerSRM4_11_15 - for tracking wired black mice and their interaction with the stimulus area with their entire body.
4) RatMovieAnalyzerSRM15_7_15 - for tracking white rats and their interaction with the stimulus area with their entire body.
Runing the algorithms can allow extraction of the data and in addition saving an analyzed movie. In this movie, a curser on the rodents changes its color according to the action (interaction with a specific stimulus). 
Each algorithm has also a *_Fast version that extracks the results without saving the analyzed movie.


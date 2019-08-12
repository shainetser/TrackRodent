# TrackRodent
Rodent tracking systems (mice and rats)

TrackRodent is a free custom-made software published following the paper: 
"A novel system for tracking social preference dynamics reveals sex-, strain- and species-specific characteristics",
from the lab of Dr. Shlomo Wagner at Haifa university.

It is also explained in more details in the JoVE (Journal of visualized experiments) named the same. 

The software can, as any standard rodents' tracking software, track a single black or white mouse extract basic parameters according to the experimental task (location, time in compartments...). In addition, the software outputs the times of interactions with "stimuli areas" that can be definds by the experimenter. This gives the option of extracting interactions times in an accurate manar. 

The output files holds matlab matrices from which the experimenter can pull the analyzed data and average accross animals.

The relevant algorithms and their functions are:
1) Body-based algorithm for a black mouse (BlackMouseBodyBased23_7_14 and BlackMouseBodyBased23_7_14_Fast):
   For tracking black mice and their interaction with the stimulus area with their entire body.
2) Head-directionality based algorithm for a black mouse (BlackMouseHeadDirectionalityBased10_3_2016 and BlackMouseHeadDirectionalityBased10_3_2016_Fast):
   For tracking black mice head and the head interaction with the stimulus area.
3) Wired body-based algorithm for a black mouse (BlackMouseWiredBodyBased4_11_15 and BlackMouseWiredBodyBased4_11_15_Fast):
   For tracking wired black mice and their interaction with the stimulus area with their entire body.
4) Body-based algorithm for a white mouse (WhiteMouseBodyBased11_6_17 and WhiteMouseBodyBased11_6_17_Fast):
   For tracking white mice and their interaction with the stimulus area with their entire body.
Runing the algorithms allows extraction of the data and in addition saving an analyzed movie. In this movie, a curser on the rodent changes its color according to the action (interaction with a specific stimulus). 

Most algorithms has also a *_Fast version that extracts the results without saving the analyzed movie.

Note: The software also includes the foundations for adding more algorithems in the future.

For more information please approach the papers or contact me: 
Shai Netser - shainetser@gmail.com


%%%%%%%%%%%% instructions for installing TrackRodent %%%%%%%%%%%%

%%%% TrackRodent is for matlab 2014a-2019a, but most of its functions 
%%%% and algorithms can work with earlier versions of matlab.
%%%% It has several algorithms, which are updated once a while.

%%%% Here are all the details about different things in the software that
%%%% might be confussing or a problem:

%%%%  1)If you cann't save figures of the results this might be the broblem: 
%%%%  Locating Ghostscript/pdftops - You may find a dialogue box appears when using export_fig, 
%%%%  asking you to locate either Ghostscript or pdftops. 
%%%%  These are separate applications which export_fig requires to perform certain functions. 
%%%%  If such a dialogue appears it is because export_fig can't find the application automatically. 
%%%%  This is because you either haven't installed it, or it isn't in the normal place. 
%%%%  Make sure you install the applications correctly first. They can be downloaded from the following places:
%%%%  1) Ghostscript: www.ghostscript.com (for saving in pdf format)
%%%%  2) pdftops (install the Xpdf package): www.foolabs.com/xpdf (for saving in an eps format)
%%%% Use the following webpage for more details: https://github.com/ojwoodford/export_fig/blob/master/README.md

%%%% 2)For working with the algorithm from 27-1-2015 you need the
%%%% folder of Viktor Witkovsky (witkovsky@savba.sk) Ver.: 31-Jul-2014
%%%% 18:27:32 for Ellipse fitting.
%%%% The ellipseFit4HC function is used.

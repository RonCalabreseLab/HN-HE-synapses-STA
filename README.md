# Spike-triggered averaging to find synaptic currents from HNs to HEs

## Usage:

Start by running 
`startSpkTrigAvgAnalysis.m` or `startSpkTrigAvgAnalysisTRY.m`.

## Notes from Sep 2016 - Cengiz Gunay

Added high-pass filtering option (default on) to current data, but the
change in synaptic weight estimates were <0.1%. Also made several
changes around to code to clean and streamline it.

## Notes from 21 October 2011 - Anca Doloc-Mihu

### Code from Mike (MTW) with STA analysis was modified by ADM.

To run it >startSpkTrigAvgAnalysis


### Features added (used STA = 0 for Anca's code):

0) No global variables. Used functions. Global data for each signal can
be given now via a windows. This way we allow for eg., to change the 
threshold value (time window) for each channel according to data.

1) Read 1 to 4 pre signals from file. And work with each one of them.
Write their resulted data in a corresponding file. After all signals
are done, write a file with all signals. This file can be used again
with the code. Warning: file name convention (must be used!!!) -
HN####toHE##_date.atf, where # is the signal number. There must be 2 
digits after HE in the file name; if one digit HE (eg., 8) then it 
should be written as 0X in the name of the file. You can have 1 to 4 
digits for the HN names, but one digit for each name (ie., it means you 
can have between 1 to 4 HN cells to analyze). File format: 
at the beginning, optional 10 lines of strings, then data given per 
columns as [time pre1 pre2 ... preN post].

2) Windows to allow user to remove spike traces from file; This can 
be done in 2 ways: by removing a number of spikes from the 
beginning/end of each burst of the signal, or by keeping a number of 
spikes in a burst counting from its middle spike. In addition, user can
manually remove those traces that she wishes, in a separate window.

3) After trace cleaning has been done: program plots in a window all 
traces (in the chosen window) and their average with peak and lows 
calculated by Mike's code; in a separate window this average is zoomed
in. Then, program writes new data to a file. Once all signal data have
been done, program writes all signals to new file (*_new*); this file 
can be re-used again with the code (remove "_new" from its name).


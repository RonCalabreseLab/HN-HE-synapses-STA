function displayGlobalDataUsed(sta_method, invertCorrectionTrace, ...
    invertTriggeringTrace, NdiscardFirst, NdiscardLast, IntervalPosLocal, ...
    IntervalNegLocal, IntervalPos, IntervalNeg, IntervalPos2, ...
    IntervalNeg2, IntervalPSCNeg, ISIburst, thresh, peak, Trefractory, ...
    CorrectionTrace, CT, CalcMin, spike_subtractor, spike_adder, Overlay, ...
    DataNames, x_label, yL, yH, xlabel1, ylabel1, FntS, TracesPerPage, ...
    NBurstsStat, PrintNext)

disp(['sta_method = ' num2str(sta_method) ', invertCorrectionTrace = ' ...
    num2str(invertCorrectionTrace) ', invertTriggeringTrace = ' ...
    num2str(invertTriggeringTrace)])
disp(['NdiscardFirst = ' num2str(NdiscardFirst) ', NdiscardLast = ' ...
    num2str(NdiscardLast)])
disp(['IntervalPosLocal = ' num2str(IntervalPosLocal) ', IntervalNegLocal = ' ...
    num2str(IntervalNegLocal)])
disp(['IntervalPos = ' num2str(IntervalPos) ', IntervalNeg = ' ...
    num2str(IntervalNeg)])
disp(['IntervalPos2 = ' num2str(IntervalPos2) ', IntervalNeg2 = ' ...
    num2str(IntervalNeg2)])
disp(['IntervalPSCNeg = ' num2str(IntervalPSCNeg) ', ISIburst = ' ...
    num2str(ISIburst)])
disp(['thresh = ' num2str(thresh) ', peak = ' num2str(peak)])
disp(['Trefractory = ' num2str(Trefractory) ', CorrectionTrace = ' ...
    num2str(CorrectionTrace) ', CT = ' num2str(CT) ', CalcMin = ' ...
    num2str(CalcMin)])
disp(['spike_subtractor = ' num2str(spike_subtractor) ', spike_adder = ' ...
    num2str(spike_adder)])
disp(['Overlay = ' num2str(Overlay) ', DataNames = ' ...
    num2str(DataNames)])
disp(['x_label = ' num2str(x_label) ', yL = ' num2str(yL) ...
    ', yH = ' num2str(yH) ', xlabel1 = ' num2str(xlabel1) ...
    ', ylabel1 = ' num2str(ylabel1)])
disp(['FntS = ' num2str(FntS) ', TracesPerPage = ' num2str(TracesPerPage) ...
    ', NBurstsStat = ' num2str(NBurstsStat) ...
    ', PrintNext = ' num2str(PrintNext) ])

%disp([' = ' num2str() ',  = ' num2str()])
end
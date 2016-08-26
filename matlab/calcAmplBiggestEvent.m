function [MaxNumT, MinNumT, MaxT, MinT, DifSynT] = ...
    calcAmplBiggestEvent(NNT, winFT, NPointsWinPSCNeg)

% calc amplitude of the biggest event (triggered spike)
MaxNumT = [];
MinNumT = [];
MaxT = [];
MinT = [];
DifSynT = [];

for NSpikeTrig = 1:NNT
     [MaxT(NSpikeTrig), MaxNumT(NSpikeTrig)] = max(winFT(NSpikeTrig,:));

     SynNumStartW = MaxNumT(NSpikeTrig) - NPointsWinPSCNeg;

     if (SynNumStartW >= 1)
          [MinT(NSpikeTrig), MinNumT(NSpikeTrig)] = ...
               min(winFT(NSpikeTrig, SynNumStartW:MaxNumT(NSpikeTrig)));
          MinNumT(NSpikeTrig) = SynNumStartW + MinNumT(NSpikeTrig);
     else
          %disp('Too large window for the synapse minimum definition!\n');
          SynNumStartW = 1;
          [MinT(NSpikeTrig), MinNumT(NSpikeTrig)] = ...
               min(winFT(NSpikeTrig, SynNumStartW:MaxNumT(NSpikeTrig)));
     end
     DifSynT(NSpikeTrig) = MaxT(NSpikeTrig) - MinT(NSpikeTrig);
end

end

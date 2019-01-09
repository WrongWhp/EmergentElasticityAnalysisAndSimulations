
close all
CloseAllFigsAndWaitBars
h_waitbar = waitbar(0, '');

for iT = 1:100
            iT
            wait_bar_message = sprintf('%d done with run %d', iT , 1);
            waitbar(iT * 1./path.run_steps, h_waitbar,  wait_bar_message)   
            pause(.16);
end


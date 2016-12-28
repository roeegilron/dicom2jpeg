function DicomToJPEGconverter()
%% Function to convert DICOMs to jpegs
% This function takes a directory with dicoms as input
% and converts them to a mirrored directory structure with jpegs in them.
% * note this this relies on directory being only one "deep".

% set params:
params.flatoutput = 1; %output all jpegs to bnc dir;
dirchosen = uigetdir(pwd,'Choose a directory with directories of dicoms');
dirsfound = findFilesBVQX(dirchosen,'*',struct('dirs',1));
bncdir = fullfile(pwd,'jpegs');

% get dirs, and make dirs
for d = 1:length(dirsfound)
    ffls = findFilesBVQX(dirsfound{d},'I*');
    for f = 1:length(ffls)
        if exist(ffls{f},'file');
            [pn,fn] = fileparts(ffls{f});
            [~,pn] = fileparts(pn);
            % read and plot file 
            [x, map] = dicomread(ffls{f});
            hfig = figure('visible','off');
            im = imagesc(x);
            colormap('gray');
            axis off
            
            % do annoying saving and printing 
            if params.flatoutput
                [s,UUID] = system('uuidgen'); % create unique id since dicoms named the same
                fnmuse = sprintf('XRAY-%.2d_%s_%s.jpeg',d,UUID,fn);
                fnsave = fullfile(bncdir,fnmuse);
            else
                outdir = fullfile(bncdir,pn);
                if f == 1 % only create dir once
                    mkdir(outdir);
                end
                fnsave = fullfile(outdir,[fn, '.jpeg']);
            end
            saveas(hfig, fullfile(fnsave));
        end
    end
end
end

function DicomToJPEGconverter()
%% Function to convert DICOMs to jpegs
% This function takes a directory with dicoms as input
% and converts them to a mirrored directory structure with jpegs in them.
% * note this this relies on directory being only one "deep".

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
            outdir = fullfile(bncdir,pn);
            if f == 1 % only create dir once 
                mkdir(outdir);
            end
            [x, map] = dicomread(ffls{f});
            hfig = figure('visible','off');
            im = imagesc(x);
            colormap('gray');
            axis off
            fnsave = fullfile(outdir,[fn, '.jpeg']);
            saveas(hfig, fullfile(fnsave));
        end
    end
end
end
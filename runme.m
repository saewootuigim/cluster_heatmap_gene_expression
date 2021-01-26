% This script reads log2-folded gene expression and plots clustering
% heat map.
% The script assumes
%   1. the data is tab delimited.
%   2. the file has .txt extension.
%   3. the files are in data folder.
%   4. the file has header.
% The script plots all files in the data folder and saves to figs folder.

close all
clear
clc

list = dir('data');
for i = 1 : length(list)
    if strcmp(list(i).name,'.') || strcmp(list(i).name,'..') || list(i).isdir
        % skip directories
        continue
    elseif ~contains(list(i).name, '.txt')
        error('Input data must be tab delimited and have .txt extension.')
    end
    
    % Read file.
    tic
    fprintf('processing %s ', list(i).name)    
    fileName = [list(i).folder, filesep, list(i).name];
    S = tdfread(fileName);
    
    % Extract gene names.
    fn = fieldnames(S);
    genes = strings(size(S.(fn{1}),1),1);
    for j = 1 : numel(fn)
        if ischar(S.(fn{j}))
            for k = 1 : length(S.(fn{j}))
                genes(k) = string(S.(fn{j})(k,:));
            end
            fn(j) = [];
            break
        end
    end
    
    % Prepare data.
    logGeneExprs = zeros(size(S.(fn{1}),1), numel(fn));
    for j = 1 : numel(fn)
        logGeneExprs(:,j) = S.(fn{j});
    end
    
    % Draw.
    obj = clustergram(logGeneExprs,'Colormap','redbluecmap','Standardize','column');
    
    % Get clustergram as a figure handle.
    hFig = findall(0,'type','figure', 'tag', 'Clustergram');
    cbButton = findall(hFig,'tag','HMInsertColorbar');
    ccb = get(cbButton,'ClickedCallback');
    set(cbButton,'State','on')
    ccb{1}(cbButton,[],ccb{2})
    
    % Save figure.
    figLoc = sprintf('figs%c%s',filesep,list(i).name);
    print(hFig,strrep(figLoc,'.txt','.eps'),'-depsc','-painters')
    print(hFig,strrep(figLoc,'.txt','.ps'),'-dpsc','-painters')
    print(hFig,strrep(figLoc,'.txt','.pdf'),'-dpdf','-painters')
    print(hFig,strrep(figLoc,'.txt','.png'),'-dpng','-r300')
    
    % Close figure and print elapse.
    close(hFig)
    fprintf(' elapse: %.2fs.\n', toc)
end
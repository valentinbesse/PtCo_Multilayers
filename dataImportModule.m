function dataImportModule(fileName,dataFolder,numberFile)

% function associated with scriptAnalyze.
% Data import loop

% Write by Valentin Besse
% CC-SA-BY

booleanTest = 0;    % DO NOT CHANGE

for ii = 1:numberFile
    
    if(exist(strcat(dataFolder,fileName{ii},'.mat'),'file')==0)
        
        if booleanTest == 0
            
            disp('Data import.')
            
            booleanTest = 1;
            
        end
        disp(ii)
        importDataCOMSOL(strcat(dataFolder,fileName{ii}));
        
    end
    
end

end
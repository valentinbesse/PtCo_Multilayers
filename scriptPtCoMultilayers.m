%%%%
%
% Script PtCo Multilayers
%
%%%%
%
% This code is dedicated to data's analysis from COMSOL simulation on PtCo
% multilayers configuration.
% 
%
%
% Write by
% valentin.besse@univ-lemans.fr
%
% Under GNU GPL v3.0 license.

clearvars,
close all,
clc,

%% Variables

% Path
dataFolder = [pwd,'\Data\'];

fileName{1} = 'PtCo_Multilayers_WithoutKapitza';
fileName{2} = 'PtCo_Multilayers_5e-9';
fileName{3} = 'PtCo_Multilayers_5e-10';
fileName{4} = 'PtCo_Multilayers_PtCoKapitza5e-9_PtSub5e-10';
fileName{5} = 'PtCo_Multilayers_PtCoKapitza5e-10_PtSub5e-9';

numberFile = size(fileName,2);



%% Data import
dataImportModule(fileName,dataFolder,numberFile)




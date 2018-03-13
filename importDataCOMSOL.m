function [] = importDataCOMSOL(fileName)

% function associated with scriptAnalyze.
% Exctract the data from COMSOL (heat diffusion).
% Modify for PtCo multilayers settings
%
% Write by Valentin Besse
% CC-SA-BY

% directory = [pwd,'\'];
File = importdata([fileName,'.txt']);

thicknessPt1 = 2.1e-9;  % metal layer thickness (nm)
thicknessPt2 = 1e-9;    % metal layer thickness (nm)
thicknessPt3 = 6.5e-9;  % metal layer thickness (nm)
thicknessCo1 = 1.75e-9; % metal layer thickness (nm)
thicknessMetal = (thicknessPt1 + 5*(thicknessPt2 + thicknessCo1) + thicknessPt3);
thicknessSub = 0.4e-6 - thicknessMetal;  % substrate layer thickness (um)
grating = 1.2e-6; % grating periodicity (um)
% nGratingPeriodName = size(gratingPeriodName,2);

% for ii = 1:nGratingPeriodName
%
%     if str2double(gratingPeriodName(ii)) == 0
%
%         grating = grating/10;
%
%     else
%
%         grating = str2double(gratingPeriodName(ii))*grating;
%
%     end
% end

% thermalExpansionCoeffMetal = 1e-5;  % Thermal Expansion Coefficient Metal
% thermalExpansionCoeffSubstrate = 1e-5;  % Thermal Expansion Coefficient Substrate

% Space and time domain

% x dimension
xMin = 0;
xMax = thicknessSub + thicknessMetal;
dx = 1e-9;    % x step
x = (xMin:dx:xMax); % x array
nx = length(x);

% y dimension
yMin = 0;
yMax = grating;
dy = 10e-9;   % y step
y = (yMin:dy:yMax); % y array
ny = length(y);

% t time
tMin = 0;
tMax = 8e-9;
dt = 0.01e-9; % t step (ns)
dtInterp = dt*1; % t step interpolation (ps)
t = (tMin:dtInterp:tMax);   % t array
nt = length(t);

T0 = 293.15;    % Temperature à t=0

if nx*ny ~= size(File,1) || nt ~= (size(File,2)-2)
    
    error('Problem between the definition of dimensions x and y and the import data.');
    
end

% Temperature matrice T(y,x,t)

T = zeros(ny,nx,nt);

for ii = 1:ny    % loop to
    
    T(ii,:,:) = File((ii-1)*nx+(1:nx),3:nt+2);
    
end

clear File

% Maximum/minimum temperature location/ Thermal expansion

TMax = zeros(1,nt); % Maximum temperature
TMin = zeros(1,nt); % Minimum temperature
% intTemp = zeros(ny,nt); % Thermal expansion
% intTMax = zeros(1,nt);  % Thermal expansion for maximal temperature
% intTMin = zeros(1,nt);  % Thermal expansion for minimal temperature
% ampTexp = zeros(1,nt);  % Amplitude of the thermal expansion
% intTexp = zeros(1,nt);  % Intensity of the thermal expansion

indicexend = find(round(x,10)==round(thicknessMetal,9));    % behind of metal layer
indicex = indicexend-1;
[indiceyMax,~] = find(T(:,indicex,:) == max(max(T(:,indicex,:))));


if(length(indiceyMax)>1)
    
    indiceyMax = indiceyMax(1);
    
end

[indiceyMin,~] = find(T(:,indicex,:) == min(min(T(:,indicex,:))));

if(length(indiceyMin)>1)
    
    indiceyMin = indiceyMin(1);
    
end


TMax(1,1:nt) = T(indiceyMax,indicex,:); % Maximum temperature
TMin(1,1:nt) = T(indiceyMin,indicex,:); % Minimum temperature

diffT = (TMax - TMin);

% for ii = 1:nt
%
%     for jj = 1:ny
%
%         for kk = 1:indicexend
%
%             intTemp(jj,ii) = intTemp(jj,ii)+((T(jj,kk,ii)-T0).*thermalExpansionCoeffMetal.*dx);
%
%         end
%
%         for kk = indicexend+1:nx
%
%             intTemp(jj,ii) = intTemp(jj,ii)+((T(jj,kk,ii)-T0).*thermalExpansionCoeffSubstrate.*dx);
%
%         end
%
%     end
%
% end
%
% intTMax(1,1:nt) = intTemp(indiceyMax,:);
% intTMin(1,1:nt) = intTemp(indiceyMin,:);
%
% ampTexp = (intTMax - intTMin);
% ampTexp = ampTexp./max(ampTexp);
% intTexp = ampTexp.^2;  % Intensity of the thermal expansion

figure(1)
plot(t.*1e9,TMax,'LineWidth',2)
ax1 = gca;
fig1 = gcf;
set(ax1,'FontSize',25,'FontName','CMU Serif','FontWeight','bold');
xlabel('Time (ns)','FontName','CMU Serif','FontWeight','bold')
ylabel('Temperature (C)','FontName','CMU Serif','FontWeight','bold')
set(fig1,'units','centimeters','outerposition',[0 0 40 30]) % format 4/3
print(strcat(fileName,'.png'),'-dpng')


indicetRescale = find(round(t,10) == 2e-9);

clear fig 1 ax1 directory File ii nt nx ny thicknessMetal thicknessSubstrate tMax tMin xMax xMin yMax yMin ii jj kk ans indicexend indiceytMax indiceytMin

save(strcat(fileName,'.mat'),'dt','dtInterp','dx','dy','grating','t','x','y','T','indiceyMax','indiceyMin','TMin','TMax','indicex','T0','indicetRescale','diffT')

end
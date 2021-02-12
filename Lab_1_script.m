%% Givens and basic information 
clear all
clc
payload = 500; %kg
%Payload includes any equipment hung below the balloon 
%Lab 303
%Group 3

%% Using the atmoscoesa function to find tempurature, presure and density 
%Get Tempurature (T), Outside air pressure (P_atm) and outside air density
%(rho_air) at the specified altitude (AltGiven) 
AltGiven = 25000;   % in meters
[T,~,P_atm,rho_air] = atmoscoesa(AltGiven);

FactorOfIncr = 0.1;
TempIncr = 80 * FactorOfIncr; %modify the tempurature given solar radiation 
n = 1.45; %factor of safety (we chose)
ys = 39*10^6; %Pa Yield strength of Polyurethane (found online)
deltaP = ys/(n); %Pa
%deltaP = P_in - P_out
P_in = deltaP + P_atm;%Pa

%% Using the Ideal Gas law to find the Density of Helium 
%PV = NRT 
%solving for rho_He
%using manipulation of law we derived
%P = rho_he*R_specHe*T
%solve for density of He (rho_He)
R = 8.3145; %J/(mol*K)  (Universal Gas constant) 
R_specHe = 2077.1; %J/(kg*K)    (Found online) %2077.1
rho_he = P_atm/(T*R_specHe); %kg/m^3

%% Finding radius of balloon
% rho_system = mass_system/volume_system = rho_atm
% rho_atm = (mass_payload + mass_shell_of_balloon +
% mass_He)/(volume_balloon)
rho_poly = 1210;
rho_paint = 2200;
rho_shell = rho_poly + rho_paint; %kg/m^3 %desnity of polyurethane that we are "purchasing"
mass_payload = 500; %kg
P_gauge = 10; %Pa
%the a and b quantities break up the equation into two parts
a = -1*rho_shell*(2*pi*P_gauge*n)/(ys);
b = (4/3)*pi*(rho_air-rho_he);

radius_balloon = (abs(mass_payload/(a+b)))^(1/3);
volume_balloon = (4/3)*pi*(radius_balloon^3);

%%Thickness Calculation
% t = P_gauge*r/2*sigma
sigma = ys / n;
thickness = (P_gauge*radius_balloon)/(2*sigma);%m

%%Mass of Shell
%SA times density gives mass of shell
%Surface_Area*thickness=volume of shell
Surface_Area = 4*pi*(radius_balloon)^2;
%by multiplying thickness by Surface Area we can solve for volume of shell
Volume_Shell = Surface_Area*thickness;
% Volume by rho gives mass of shell
Mass_Shell = Volume_Shell*rho_shell;%kg

%%Computing Mass of Helium Needed
%Volume of balloon by rho_helium gives mass of helium needed
Mass_Helium = volume_balloon*rho_he;

%%Total Payload
%Calculate the mass of the coating 
%Add all masses Together
Total_Payload = Mass_Helium+Mass_Shell+payload;

%% Increase in volume due to solar radiation increasing tempurature
% v = NRT/P 
% This is the molar mass of Helium in the balloon 
NHe  = (Mass_Helium * 1000)/4.003; 
% This is the new tempurature given the solar radiation on the balloon 
TNew = T + TempIncr;        
%Calculate the new Volume using the ideal gas law with the new values 
VolNew = (NHe * R * TNew)/P_atm; 
%determine the new (maximum) radius of the balloon. 
RNew = ((.75 * VolNew) / pi) ^ (1/3);
%find allowed increase in temp based off of density
max_density = Total_Payload/VolNew;

%% Output statement with final values 
fprintf("Under normal (night-time) operating conditions the following values apply: \n" + ...
    "Radius: %.2f m\nVolume: %.2f m^3\nMass of Shell: %.2f kg\nMass of Helium: %.2f kg\nMass of Payload: 500 kg\n" + ...
    "Total Payload: %.2f kg\nTemperature of Helium: %.2f K\n\n",radius_balloon,volume_balloon,Mass_Shell,Mass_Helium,Total_Payload, T);

fprintf("Under maximum (daytime) operating conditions these are the new Values: \n" + ...
    "Radius: %.2f m\nVolume: %.2f m^3\nMass of Shell: %.2f kg\nMass of Helium: %.2f kg\nMass of Payload: 500 kg\n" + ...
    "Total Payload: %.2f kg\nTemperature of Helium: %.2f K\n\nWith an assumed possible increase of up to 80 degrees K due to solar radiation, \nand " + ...
    "the maximum allowable increase in temperature due to solar radiation being 37.6 degrees K \nin order to remain within our +- 1km, " + ...
    "we are planning on coating the balloon in a highly reflective \nsubstance which will reflect at minimum 65 percent of solar radiation " + ...
    "causing a maximum increase \nof the helium of 28 degrees K. \n",RNew,VolNew,Mass_Shell,Mass_Helium,Total_Payload, TNew);

%% Density calculation and costs 
vol_of_quart = 0.000946353; %m^3
area_of_quart = vol_of_quart / thickness;
number_of_quarts = ceil(Surface_Area / area_of_quart);
cost_of_paint = number_of_quarts * 460;
fprintf('We will need %d quarts of paint to cover the balloon costing $%d', number_of_quarts, cost_of_paint)




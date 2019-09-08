function [schedule]=generateFlightRequest(numFlights,startHour,startMin,startSec,maxHours)
%This function generates a schedule based on the inputs to the function 
% Seed randomness for repetition testing
rng(0)
% Params to be fed 
if nargin <1
    numFlights=100;
    startHour=8;startMin=0;startSec=0;
    maxHours=10;
end
if nargin <2
    startHour=8;startMin=0;startSec=0;
    maxHours=10;
end
if nargin <3
    startMin=0;startSec=0;
    maxHours=10;
end
if nargin <4
    startSec=0;
    maxHours=10;
end
if nargin <5
    maxHours=10;
end

% Fixed Params
minHours=0;minMinutes=0;maxMinutes=59;

% Generate base time %TODO: make it "today"
baseTime=datetime(2019,6,20,startHour,startMin,startSec);

sprintf('Generating a schedule of %d drones from %.2d:%.2d:%.2d until %.2d:%.2d:%.2d',numFlights,startHour,startMin,startSec,startHour+maxHours,startMin,startSec)
% Generate Flight ID
FlightID=(1:1:numFlights);
FlightRequest=[];

% Randomly generate flight request and store as a double in terms of hours
FlightRequest=hours(hours(randi([minHours,maxHours],1,numFlights))+minutes(randi([minMinutes,maxMinutes],1,numFlights)));  

% Convert to dateTime object
FlightStartTime= datetime(baseTime)+hours(FlightRequest);    

% Store in table to be passed out
schedule=table(FlightID', sort(FlightStartTime)');
schedule.Properties.VariableNames={'FlightID','FlightStartTime'};
schedule.Properties.Description='This table is meant to be the schedule that is to be manipulated in the main script';
schedule.Properties.VariableDescriptions={'ID of Flights generated for analysis','Start time associated with this Flight ID'};
end
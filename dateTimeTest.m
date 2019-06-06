clc;clear all; close all
% Seed randomness for repetition testing
rng(0)
% Params to be fed 
startHour=8;startMin=0;startSec=0;
minHours=0;maxHours=10;minMinutes=0;maxMinutes=59;
numFlights=100;
% Generate base time
baseTime=datetime(2019,6,10,startHour,startMin,startSec);
% Generate Flight ID
FlightID=(1:1:numFlights);
FlightRequest=[];

% Randomly generate flight request and store as a double in terms of hours
FlightRequest=hours(hours(randi([minHours,maxHours],1,numFlights))+minutes(randi([minMinutes,maxMinutes],1,numFlights)));  

% Convert to dateTime object
FlightStartTime= datetime(baseTime)+hours(FlightRequest);    

% Store in table to be passed out
schedule=table(FlightID', sort(FlightStartTime)');
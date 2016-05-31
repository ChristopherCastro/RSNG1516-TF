addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');
clc
clear
M = 1; %Numero de máquinas
loadBalancer=0; %Reparto de carga entre máquinas.
        %0=Random
        %1=RR
        
machinesEvents = generador_1(0.1, 8, 3000, 12312, M, loadBalancer);

stats = {};
salida={};

for i=1:M
    fprintf('MachineID: %d\n', i);
    eventsQ = eventsQueue(machinesEvents{1,i});
    [salida{i}, stats{i}] = simpleSimulator(1, 10, eventsQ);
end



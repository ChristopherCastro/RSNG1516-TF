addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

clc;
clear;

runSets = {
    struct('M', 1, 'loadBalancer'),
};

% Numero de máquinas
M = 1;

% Reparto de carga entre máquinas:
%
% - 0: Random
% - 1: RR
loadBalancer = 0; 

% Número de peticiones a simular
numClients = 10000;


machinesEvents = generador_1(0.1, 8, 3000, 12312, M, loadBalancer);

stats = {};
salida={};

for i=1:M
    fprintf('MachineID: %d\n', i);
    eventsQ = eventsQueue(machinesEvents{1,i});
    [salida{i}, stats{i}] = simpleSimulator(1, 10, eventsQ);
end



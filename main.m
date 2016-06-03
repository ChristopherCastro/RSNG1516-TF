addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

clc;
clear;
seed = 89492162;

runSets = {
    %2016 05 31 Una máquina. Efecto del número de hilos y tamaño de cola
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
%     struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    
    %2016 06 01 M máquinas
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 0, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 10, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 50, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 6000, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 0, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 10, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 50, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 6000, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 0, 'machinesNumber', 3, 'loadBalancer', 1, 'numClients', 5000), ...
  struct('eventsGenerator', 1, 'lambda', 15, 'tmService', 0.05, 'nThreads', 1, 'waitQueueLen', 10000, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 10000)
% struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 3, 'nThreads', 5, 'waitQueueLen', 10, 'machinesNumber', 3, 'loadBalancer', 2, 'numClients', 1000)
};

runSetsResults = {};

for rIdx = 1:length(runSets)
    runSet = runSets{rIdx};
    enviromentStats = {};
    
    fprintf('==========================\n');
    fprintf('Starting Enviroment #(%d/%d)\n', rIdx, length(runSets));
    fprintf('  - Machine Numbers: %d\n', runSet.machinesNumber);
    fprintf('  - Load Balancer: %d\n', runSet.loadBalancer);
    fprintf('  - Number of Clients: %d\n', runSet.numClients);
    fprintf('  - Threads Number: %d\n', runSet.nThreads);
    fprintf('  - Wait Queue Size: %d\n', runSet.waitQueueLen);
    fprintf('  - Event Generator: %d\n', runSet.eventsGenerator);
    fprintf('    · Event Generator (Lambda): %d\n', runSet.lambda);
    fprintf('    · Event Generator (Service Time): %d\n', runSet.tmService);

    if runSet.eventsGenerator == 1
        machinesEvents = generador_1(runSet.lambda, runSet.tmService, runSet.numClients, seed, runSet.machinesNumber, runSet.loadBalancer);
    else
        machinesEvents = generador_2(runSet.lambda, runSet.tmService, runSet.numClients, seed, runSet.machinesNumber, runSet.loadBalancer);
    end;


    if runSet.loadBalancer == 2 %if 2 machines and load balancer type 2 .
        eventsQ = eventsQueue(machinesEvents{1, 1});
        enviromentStats{1} = simpleSimulator(runSet.nThreads, runSet.waitQueueLen, eventsQ);
        eventsQ = eventsQueue(machinesEvents{1, 2});
        %Machine 2 inverts nThreads<->waitQueueLen
        enviromentStats{2} = simpleSimulator(runSet.waitQueueLen, runSet.nThreads, eventsQ);
    else %normal execution
        for machineId = 1:runSet.machinesNumber
            eventsQ = eventsQueue(machinesEvents{1, machineId});
            enviromentStats{machineId} = simpleSimulator(runSet.nThreads, runSet.waitQueueLen, eventsQ);
        end;
    end

    runSetsResults{end + 1} = {runSet enviromentStats};
    fprintf('\nFinishing Eviroment! (%d/%d)\n\n', rIdx, length(runSets));
end



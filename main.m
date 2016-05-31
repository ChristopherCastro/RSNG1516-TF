addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

clc;
clear;
seed = 89492162;

runSets = {
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 1, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 3, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 10, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 50, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 2, 'nThreads', 5, 'waitQueueLen', 6000, 'machinesNumber', 1, 'loadBalancer', 1, 'numClients', 5000), ...
    
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

    for machineId = 1:runSet.machinesNumber
        eventsQ = eventsQueue(machinesEvents{1, machineId});
        enviromentStats{machineId} = simpleSimulator(runSet.nThreads, runSet.waitQueueLen, eventsQ);
    end;

    runSetsResults{end + 1} = enviromentStats;
    fprintf('\nFinishing Eviroment! (%d/%d)\n\n', rIdx, length(runSets));
end



addpath('Event/');
addpath('Event/Generator');
addpath('Machine');
addpath('Stats');

clc;
clear;
seed = 89492162;

runSets = {
    %2016 06 06 Marco teórico Diapositiva 1
    %struct('eventsGenerator', 1, 'lambda', 15, 'tmService', 0.05, 'nThreads', 1, 'waitQueueLen', Inf, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 20000)
    
    %2016 06 06 Marco teórico Diapositiva 2  
    %struct('eventsGenerator', 1, 'lambda', 550, 'tmService', 0.008, 'nThreads', 1, 'waitQueueLen', Inf, 'machinesNumber', 4, 'loadBalancer', 0, 'numClients', 15000)
    
    %2016 06 07 Pregunta 1 - ¿Cuál es el máximo número de peticiones por segundo que soportaremos con un único servidor con N hilos?
    %struct('eventsGenerator', 1, 'lambda', 0.00083, 'tmService', 60, 'nThreads', 1, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 20000),...
    %struct('eventsGenerator', 1, 'lambda', 0.0368, 'tmService', 60, 'nThreads', 5, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 20000),...
    %struct('eventsGenerator', 1, 'lambda', 0.1032, 'tmService', 60, 'nThreads', 10, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 20000),...
    %struct('eventsGenerator', 1, 'lambda', 0.7392, 'tmService', 60, 'nThreads', 50, 'waitQueueLen', 0, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 20000)
    %struct('eventsGenerator', 1, 'lambda', 0.070, 'tmService', 60, 'nThreads', 5, 'waitQueueLen', 5, 'machinesNumber', 1, 'loadBalancer', 0, 'numClients', 2000)
    
    %Pregunta Balanceadores de carga
    
    %Demand Based
    struct('eventsGenerator', 1, 'lambda', 1, 'tmService', 60, 'nThreads', 30, 'waitQueueLen', 50, 'machinesNumber', 2, 'loadBalancer', 2, 'numClients', 5000)
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
        machine = MachineSimulator(runSet.nThreads, runSet.waitQueueLen, eventsQ);
        enviromentStats{1} = machine.run();

        eventsQ = eventsQueue(machinesEvents{1, 2});
        machine = MachineSimulator(runSet.waitQueueLen, runSet.nThreads, eventsQ);
        enviromentStats{2} = machine.run();
    else
        for machineId = 1:runSet.machinesNumber
            eventsQ = eventsQueue(machinesEvents{1, machineId});
            machine = MachineSimulator(runSet.nThreads, runSet.waitQueueLen, eventsQ);
            enviromentStats{machineId} = machine.run();
        end;
    end

    runSetsResults{end + 1} = {runSet enviromentStats};
    fprintf('\nFinishing Eviroment! (%d/%d)\n\n', rIdx, length(runSets));
end



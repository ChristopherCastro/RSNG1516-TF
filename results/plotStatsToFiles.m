% This scripts takes a set of results and plots a fucking ton of things for
% each set, saving those plots on image files.

if exist('runSetsResults','var')
    for i=1:size(runSetsResults,2)
        runSet = runSetsResults{i};
        runSetConf = runSet{1};
        runSetStats = runSet{2};
        fprintf('==========================\n');
        fprintf('Plotting runSet %d\n', i);
        fprintf('  - Machine Numbers: %d\n', runSetConf.machinesNumber);
        fprintf('  - Load Balancer: %d\n', runSetConf.loadBalancer);
        fprintf('  - Number of Clients: %d\n', runSetConf.numClients);
        fprintf('  - Threads Number: %d\n', runSetConf.nThreads);
        fprintf('  - Wait Queue Size: %d\n', runSetConf.waitQueueLen);
        fprintf('  - Event Generator: %d\n', runSetConf.eventsGenerator);
        fprintf('    · Event Generator (Lambda): %d\n', runSetConf.lambda);
        fprintf('    · Event Generator (Service Time): %d\n', runSetConf.tmService);
        
        baseFileName = sprintf('[M=%d]_[LB=%d]_[Nclients=%d]_[Nthreads=%d]_[WqLen=%d]_[eGen=%d]_[lambda=%d]_[tmServ=%d]',...
                        runSetConf.machinesNumber, runSetConf.loadBalancer,...
                        runSetConf.numClients, runSetConf.nThreads,...
                        runSetConf.waitQueueLen,runSetConf.eventsGenerator,...
                        runSetConf.lambda, runSetConf.tmService);
        
        % Evolucion de numero de clientes en cada máquina

        % Evolución del tiempo medio de espera en la cola

        % Ratio rechazados

        % Evolucion de ro en cada máquina


        
    end
else
    disp('Error!: "runSetsResults" varable must exist on worspace!');
end
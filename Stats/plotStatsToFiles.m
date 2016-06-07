% This scripts takes a set of results and plots a fucking ton of things for
% each set, saving those plots on image files. 
% WARNING: Does not support plotting more than 10 machines.



if exist('runSetsResults','var')
    for i=1:size(runSetsResults,2)
        runSet = runSetsResults{i};
        runSetConf = runSet{1};
        if runSetConf.machinesNumber>10
            disp('Error: Can not plot more than 10 machines');
        else
            runSetStats = runSet{2};
            %Fill 10-M empty machines stats to plot nothing
            for j=(runSetConf.machinesNumber+1):10
                runSetStats{j} = StatsCollector();
            end
    %         fprintf('==========================\n');
            fprintf('Plotting runSet %d\n', i);
    %         fprintf('  - Machine Numbers: %d\n', runSetConf.machinesNumber);
    %         fprintf('  - Load Balancer: %d\n', runSetConf.loadBalancer);
    %         fprintf('  - Number of Clients: %d\n', runSetConf.numClients);
    %         fprintf('  - Threads Number: %d\n', runSetConf.nThreads);
    %         fprintf('  - Wait Queue Size: %d\n', runSetConf.waitQueueLen);
    %         fprintf('  - Event Generator: %d\n', runSetConf.eventsGenerator);
    %         fprintf('    · Event Generator (Lambda): %d\n', runSetConf.lambda);
    %         fprintf('    · Event Generator (Service Time): %d\n', runSetConf.tmService);

            baseFileName = sprintf('[M=%d][LB=%d][Nclients=%d][Nthreads=%d][WqLen=%d][eGen=%d][lambda=%d][tmServ=%d].png',...
                            runSetConf.machinesNumber, runSetConf.loadBalancer,...
                            runSetConf.numClients, runSetConf.nThreads,...
                            runSetConf.waitQueueLen,runSetConf.eventsGenerator,...
                            runSetConf.lambda, runSetConf.tmService);

            FigHandle = figure;
            set(FigHandle, 'Position', [100, 100, 1280, 800],'Visible','off','PaperPositionMode','auto');
            titulo = suptitle(baseFileName);
            set(FigHandle, 'visible', 'off'); %Yes, again. Messing with figure visibility because the fucking suptitle makes it visibile again.
            set(titulo,'FontSize',9,'FontWeight','normal');
            topLeft = subplot(2,2,1);
            topRight = subplot(2,2,2);
            bottomLeft = subplot(2,2,3);
            bottomRight = subplot(2,2,4);

            % Evolucion de numero de clientes esperando en cola en cada máquina
            plot(topLeft,runSetStats{1}.time, runSetStats{1}.countMeanClientsWaiting,...
                runSetStats{2}.time, runSetStats{2}.countMeanClientsWaiting,...
                runSetStats{3}.time, runSetStats{3}.countMeanClientsWaiting,...
                runSetStats{4}.time, runSetStats{4}.countMeanClientsWaiting,...
                runSetStats{5}.time, runSetStats{5}.countMeanClientsWaiting,...
                runSetStats{6}.time, runSetStats{6}.countMeanClientsWaiting,...
                runSetStats{7}.time, runSetStats{7}.countMeanClientsWaiting,...
                runSetStats{8}.time, runSetStats{8}.countMeanClientsWaiting,...
                runSetStats{9}.time, runSetStats{9}.countMeanClientsWaiting,...
                runSetStats{10}.time, runSetStats{10}.countMeanClientsWaiting);
            title(topLeft,'Numero medio de clientes en cola');
            xlabel(topLeft,'tiempo');
            ylabel(topLeft,'clientes en cola');
            for j=1:10
                if ~isempty(runSetStats{j}.time())
                    text(runSetStats{j}.time(end),runSetStats{j}.countMeanClientsWaiting(end),num2str(runSetStats{j}.countMeanClientsWaiting(end)),'Parent', topLeft);
                end
            end
            
            % Evolución del tiempo medio de espera en la cola
            plot(topRight,runSetStats{1}.time, runSetStats{1}.tMeanWaitQueue,...
                runSetStats{2}.time, runSetStats{2}.tMeanWaitQueue,...
                runSetStats{3}.time, runSetStats{3}.tMeanWaitQueue,...
                runSetStats{4}.time, runSetStats{4}.tMeanWaitQueue,...
                runSetStats{5}.time, runSetStats{5}.tMeanWaitQueue,...
                runSetStats{6}.time, runSetStats{6}.tMeanWaitQueue,...
                runSetStats{7}.time, runSetStats{7}.tMeanWaitQueue,...
                runSetStats{8}.time, runSetStats{8}.tMeanWaitQueue,...
                runSetStats{9}.time, runSetStats{9}.tMeanWaitQueue,...
                runSetStats{10}.time, runSetStats{10}.tMeanWaitQueue);
            title(topRight,'Tiempo medio espera en cola');
            xlabel(topRight,'tiempo');
            ylabel(topRight,'tMeanWaitQueue');
            xlabel(topLeft,'tiempo');
            ylabel(topLeft,'clientes en cola');
            for j=1:10
                if ~isempty(runSetStats{j}.time())
                    text(runSetStats{j}.time(end),runSetStats{j}.tMeanWaitQueue(end),num2str(runSetStats{j}.tMeanWaitQueue(end)),'Parent', topRight);
                end
            end
            
            
            % Ratio rechazados
            plot(bottomLeft,runSetStats{1}.time, runSetStats{1}.percentRejected,...
                runSetStats{2}.time, runSetStats{2}.percentRejected,...
                runSetStats{3}.time, runSetStats{3}.percentRejected,...
                runSetStats{4}.time, runSetStats{4}.percentRejected,...
                runSetStats{5}.time, runSetStats{5}.percentRejected,...
                runSetStats{6}.time, runSetStats{6}.percentRejected,...
                runSetStats{7}.time, runSetStats{7}.percentRejected,...
                runSetStats{8}.time, runSetStats{8}.percentRejected,...
                runSetStats{9}.time, runSetStats{9}.percentRejected,...
                runSetStats{10}.time, runSetStats{10}.percentRejected);
            title(bottomLeft,'% rechazos');
            xlabel(bottomLeft,'tiempo');
            ylabel(bottomLeft,'porcentaje rechazos');
            for j=1:10
                if ~isempty(runSetStats{j}.time())
                    text(runSetStats{j}.time(end),runSetStats{j}.percentRejected(end),num2str(runSetStats{j}.percentRejected(end)),'Parent', bottomLeft);
                end
            end

            
            
            % Evolucion de ro en cada máquina
            plot(bottomRight,runSetStats{1}.time, runSetStats{1}.meanRhoMM1,...
                runSetStats{2}.time, runSetStats{2}.meanRhoMM1,...
                runSetStats{3}.time, runSetStats{3}.meanRhoMM1,...
                runSetStats{4}.time, runSetStats{4}.meanRhoMM1,...
                runSetStats{5}.time, runSetStats{5}.meanRhoMM1,...
                runSetStats{6}.time, runSetStats{6}.meanRhoMM1,...
                runSetStats{7}.time, runSetStats{7}.meanRhoMM1,...
                runSetStats{8}.time, runSetStats{8}.meanRhoMM1,...
                runSetStats{9}.time, runSetStats{9}.meanRhoMM1,...
                runSetStats{10}.time, runSetStats{10}.meanRhoMM1);
            title(bottomRight,'Rho medio');
            xlabel(bottomRight,'tiempo');
            ylabel(bottomRight,'Rho medio');
            for j=1:10
                if ~isempty(runSetStats{j}.time())
                    text(runSetStats{j}.time(end),runSetStats{j}.meanRhoMM1(end),num2str(runSetStats{j}.meanRhoMM1(end)),'Parent', bottomRight);
                end
            end

            %saveas(FigHandle,baseFileName);
            print(baseFileName,'-dpng','-r0')
        end %if maxmachines end
        
    end %for end
else
    disp('Error!: "runSetsResults" varable must exist on workspace!');
end
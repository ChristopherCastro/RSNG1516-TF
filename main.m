addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

events = generador_1(0.2, 50, 2000, 254984519);
eventsQ = eventsQueue(events);
[salida] = simpleSimulator(2, 2, eventsQ);

fprintf('Salida thread1: %d elementos.\n', size(salida.queues{1}.queue,2));
fprintf('Salida thread2: %d elementos.\n', size(salida.queues{2}.queue,2));
fprintf('Rechazadas: %d elementos.\n', rechazadas);
fprintf('Total: %d elementos.\n', size(salida.queues{1}.queue,2)+size(salida.queues{2}.queue,2)+rechazadas);

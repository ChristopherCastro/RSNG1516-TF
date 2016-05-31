addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

events = generador_1(10, 50, 1000, 23543);
eventsQ = eventsQueue(events);
[salida, stats] = simpleSimulator(3, 10, eventsQ);

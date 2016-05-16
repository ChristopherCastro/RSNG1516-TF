addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

events = generador_1(0.2, 10, 10000, 254984519);
eventsQ = eventsQueue(events);
[salida] = simpleSimulator(2, 50, eventsQ);

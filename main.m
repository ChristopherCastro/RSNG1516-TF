addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');

events = generador_1(0.2, 50, 2000, 254984519);
eventsQ = eventsQueue(events);
[salida] = simpleSimulator(2, 2, eventsQ);

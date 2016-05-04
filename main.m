addpath('Event/');
addpath('Event/Generator');

events = generador_1(0.2, 5, 1000, 254984519);
queue = eventsQueue(events);
addpath('Event/');
addpath('Event/Generator');
addpath('Simulator');



colarara = eventsQueue([1 2 3 4 5 6 7 8 9]);

fprintf('Tamaño inicial: %d\n',colarara.size());

fprintf('first(): %d\n',colarara.first());

fprintf('Tamaño tras first: %d\n',colarara.size());

fprintf('next(): %d\n',colarara.next());

fprintf('Tamaño tras next: %d\n',colarara.size());

fprintf('next(): %d\n',colarara.next());

fprintf('Tamaño tras next: %d\n',colarara.size());
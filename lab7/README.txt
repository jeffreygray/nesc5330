README.TXT

TraceConditioning is an attempt to replicate NeuroJet.

Blake Thomas, William Levy, 2012

Test Networks:
4 neuron and 1000 neuron.

Confirmed matches in firing:
no learning, no dave's rule, no K0 corrector, no filter
no learning, no dave's rule, K0 corrector, no filter
no learning, dave's rule on, K0 corrector, no filter
no learning, dave's rule on, K0 corrector, filter on

Confirmed match in 4 neuron network
rise 0, filter on
rise 4, filter on

Things that will never work:
Learning on.

Why?

Because NeuroJet uses floats to store weights. MatLab uses doubles. 
After running one trial, about half of weights will be off by 1e-07, which I think is about the rounding error of a float.
Once ONE NEURON fires differently, the whole network will be different forever. 
This occurs even when the LARGEST DISCREPANCY IN A SINGLE WEIGHT IS LESS THAN 1e-06!!!

How to fix:
Make NeuroJet only store weights to 3 decimals. floor( 1000 * deltaW ) / 1000;
Chip likes this because it is more biological.
The quantal unit for conductance (10 pS) is probably on the order 1/500th of the strongest possible weight (5-10 nS).



FILTER.

NeuroJet does not convolve filters if you set the Synaptic filter before the DTSfilter.
It may be that the synapse filter is actually a filter for the interneurona nd the DTSfilter is for excitatory connections. 
THIS NEEDS TESTING.
Kai used both of these, and some sort of moving averager on the inhibitory filter. He did not dump the dendrite on a succesful fire.
Future research needs to be able to have neurons fire at a correct frequency. 


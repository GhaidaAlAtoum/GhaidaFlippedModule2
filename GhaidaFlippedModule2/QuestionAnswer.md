## No Team

## For Thought:

### If you made the FFT Magnitude Buffer a larger array, would your program still work properly? If yes, why? If not, what would you need to change?

No, the program will not work properly. The second half contains redundant information about negative frequencies that mirror the positive ones. For the second half we will have to shift
how we determine the bin maginutde. IE. for the first half we use f_k = (k.f_s)/N where k=0,1,...,N/2. For the second half f_k = ((k-N).f_s)/N where k=N/2+1,..., N-1

### Is pausing the audioManager object better than deallocating it when the view has disappeared (explain your reasoning)?

Per [Doc1](https://developer.apple.com/documentation/objectivec/nsobject/1571947-dealloc) and [Doc2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i) it seems defining the dealloc function
 (exists under Novocaine) is sufficient enough as during run time memory managment will determine the need to free or not. 

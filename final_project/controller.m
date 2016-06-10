function [chaos_val, success_val] = controller(a, b, c, d, e, f, g, h)
    rand = 9711963;
    rng(rand);
     
    chaos_val = [chaos(a), chaos(b), chaos(c), chaos(d), chaos(e), chaos(f), chaos(g), chaos(h)];
    
    success_val = [runSynaptogenesisModel(a), runSynaptogenesisModel(b), runSynaptogenesisModel(c), ...
        runSynaptogenesisModel(d), runSynaptogenesisModel(e), runSynaptogenesisModel(f), ...
        runSynaptogenesisModel(g), runSynaptogenesisModel(h)]
    
    